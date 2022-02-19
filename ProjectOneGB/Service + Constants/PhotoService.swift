//
//  PhotoService.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 23.01.2022.
//

import UIKit
import Alamofire


class PhotoService {
    
    //    создаем словарь изображений
    private var images = [String: UIImage]()
    private let cacheLifeTime: TimeInterval = 30 * 24 * 60 * 60
    
    
    private let container: DataReloadable
    
    init(container: UITableView) {
        self.container = Table(table: container)
    }
    
    
    init(container: UICollectionView) {
        self.container = Collection(collection: container)
    }
    
    //    получаем кэш директорию, если нет - возвращаем pathName
    //    составляем url из pathName и если файл существует - достаем
    private static let pathName: String = {
        let pathName = "images"
        
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return pathName }
        let url = cachesDirectory.appendingPathComponent(pathName, isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: url.path) {
            try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)
        }
        return pathName
    }()
    
    //    создаем метод для возвращения изображений
    //    если изображение есть в словаре image, хранится в оперативной памяти, приравниваем image к фото, если нет, то берем из кэша
    func photo(atIndexPath indexPath: IndexPath, byURL url: String) -> UIImage? {
        
        var image: UIImage?
        print(url)
        if let photo = images[url] {
            image = photo
        } else if let photo = getImageFromCache(url: url) {
            image = photo
        } else {
            //            если нет в кэше используем загрузку
            loadPhoto(atIndexPath: indexPath, byUrl: url)
        }
        return image
    }
    
    //    метод для получения изображения из кэша
    //    кэш работает в FileManager.default
    //    идет сравнение по дате изменения
    private func getImageFromCache(url: String) -> UIImage? {
        guard let fileName = getFilePath(url: url),
              let info = try? FileManager.default.attributesOfItem(atPath: fileName),
              let modificationDate = info[FileAttributeKey.modificationDate] as? Date else { return nil }
        let lifeTime = Date().timeIntervalSince(modificationDate)
        //        сравниваем с заданным временем жизни (1 месяц выставлен cacheLifeTime)
        guard lifeTime <= cacheLifeTime,
              let image = UIImage(contentsOfFile: fileName) else { return nil }
        DispatchQueue.main.async {
            self.images[url] = image
        }
        return image
    }
    
    //    метод получения файла по ключу
    //    достает папку из кэш директории, в которой хранится кэш
    //    хэшируем имя и передаем pathName, получаем путь до изображения
    private func getFilePath(url: String) -> String? {
        guard let cachesDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else { return nil }
        
        let hashName = url.split(separator: "/").last ?? "default"
        return cachesDirectory.appendingPathComponent(PhotoService.pathName + "/" + hashName).path
        
    }
    
    //    метод загрузки
    //    загружаем, проверяем дату, возвращаем в main
    private func loadPhoto(atIndexPath indexPath: IndexPath, byUrl url: String) {
        AF.request(url).responseData(queue: .global()) { [weak self] response in
            guard let data = response.data,
                  let image = UIImage(data: data) else { return }
            
            DispatchQueue.main.async {
                self?.images[url] = image
            }
            
            self?.saveImageToCache(url: url, image: image)
            
            DispatchQueue.main.async {
                self?.container.reloadRow(atIndexPath: indexPath)
            }
            
        }
    }
    
    //    получает путь файла через url, конвертируем картинку в data и сохраняем через FileManager, создаем файл, передаем путь и data
    private func saveImageToCache(url: String, image: UIImage) {
        guard let fileName = getFilePath(url: url),
              let data = image.pngData() else { return }
        
        print(fileName)
        FileManager.default.createFile(atPath: fileName, contents: data, attributes: nil)
    }
    
}

// создаем протокол для контейнера
// перезагружает контейнер с изображениями используя reloadRow
fileprivate protocol DataReloadable {
    func reloadRow(atIndexPath indexPath: IndexPath)
}

// расширения для таблиц и коллекций
// перезагружает таблицы и ячейки по indexPath
extension PhotoService {
    
    private class Table: DataReloadable {
        let table: UITableView
        
        init(table: UITableView) {
            self.table = table
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            table.reloadRows(at: [indexPath], with: .none)
        }
    }
    
    private class Collection: DataReloadable {
        let collection: UICollectionView
        
        init(collection: UICollectionView) {
            self.collection = collection
        }
        
        func reloadRow(atIndexPath indexPath: IndexPath) {
            collection.reloadItems(at: [indexPath])
        }
    }
}

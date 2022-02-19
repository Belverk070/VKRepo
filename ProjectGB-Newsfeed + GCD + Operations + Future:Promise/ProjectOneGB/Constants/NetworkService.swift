//
//  NetworkService.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 21.01.2022.
//

import Foundation
import PromiseKit

class NetworkService {
    
    private var urlConstructor = URLComponents()
    private var networkConstants = NetworkConstants()
    private let configuration: URLSessionConfiguration!
    private let session: URLSession!
    
    init(){
        urlConstructor.scheme = networkConstants.scheme
        urlConstructor.host = networkConstants.host
        configuration = URLSessionConfiguration.default
        session = URLSession(configuration: configuration)
    }
    
    func getURLGroups() -> URL? {
        urlConstructor.path = "/method/groups.get"
        
        urlConstructor.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "description"),
            URLQueryItem(name: "access_token", value: SessionData.instance.token),
            URLQueryItem(name: "v", value: networkConstants.versionAPI),
        ]
        return urlConstructor.url
    }
    
    func makeNewsRequest(completion: @escaping ([NewsModel]) -> Void, onError: @escaping (Error) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = networkConstants.scheme
        urlComponents.host = networkConstants.host
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "start_from", value: "next_from"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "v", value: networkConstants.versionAPI),
            URLQueryItem(name: "access_token", value: SessionData.instance.token)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            guard var news = try? JSONDecoder().decode(NewsfeedResponse.self, from: data!).response.items else {
                onError(ServerError.failedToDecode)
                return
            }
            
            guard let profiles = try? JSONDecoder().decode(NewsfeedResponse.self, from: data!).response.profiles else {
                onError(ServerError.failedToDecode)
                print("Error profiles")
                return
            }
            guard let groups = try? JSONDecoder().decode(NewsfeedResponse.self, from: data!).response.groups else {
                onError(ServerError.failedToDecode)
                print("Error groups")
                return
            }
            
            // Объединение массивов. Взял из примера работы + добавил в модель NewsModel, в которую входят необходимые переменные, думаю, этого не хватало в моей модели в том числе.
            for i in 0..<news.count {
                if news[i].sourceID < 0 {
                    let group = groups.first(where: { $0.id == -news[i].sourceID })
                    news[i].avatarURL = group?.photo100
                    news[i].creatorName = group?.name
                    
                } else {
                    let profile = profiles.first(where: { $0.id == news[i].sourceID })
                    news[i].avatarURL = profile?.photo100
                    news[i].creatorName = (profile?.firstName ?? "" ) + (profile?.lastName ?? "" )
                }
            }
            DispatchQueue.global().async {
                completion(news)
            }
        }.resume()
    }
    
    //   MARK - Future / Promise
    
    // Creating URL for request
    func getUrl() -> Promise<URL> {
        urlConstructor.path = "/method/newsfeed.get"
        urlConstructor.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "start_from", value: "next_from"),
            URLQueryItem(name: "count", value: "20"),
            URLQueryItem(name: "access_token", value: SessionData.instance.token),
            URLQueryItem(name: "v", value: networkConstants.versionAPI),
        ]
        
        return Promise { resolver in
            guard let url = urlConstructor.url else {
                resolver.reject(ServerError.notCorrectUrl)
                return
            }
            resolver.fulfill(url)
        }
    }
    
    // Creating request
    func getData(_ url: URL) -> Promise<Data> {
        return Promise { resolver in
            session.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    resolver.reject(ServerError.errorTask)
                    return
                }
                resolver.fulfill(data)
            }.resume()
        }
    }
    
    // Data parse
    func getParsedData(_ data: Data) -> Promise<Response> {
        return Promise { resolver in
            do {
                let response = try JSONDecoder().decode(NewsfeedResponse.self, from: data).response
                resolver.fulfill(response)
            } catch {
                resolver.reject(ServerError.failedToDecode)
            }
        }
    }
    
    func getNews(_ items: Response) -> Promise<[NewsModel]> {
        return Promise<[NewsModel]> { resolver in
            var news = items.items
            let groups = items.groups
            let profiles = items.profiles
            
            for i in 0..<news.count {
                if news[i].sourceID < 0 {
                    let group = groups.first(where: { $0.id == -news[i].sourceID })
                    news[i].avatarURL = group?.photo100
                    news[i].creatorName = group?.name
                } else {
                    let profile = profiles.first(where: { $0.id == news[i].sourceID })
                    news[i].avatarURL = profile?.photo100
                    news[i].creatorName = (profile?.firstName ?? "" ) + (profile?.lastName ?? "" )
                }
            }
            resolver.fulfill(news)
        }
    }
    
}


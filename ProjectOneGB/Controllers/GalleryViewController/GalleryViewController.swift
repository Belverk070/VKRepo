//
//  GalleryViewController.swift
//  ProjectOneGB
//
//  Created by Василий Метлин on 20.10.2021.
//
import UIKit
import Kingfisher
import Realm
import RealmSwift

class GalleryViewController: UIViewController {
    
    var networkConstants = NetworkConstants()
    @IBOutlet weak var galleryView: GalleryHorisontalView!
    var friend: Friend?
    var userID: Int?
    var photos = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        makeGalleryRequest()
    }
    
//    func makeGalleryRequest() {
//        var urlComponents = URLComponents()
//        urlComponents.scheme = networkConstants.scheme
//        urlComponents.host = networkConstants.host
//        urlComponents.path = "/method/photos.getAll"
//        urlComponents.queryItems = [
//            URLQueryItem(name: "owner_id", value: String(SessionData.instance.userId ?? 1)),
//            URLQueryItem(name: "v", value: networkConstants.versionAPI),
//            URLQueryItem(name: "access_token", value: SessionData.instance.token)
//        ]
//        let request = URLRequest(url: urlComponents.url!)
//        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
//            do {
//                guard let data = data else { return }
//                let fetchedResponse = try? JSONDecoder().decode(VKFriendsPhotoResponse.self, from: data)
//                let gallery = fetchedResponse?.response.items
////                print(gallery)
//            } catch DecodingError.dataCorrupted(let context) {
//                print(DecodingError.dataCorrupted(context))
//            } catch DecodingError.keyNotFound(let key, let context) {
//                print(DecodingError.keyNotFound(key,context))
//            } catch DecodingError.typeMismatch(let type, let context) {
//                print(DecodingError.typeMismatch(type,context))
//            } catch DecodingError.valueNotFound(let value, let context) {
//                print(DecodingError.valueNotFound(value,context))
//            } catch let error{
//                print(error)
//            }
//        }.resume()
//    }
}


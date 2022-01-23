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
    
    //    var fetchedFriends = [PhotoResponse]()
    //    var photoCollection = [FriendPhotos]()
    var photos = [UIImage]()
    
    override func viewDidLoad() {
        //        self.photoCollection = [FriendPhotos]()
        
        super.viewDidLoad()
        
        makeGalleryRequest()
        
        
    }
    
    func makeFriendsRequest() {
        var urlComponents = URLComponents()
        urlComponents.scheme = networkConstants.scheme
        urlComponents.host = networkConstants.host
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "city,domain,sex,bdate,photo_100"),
            URLQueryItem(name: "v", value: networkConstants.versionAPI),
            URLQueryItem(name: "access_token", value: SessionData.instance.token)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            do {
                guard let data = data else { return }
                let fetchedResponse = try JSONDecoder().decode(VKFriendResponse.self, from: data)
                let friends = fetchedResponse.response?.items
                self?.userID = self?.friend?.id
                print(friends)
                print(SessionData.instance.token)
                print(self?.userID)
            } catch {
                print(error)
            }
        }.resume()
    }
    
    
    func makeGalleryRequest() {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = networkConstants.scheme
        urlComponents.host = networkConstants.host
        urlComponents.path = "/method/photos.getAll"
        urlComponents.queryItems = [
            URLQueryItem(name: "owner_id", value: String(friend?.id ?? 1)),
            URLQueryItem(name: "v", value: networkConstants.versionAPI),
            URLQueryItem(name: "access_token", value: SessionData.instance.token)
        ]
        let request = URLRequest(url: urlComponents.url!)
        
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            
            do {
                guard let data = data else { return }
                let fetchedResponse = try? JSONDecoder().decode(VKFriendsPhotoResponse.self, from: data)
                let gallery = fetchedResponse?.response.items
                print(gallery)
            } catch DecodingError.dataCorrupted(let context) {
                print(DecodingError.dataCorrupted(context))
            } catch DecodingError.keyNotFound(let key, let context) {
                print(DecodingError.keyNotFound(key,context))
            } catch DecodingError.typeMismatch(let type, let context) {
                print(DecodingError.typeMismatch(type,context))
            } catch DecodingError.valueNotFound(let value, let context) {
                print(DecodingError.valueNotFound(value,context))
            } catch let error{
                print(error)
            }
        }.resume()
    }
}


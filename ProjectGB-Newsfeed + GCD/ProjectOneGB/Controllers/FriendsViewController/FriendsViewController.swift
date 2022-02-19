//
//  FriendsViewController.swift
//  ProjectOneGB
//
//  Created by Василий Метлин on 17.10.2021.
//

import Foundation
import UIKit
import RealmSwift
import Kingfisher

class FriendsViewController: UIViewController {
    
    var friends = [Friend]()
    var networkConstatns = NetworkConstants()
    var photos = [UIImage]()
    var realmManger = RealmManager()
    var notificationToken: NotificationToken?
    var dataSource: Results<Friend>?
    let refreshControl = UIRefreshControl()
    let reuseIdentifierCustom = "reuseIdentifierCustom"
    let fromFriendsToGallery = "fromFriendsToGallery"
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var friendsTableView: UITableView!
    
    override func viewDidLoad() {
        
        friendsTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCustom)
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        friendsTableView.addSubview(refreshControl)
        //        dataSource = realmManger.getFriends()
        matchRealm()
        friendsTableView.reloadData()
        
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        makeFriendsRequest()
        friendsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func matchRealm() {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: config)
        dataSource = realm.objects(Friend.self)
        notificationToken = dataSource?.observe { [weak self] changes in
            switch changes {
            case let .update(results, deletions, insertions, modifications):
                self?.friendsTableView.beginUpdates()
                self?.friendsTableView.insertRows(at: insertions.map {IndexPath(row: $0, section: 0)}, with: .fade)
                self?.friendsTableView.deleteRows(at: deletions.map {IndexPath(row: $0, section: 0)}, with: .fade)
                self?.friendsTableView.reloadRows(at: modifications.map {IndexPath(row: $0, section: 0)}, with: .fade)
                self?.friendsTableView.endUpdates()
                print("updated")
            case .initial:
                self?.friendsTableView.reloadData()
                print("Initial")
            case .error:
                print("Error")
            }
        }
    }
    
    func makeFriendsRequest() {
        var urlComponents = URLComponents()
        urlComponents.scheme = networkConstatns.scheme
        urlComponents.host = networkConstatns.host
        urlComponents.path = "/method/friends.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "fields", value: "city,domain,sex,bdate,photo_100"),
            URLQueryItem(name: "v", value: networkConstatns.versionAPI),
            URLQueryItem(name: "access_token", value: SessionData.instance.token)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            do {
                guard let data = data else { return }
                let fetchedResponse = try JSONDecoder().decode(VKFriendResponse.self, from: data)
                let friends = fetchedResponse.response?.items
                //
                print(friends)
                print(SessionData.instance.token)
                
                DispatchQueue.main.async {
                    self?.friendsTableView.reloadData()
                    self?.realmManger.saveFriends(data: Array(friends!))
                }
                
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == fromFriendsToGallery,
    //           //                      let sourceVC = segue.source as? FriendsViewController,
    //           let destinationVC = segue.destination as? GalleryViewController,
    //           let friend = sender as? FriendPhotos {
    //            if let url = URL(string: friend.sizes?.url ?? "empty") {
    //                let task = URLSession.shared.dataTask(with: url) { data, response, error in
    //                    guard let data = data, error == nil else { return }
    ////                    print(data)
    //                    DispatchQueue.main.async { /// execute on main thread
    //                        destinationVC.photos = self.photos
    //                    }
    //                }
    //                task.resume()
    //            }
    //        }
    //    }
}

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //        performSegue(withIdentifier: fromFriendsToGallery, sender: arrayByLetter(sourceArray: friendsArray, letter: arrayLetter[indexPath.section])[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCustom, for: indexPath) as? CustomTableViewCell else {return UITableViewCell()}
        cell.configure(friend: dataSource![indexPath.row], completion: { [weak self] myfriend in
            guard let self = self else {return}
            self.performSegue(withIdentifier: self.fromFriendsToGallery, sender: myfriend)
        }
        )
        
        return cell
    }
}

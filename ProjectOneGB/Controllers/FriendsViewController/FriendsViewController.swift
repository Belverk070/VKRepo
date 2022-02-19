//
//  FriendsViewController.swift
//  ProjectOneGB
//
//  Created by Василий Метлин on 17.10.2021.
//

import UIKit
import RealmSwift
import Kingfisher

class FriendsViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredFriends: Results<Friend>!
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var networkConstatns = NetworkConstants()
    var realmManger = RealmManager()
    var notificationToken: NotificationToken?
    var friendResults: Results<Friend>!
    let refreshControl = UIRefreshControl()
    private var imageService: PhotoService?
    let fromFriendsToGallery = "fromFriendsToGallery"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.registerWithNib(registerClass: CustomTableViewCell.self)
        imageService = PhotoService(container: tableView)
        matchRealm()
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRefreshControl()
        setupSearchController()
        tableView.reloadData()
    }
    
    //    MARK: Func
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search?"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupRefreshControl() {
        refreshControl.attributedTitle = NSAttributedString(string: "Обновление")
        refreshControl.tintColor = .black
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        makeFriendsRequest()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func matchRealm() {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: config)
        friendResults = realm.objects(Friend.self)
        notificationToken = friendResults?.observe { [weak self] changes in
            switch changes {
            case let .update(results, deletions, insertions, modifications):
                self?.tableView.beginUpdates()
                self?.tableView.insertRows(at: insertions.map {IndexPath(row: $0, section: 0)}, with: .fade)
                self?.tableView.deleteRows(at: deletions.map {IndexPath(row: $0, section: 0)}, with: .fade)
                self?.tableView.reloadRows(at: modifications.map {IndexPath(row: $0, section: 0)}, with: .fade)
                self?.tableView.endUpdates()
                print("updated")
            case .initial:
                self?.tableView.reloadData()
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
                //                print(friends)
                //                print(SessionData.instance.token)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.realmManger.saveFriends(data: Array(friends!))
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}


//MARK: DataSource and Delegate

extension FriendsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredFriends.count
        }
        return friendResults?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        
        var friend = Friend()
        
        if isFiltering {
            friend = filteredFriends[indexPath.row]
        } else {
            friend = friendResults[indexPath.row]
        }
        
        guard let urlImage = friendResults?[indexPath.row].photo100 else { return UITableViewCell() }
        let image = imageService?.photo(atIndexPath: indexPath, byURL: urlImage)
        cell.configure(image, friend: friend, completion: { [weak self] myfriend in
            guard let self = self else {return}
            SessionData.instance.userId = self.friendResults?[indexPath.row].id
            //            print(SessionData.instance.userId)
            self.performSegue(withIdentifier: self.fromFriendsToGallery, sender: myfriend)
        })
        return cell
    }
}

//MARK: UISearchResultsUpdating

extension FriendsViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredFriends = friendResults.filter("firstName CONTAINS[c] %@ OR lastName CONTAINS[c] %@", searchText, searchText)
        tableView.reloadData()
    }
}

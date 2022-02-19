//
//  GroupListViewController.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 07.12.2021.
//

import UIKit
import RealmSwift

class GroupListViewController: UIViewController {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredGroups: Results<Group>!
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    var networkConstants = NetworkConstants()
    var realmManger = RealmManager()
    var notificationToken: NotificationToken?
    var groupResults: Results<Group>!
    let refreshControl = UIRefreshControl()
    private var imageService: PhotoService?
    let fromAllGroupsToMyGroupsSegue = "fromAllGroupsToMyGroups"
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        imageService = PhotoService(container: tableView)
        tableView.registerWithNib(registerClass: CustomTableViewCell.self)
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
        makeGroupsRequest()
        realmManger.updateGroups()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func matchRealm() {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: config)
        groupResults = realm.objects(Group.self)
        notificationToken = groupResults?.observe { [weak self] changes in
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
    
    func makeGroupsRequest() {
        var urlComponents = URLComponents()
        urlComponents.scheme = networkConstants.scheme
        urlComponents.host = networkConstants.host
        urlComponents.path = "/method/groups.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "fields", value: "id,name,screen_name, photo_100"),
            URLQueryItem(name: "v", value: networkConstants.versionAPI),
            URLQueryItem(name: "access_token", value: SessionData.instance.token)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            do {
                guard let data = data else { return }
                let fetchedResponse = try JSONDecoder().decode(VKGroupsResponse.self, from: data)
                let groups = fetchedResponse.response?.items
                //                print(groups)
                DispatchQueue.main.async {
                    self?.realmManger.saveGroups(data: Array(groups!))
                    self?.tableView.reloadData()
                }
            } catch {
                print(error)
            }
        }.resume()
    }
}


//MARK: DataSource and Delegate
extension GroupListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredGroups.count
        }
        return groupResults?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var group = Group()
        
        if isFiltering {
            group = filteredGroups[indexPath.row]
        } else {
            group = groupResults[indexPath.row]
        }
        
        let cell: CustomTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        guard let urlImage = groupResults?[indexPath.row].photo100 else { return UITableViewCell() }
        let image = imageService?.photo(atIndexPath: indexPath, byURL: urlImage)
        cell.configure(image, group: group)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

//MARK: UISearchResultsUpdating

extension GroupListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        
        filteredGroups = groupResults.filter("name CONTAINS[c] %@", searchText)
        tableView.reloadData()
    }
}

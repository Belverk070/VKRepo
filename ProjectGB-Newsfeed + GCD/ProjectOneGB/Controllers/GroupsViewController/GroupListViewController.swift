//
//  GroupListViewController.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 07.12.2021.
//

import Foundation
import UIKit
import RealmSwift

class GroupListViewController: UIViewController {
    
    var networkConstants = NetworkConstants()
    var realmManger = RealmManager()
    var notificationToken: NotificationToken?
    var dataSource: Results<Group>?
    let refreshControl = UIRefreshControl()
    let reuseIdentifierCustom = "reuseIdentifierCustom"
    let fromAllGroupsToMyGroupsSegue = "fromAllGroupsToMyGroups"
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupsTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifierCustom)
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        groupsTableView.addSubview(refreshControl)
        //        dataSource = realmManger.getGroups()
        matchRealm()
        groupsTableView.reloadData()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        makeGroupsRequest()
        groupsTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    func matchRealm() {
        let config = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        let realm = try! Realm(configuration: config)
        dataSource = realm.objects(Group.self)
        notificationToken = dataSource?.observe { [weak self] changes in
            switch changes {
            case let .update(results, deletions, insertions, modifications):
                self?.groupsTableView.beginUpdates()
                self?.groupsTableView.insertRows(at: insertions.map {IndexPath(row: $0, section: 0)}, with: .fade)
                self?.groupsTableView.deleteRows(at: deletions.map {IndexPath(row: $0, section: 0)}, with: .fade)
                self?.groupsTableView.reloadRows(at: modifications.map {IndexPath(row: $0, section: 0)}, with: .fade)
                self?.groupsTableView.endUpdates()
                print("updated")
            case .initial:
                self?.groupsTableView.reloadData()
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
                print(groups)
                
                DispatchQueue.main.async {
                    self?.realmManger.saveGroups(data: Array(groups!))
                    self?.groupsTableView.reloadData()
                }
                
            } catch {
                print(error)
            }
        }.resume()
    }
}

extension GroupListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource?.count ?? 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifierCustom, for: indexPath) as? CustomTableViewCell else {return UITableViewCell()}
        cell.configure(group: dataSource![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}

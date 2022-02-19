//
//  NewsfeedViewController.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 12.01.2022.
//

import Foundation
import UIKit

class NewsfeedViewController: UIViewController {
    
    let newsHeaderTableViewReuseIdentifierCustom = "headerTableViewReuseIdentifierCustom"
    let newsContentTableViewReuseIdentifierCustom = "newsContentTableViewReuseIdentifierCustom"
    let newsActivityTableViewReuseIdentifierCustom = "newsActivityTableViewReuseIdentifierCustom"
    let newsImageTableViewReuseIdentifierCustom = "newsImageTableViewReuseIdentifierCustom"
    var networkConstants = NetworkConstants()
    var news = [Response]()
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        
        newsTableView.register(UINib(nibName: "NewsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: newsHeaderTableViewReuseIdentifierCustom)
        newsTableView.register(UINib(nibName: "NewsImageTableViewCell", bundle: nil), forCellReuseIdentifier: newsImageTableViewReuseIdentifierCustom)
        newsTableView.register(UINib(nibName: "NewsContentTableViewCell", bundle: nil), forCellReuseIdentifier: newsContentTableViewReuseIdentifierCustom)
        newsTableView.register(UINib(nibName: "NewsActivityTableViewCell", bundle: nil), forCellReuseIdentifier: newsActivityTableViewReuseIdentifierCustom)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
        newsTableView.reloadData()
        
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        DispatchQueue.global().async {
            self.makeNewsRequest()
            print("HERE IS NEWS COUNT: \(self.news.count)")
        }
        refreshControl.endRefreshing()
    }
    
    
    func makeNewsRequest() {
        var urlComponents = URLComponents()
        urlComponents.scheme = networkConstants.scheme
        urlComponents.host = networkConstants.host
        urlComponents.path = "/method/newsfeed.get"
        urlComponents.queryItems = [
            URLQueryItem(name: "filters", value: "post"),
            URLQueryItem(name: "start_from", value: "next_from"),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "v", value: networkConstants.versionAPI),
            URLQueryItem(name: "access_token", value: SessionData.instance.token)
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            do {
                guard let data = data else { return }
                let fetchedResponse = try JSONDecoder().decode(NewsfeedResponse.self, from: data)
                let news = fetchedResponse
                print(news)
                
            } catch {
                print(error)
            }
        }.resume()
    }
    
}

extension NewsfeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = newsTableView.dequeueReusableCell(withIdentifier: newsHeaderTableViewReuseIdentifierCustom, for: indexPath) as! NewsHeaderTableViewCell
            return cell
        case 1:
            let cell = newsTableView.dequeueReusableCell(withIdentifier: newsContentTableViewReuseIdentifierCustom, for: indexPath) as! NewsContentTableViewCell
            return cell
        case 2: let cell = newsTableView.dequeueReusableCell(withIdentifier: newsImageTableViewReuseIdentifierCustom, for: indexPath) as! NewsImageTableViewCell
            return cell
        case 3:
            let cell = newsTableView.dequeueReusableCell(withIdentifier: newsActivityTableViewReuseIdentifierCustom, for: indexPath) as! NewsActivityTableViewCell
            return cell
            
        default: return UITableViewCell()
        }
    }
}

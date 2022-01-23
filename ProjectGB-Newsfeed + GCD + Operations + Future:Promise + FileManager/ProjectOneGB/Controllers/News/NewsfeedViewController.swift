//
//  NewsfeedViewController.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 12.01.2022.
//

import Foundation
import UIKit

class NewsfeedViewController: UIViewController {
    
    private var news: [NewsModel] = []
    private var imageService: PhotoService?
    
    var networkConstants = NetworkConstants()
    var service = NetworkService()
    let newsHeaderTableViewReuseIdentifierCustom = "headerTableViewReuseIdentifierCustom"
    let newsContentTableViewReuseIdentifierCustom = "newsContentTableViewReuseIdentifierCustom"
    let newsActivityTableViewReuseIdentifierCustom = "newsActivityTableViewReuseIdentifierCustom"
    let newsImageTableViewReuseIdentifierCustom = "newsImageTableViewReuseIdentifierCustom"
    let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        
        newsTableView.register(UINib(nibName: "NewsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: newsHeaderTableViewReuseIdentifierCustom)
        newsTableView.register(UINib(nibName: "NewsImageTableViewCell", bundle: nil), forCellReuseIdentifier: newsImageTableViewReuseIdentifierCustom)
        newsTableView.register(UINib(nibName: "NewsContentTableViewCell", bundle: nil), forCellReuseIdentifier: newsContentTableViewReuseIdentifierCustom)
        newsTableView.register(UINib(nibName: "NewsActivityTableViewCell", bundle: nil), forCellReuseIdentifier: newsActivityTableViewReuseIdentifierCustom)
        imageService = PhotoService(container: newsTableView)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        newsTableView.addSubview(refreshControl)
        newsRequest()
        newsTableView.reloadData()
        
    }
    
    func newsRequest() {
        service.getUrl()
            .get({ url in
                print(url)
            })
            .then(on: DispatchQueue.global(), service.getData(_:))
            .then(service.getParsedData(_:))
            .then(service.getNews(_:))
            .done(on: DispatchQueue.main) { news in
                self.news = news
                print(news)
                self.newsTableView.reloadData()
            } .catch { error in
                print(error)
            }
        print("HERE IS NEWS COUNT: \(self.news.count)")
        refreshControl.endRefreshing()
        //        service.makeNewsRequest { news in
        //                    self.news = news
        //                    print(news)
        //                    self.newsTableView.reloadData()
        //                } onError: { error in
        //                    print(error)
        //                }
        
    }
    
    
    @objc private func refresh(sender: UIRefreshControl) {
        newsRequest()
        newsTableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension NewsfeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell = newsTableView.dequeueReusableCell(withIdentifier: newsHeaderTableViewReuseIdentifierCustom, for: indexPath) as! NewsHeaderTableViewCell
            let text = news[indexPath.section].creatorName
            let date = news[indexPath.section].getStringDate()
            let url = news[indexPath.section].avatarURL
            cell.configure(text, String(date), url)
            return cell
        case 1:
            let cell = newsTableView.dequeueReusableCell(withIdentifier: newsContentTableViewReuseIdentifierCustom, for: indexPath) as! NewsContentTableViewCell
            let text = news[indexPath.section].text
            cell.configure(text)
            return cell
        case 2: let cell = newsTableView.dequeueReusableCell(withIdentifier: newsImageTableViewReuseIdentifierCustom, for: indexPath) as! NewsImageTableViewCell
            guard let urlImage = news[indexPath.section].photosURL?.last else { return UITableViewCell() }
            let image = imageService?.photo(atIndexPath: indexPath, byURL: urlImage)
            cell.configure(image)
            return cell
        case 3:
            let cell = newsTableView.dequeueReusableCell(withIdentifier: newsActivityTableViewReuseIdentifierCustom, for: indexPath) as! NewsActivityTableViewCell
            let likes = news[indexPath.section].likes.count
            let comments = news[indexPath.section].comments.count
            let tweets = news[indexPath.section].reposts.count
            let view = news[indexPath.section].views.count
            cell.configure(likes, comments, tweets, view)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

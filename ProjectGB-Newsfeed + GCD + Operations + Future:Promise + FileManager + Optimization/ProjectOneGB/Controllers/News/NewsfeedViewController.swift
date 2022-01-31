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
    private var lastDateString: String?
    var nextForm = ""
    var isLoading = false
    var networkConstants = NetworkConstants()
    var service = NetworkService()
    let newsHeaderTableViewReuseIdentifierCustom = "headerTableViewReuseIdentifierCustom"
    let newsContentTableViewReuseIdentifierCustom = "newsContentTableViewReuseIdentifierCustom"
    let newsActivityTableViewReuseIdentifierCustom = "newsActivityTableViewReuseIdentifierCustom"
    let newsImageTableViewReuseIdentifierCustom = "newsImageTableViewReuseIdentifierCustom"
    
    @IBOutlet weak var newsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsTableView.register(UINib(nibName: "NewsHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: newsHeaderTableViewReuseIdentifierCustom)
        newsTableView.register(UINib(nibName: "NewsImageTableViewCell", bundle: nil), forCellReuseIdentifier: newsImageTableViewReuseIdentifierCustom)
        newsTableView.register(UINib(nibName: "NewsContentTableViewCell", bundle: nil), forCellReuseIdentifier: newsContentTableViewReuseIdentifierCustom)
        newsTableView.register(UINib(nibName: "NewsActivityTableViewCell", bundle: nil), forCellReuseIdentifier: newsActivityTableViewReuseIdentifierCustom)
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsTableView.prefetchDataSource = self
        self.newsTableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        imageService = PhotoService(container: newsTableView)
        newsRequest()
        setupRefreshControl()
        newsTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupRefreshControl()
        newsTableView.reloadData()
    }
    
    
    private func newsRequest() {
        service.getUrl()
            .get({ url in
                print(url)
            })
            .then(on: DispatchQueue.global(), service.getData(_:))
            .then(on: DispatchQueue.global(), service.getParsedData(_:))
            .get({response in
                self.nextForm = response.nextFrom ?? ""
            })
            .then(on: DispatchQueue.global(), service.getNews(_:))
            .done(on: DispatchQueue.main) { news in
                self.news = news
                print(news)
                self.newsTableView.reloadData()
            } .catch { error in
                print(error)
            }
    }
    
    private func setupRefreshControl() {
        newsTableView.refreshControl = UIRefreshControl()
        newsTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Обновление")
        newsTableView.refreshControl?.tintColor = .black
        newsTableView.refreshControl?.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
    }
    
    @objc func refreshNews() {
        guard let date = lastDateString else {
            newsTableView.refreshControl?.endRefreshing()
            return
        }
        service.getUrlWithTime(date)
            .get({ url in
                print(url)
            })
            .then(on: DispatchQueue.global(), service.getData(_:))
            .then(on: DispatchQueue.global(), service.getParsedData(_:))
            .then(on: DispatchQueue.global(), service.getNews(_:))
            .done(on: DispatchQueue.main) { [weak self] news in
                guard let self = self else { return }
                self.news.insert(contentsOf: news, at: 0)
                self.lastDateString = String(news.first?.date ?? 0)
            }.ensure { [weak self] in
                self?.newsTableView.refreshControl?.endRefreshing()
            }.catch { error in
                print(error)
            }
    }
}

extension NewsfeedViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        news.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return UITableView.automaticDimension
        case 1:
            if news[indexPath.section].text.isEmpty {
                return 0
            }
            return UITableView.automaticDimension
        case 2:
            guard let url = news[indexPath.section].photosURL,
                  !url.isEmpty else {
                      return 0
                  }
            let width = view.frame.width
            let post = news[indexPath.section]
            let cellHeight = width * post.aspectRatio
            return cellHeight
        case 3:
            return UITableView.automaticDimension
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let indexPathSection = news[indexPath.section]
        switch indexPath.row {
        case 0:
            let cell = newsTableView.dequeueReusableCell(withIdentifier: newsHeaderTableViewReuseIdentifierCustom, for: indexPath) as! NewsHeaderTableViewCell
            cell.configure(indexPathSection)
            return cell
        case 1:
            let cell = newsTableView.dequeueReusableCell(withIdentifier: newsContentTableViewReuseIdentifierCustom, for: indexPath) as! NewsContentTableViewCell
            cell.configure(indexPathSection)
            return cell
        case 2: let cell = newsTableView.dequeueReusableCell(withIdentifier: newsImageTableViewReuseIdentifierCustom, for: indexPath) as! NewsImageTableViewCell
            cell.configure(indexPathSection)
            return cell
        case 3:
            let cell = newsTableView.dequeueReusableCell(withIdentifier: newsActivityTableViewReuseIdentifierCustom, for: indexPath) as! NewsActivityTableViewCell
            cell.configure(indexPathSection)
            return cell
        default:
            return UITableViewCell()
        }
    }
}

extension NewsfeedViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        guard let maxSection = indexPaths.map({$0.section }).max() else { return }
        if maxSection > news.count - 3,
           !isLoading {
            isLoading = true
            service.getUrl(self.nextForm)
                .get({ url in
                    print(url)
                })
                .then(on: DispatchQueue.global(), service.getData(_:))
                .then(on: DispatchQueue.global(), service.getParsedData(_:))
                .get({ response in
                    self.nextForm = response.nextFrom ?? ""
                })
                .then(on: DispatchQueue.global(), service.getNews(_:))
                .done(on: DispatchQueue.main) { news in
                    self.news = news
                    self.newsTableView.reloadData()
                    let indexSet = IndexSet(integersIn: self.news.count..<self.news.count + news.count)
                    self.news.append(contentsOf: news)
                    self.newsTableView.insertSections(indexSet, with: .automatic)
                }.ensure {
                    self.isLoading = false
                }.catch { error in
                    print(error)
                }
        }
    }
}

//
//  NewsActivityTableViewCell.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 16.01.2022.
//

import UIKit

class NewsActivityTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var newsLikeCount: UILabel!
    @IBOutlet weak var newsCommentsCount: UILabel!
    @IBOutlet weak var newsTweetsCount: UILabel!
    @IBOutlet weak var newsViewsCount: UILabel!
    
    var news: [NewsfeedResponse] = []
    
    override func prepareForReuse() {
        newsLikeCount.text = nil
        newsCommentsCount.text = nil
        newsTweetsCount.text = nil
        newsViewsCount.text = nil
    }
    
    //    func configure(likes: Likes, comments: Comments, tweets: Reposts, view: Views) {
    //        newsLikeCount.text = "\(likes.count)"
    //        newsCommentsCount.text = "\(comments.count)"
    //        newsTweetsCount.text = "\(tweets.count)"
    //        newsViewsCount.text = "\(view.count)"
    //    }
    
    func configure(_ likes: Int, _ commentsCount: Int, _ repostsCount: Int, _ viewsCount: Int) {
        newsLikeCount.text = "\(likes)"
        newsCommentsCount.text = "\(commentsCount)"
        newsTweetsCount.text = "\(repostsCount)"
        newsViewsCount.text = "\(viewsCount)"
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

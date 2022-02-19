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
    
    func configure(_ model: NewsModel?) {
        
        if let likes = model?.likes.count,
           let comments = model?.comments.count,
           let repost = model?.reposts.count,
           let views = model?.views.count {
            newsLikeCount.text = "\(likes)"
            newsCommentsCount.text = "\(comments)"
            newsTweetsCount.text = "\(repost)"
            newsViewsCount.text = "\(views)"
        }
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

//
//  NewsfeedCustomTableViewCell.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 12.01.2022.
//

import UIKit
import Kingfisher

class NewsfeedCustomTableViewCell: UITableViewCell {

    @IBOutlet weak var newsTableView: UITableView!
    @IBOutlet weak var GroupPhoto: UIImageView!
    @IBOutlet weak var GroupName: UILabel!
    @IBOutlet weak var Date: UILabel!
    @IBOutlet weak var NewsPostText: UILabel!
    @IBOutlet weak var NewsPostImage: UIImageView!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var tweetLabel: UILabel!
    @IBOutlet weak var eyeLabel: UILabel!
    
    var news = [NewsfeedResponse]()
    
    override func prepareForReuse() {
//        GroupPhoto.image = nil
//        GroupName.text = nil
//        Date.text = nil
//        NewsPostText.text = nil
//        NewsPostImage = nil
//        likeLabel.text = nil
//        commentsLabel.text = nil
//        tweetLabel.text = nil
//        eyeLabel.text = nil
//        news = []
    }
    
    
    
    
//    func configure(news: NewsfeedResponse) {
//
////        let url = URL(string: news.avatarURL!)
////        GroupPhoto.kf.setImage(with: url)
//        GroupName.text = "test group name"
//        Date.text = "test date"
//        NewsPostText.text = "test news.text"
////        NewsPostImage.image = news.photosURL
//        likeLabel.text = "12"
//        commentsLabel.text = "233"
//        tweetLabel.text = "143"
//        eyeLabel.text = "431"
//
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

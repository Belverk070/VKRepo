//
//  NewsHeaderTableViewCell.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 16.01.2022.
//

import UIKit
import Kingfisher

class NewsHeaderTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsAuthorImage: UIImageView!
    @IBOutlet weak var newsAuthorName: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    
    var news: [NewsfeedResponse] = []
    
    override func prepareForReuse() {
        newsAuthorName.text = nil
        newsAuthorImage.image = nil
        newsDate.text = nil
    }
    
    func configure(news: Groups) {
        let url = URL(string: news.photo100!)
        newsAuthorImage.kf.setImage(with: url)
        newsAuthorName.text = news.name
        newsDate.text = news.name
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

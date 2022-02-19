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
    
    override func prepareForReuse() {
        newsAuthorName.text = nil
        newsAuthorImage.image = nil
        newsDate.text = nil
    }
    
    func configure(_ model: NewsModel?) {
        
        guard let model = model else { return }
        newsAuthorName.text = model.creatorName
        newsDate.text = model.getStringDate()
        if let url = model.avatarURL {
            newsAuthorImage.kf.setImage(with: URL(string: url))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsAuthorImage.layer.cornerRadius = cellHeight / 2
        newsAuthorImage.layer.borderWidth = 2
        newsAuthorImage.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

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
    
    func configure(_ author: String?,_ date: String?,_ url: String?) {
        newsAuthorName.text = author
        newsDate.text = date
        let url = URL(string: url!)
        newsAuthorImage.kf.setImage(with: url)
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

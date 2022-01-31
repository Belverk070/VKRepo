//
//  NewsImageTableViewCell.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 17.01.2022.
//

import UIKit
import Kingfisher

class NewsImageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var NewsContentImage: UIImageView!
    
    override func prepareForReuse() {
        NewsContentImage.image = nil
    }
    
    func configure(_ model: NewsModel?) {
        
        if let url = model?.photosURL?.last {
            NewsContentImage.kf.setImage(with: URL(string: url))
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

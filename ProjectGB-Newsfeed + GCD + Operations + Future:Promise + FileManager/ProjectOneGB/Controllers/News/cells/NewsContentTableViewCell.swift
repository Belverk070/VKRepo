//
//  NewsContentTableViewCell.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 16.01.2022.
//

import UIKit
import Kingfisher

class NewsContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsContentText: UILabel!
    @IBOutlet weak var newsContentImage: UIImageView!
    
    override func prepareForReuse() {
        newsContentText.text = nil
    }
    
    func configure(_ text: String?) {
        newsContentText.text = text
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

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
    //    @IBOutlet weak var showButton: UIButton!
    //    @IBAction func showButton(_ sender: UIButton) {
    //
    //    }
    
    override func prepareForReuse() {
        newsContentText.text = nil
    }
    
    func configure(_ model: NewsModel?) {
        newsContentText.text = model?.text
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        newsContentText.numberOfLines = 4
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}

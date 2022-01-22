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
        //        NewsContentImage.image = nil
    }
    
    //    в NewsHeader аналогичный метод сработал, чтобы подставить фото, в чем тут проблема не пойму, тк ругаться начинает на попытку извлечения опционального значения
    //    ловим Thread 1: Fatal error: Unexpectedly found nil while implicitly unwrapping an Optional value
    
    //    func configure(_ url: String?) {
    //        let url = URL(string: url!)
    //        NewsContentImage.kf.setImage(with: url)
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

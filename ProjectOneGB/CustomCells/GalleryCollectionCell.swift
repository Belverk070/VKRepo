//
//  GalleryCollectionCell.swift
//  ProjectOneGB
//
//  Created by Василий Метлин on 20.10.2021.
//

import UIKit

class GalleryCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.photoImageView.image = nil
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func configure(image: UIImage) {
        photoImageView.image = image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}


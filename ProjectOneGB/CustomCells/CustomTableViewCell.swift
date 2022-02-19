//
//  CustomTableViewCell.swift
//  ProjectOneGB
//
//  Created by Василий Метлин on 17.10.2021.
//

import UIKit
import Kingfisher

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var likeView: likeCounter!
    
    var completion: ((Friend) -> Void)?
    var friend: Friend?
    
    override func prepareForReuse() {
        avatarImageView.image = nil
        titleLable.text = nil
        completion = nil
        friend = nil
    }
    
    func configure(_ image: UIImage?, friend: Friend, completion: ((Friend) -> Void)?) {
        self.completion = completion
        self.friend = friend
        let url = URL(string: friend.photo100)
        avatarImageView.kf.setImage(with: url)
        titleLable.text = friend.firstName + " " + friend.lastName
    }
    
    func configure(_ image: UIImage?, group: Group) {
        let url = URL(string: group.photo100)
        avatarImageView.kf.setImage(with: url)
        titleLable.text = group.name
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImageView.layer.cornerRadius = cellHeight / 2
        avatarImageView.layer.borderWidth = 3
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        backView.layer.cornerRadius = cellHeight / 2
        backView.layer.shadowColor = UIColor.black.cgColor
        backView.layer.shadowOffset = CGSize(width: 1, height: 1)
        backView.layer.shadowRadius = 1
        backView.layer.shadowOpacity = 0.5
    }
    
    @IBAction func pressAvatarButton(_ sender: Any) {
        
        let scale = CGFloat(10)
//        let frame = avatarImageView.frame
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self = self else {return}
            
            self.avatarImageView.frame = CGRect(x: self.avatarImageView.frame.origin.x + scale / 4, y: self.avatarImageView.frame.origin.y + scale / 4, width: self.avatarImageView.frame.width - scale, height: self.avatarImageView.frame.height - scale)
        }
    completion: { isSuccessfully in
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5,
                       options: []) { [weak self] in
            guard let self = self else {return}
            self.avatarImageView.frame = CGRect(x: self.avatarImageView.frame.origin.x - scale / 10, y: self.avatarImageView.frame.origin.y - scale / 10, width: self.avatarImageView.frame.width + scale, height: self.avatarImageView.frame.height + scale)
        }
    completion: { [weak self] isAllSuccessfully in
        guard let self = self else {return}
        if isAllSuccessfully,
           let friend = self.friend {
            self.completion?(friend)
        }
    }
    }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}


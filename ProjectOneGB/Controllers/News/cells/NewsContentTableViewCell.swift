//
//  NewsContentTableViewCell.swift
//  GeekBrainsProject
//
//  Created by Василий Метлин on 16.01.2022.
//

import UIKit
import Kingfisher

protocol ShowMoreDelegate: AnyObject {
    func updateTextHeight(indexPath: IndexPath)
}

class NewsContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var newsContentText: UILabel!
    
    //    создаем и настраиваем кнопку
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitle("Show more", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var shortTextState = false
    private let insets: CGFloat = 10
    //    Делегат для обновления высоты ячейки текста
    weak var delegate: ShowMoreDelegate?
    //    IndexPath ячейки таблицы
    var indexPath: IndexPath = IndexPath()
    
    override func prepareForReuse() {
        newsContentText.text = nil
    }
    
    func configure(_ model: NewsModel?) {
        newsContentText.text = model?.text
        setTextNews(text: model?.text ?? "")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


extension NewsContentTableViewCell {
    
    func getLabelTextNewsSize(text: String, font: UIFont) -> CGSize {
        let maxWidth = bounds.width - insets * 2
        let textBlock = CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
        let rect = text.boundingRect(with: textBlock, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        let width = Double(rect.size.width)
        let height = Double(rect.size.height)
        let size = CGSize(width: ceil(width), height: ceil(height))
        return size
    }
    
    func setTextNews(text: String) {
        newsContentText.text = text
        let sizeText = getLabelTextNewsSize(text: text, font: .systemFont(ofSize: 14))
        
        if sizeText.height < 200 {
            showFullText()
            addActionButton()
        } else {
            showShortText()
        }
    }
    
    
    // MARK: ShowButton
    
    func addActionButton() {
        contentView.addSubview(actionButton)
        actionButton.addTarget(self, action: #selector(toggleText), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            actionButton.topAnchor.constraint(equalTo: newsContentText.bottomAnchor, constant: 10),
            actionButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor,constant: 10),
            actionButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            actionButton.heightAnchor.constraint(equalToConstant: 14)
        ])
        
    }
    
    @objc func toggleText() {
        if shortTextState {
            showFullText()
            actionButton.setTitle("Show less", for: .normal)
        } else {
            showShortText()
            actionButton.setTitle("Show more", for: .normal)
        }
        delegate?.updateTextHeight(indexPath: indexPath)
    }
    
    func showFullText() {
        newsContentText.numberOfLines = 0
        shortTextState = false
    }
    
    func showShortText() {
        newsContentText.numberOfLines = 4
        shortTextState = true
    }
}

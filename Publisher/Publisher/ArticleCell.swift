//
//  ArticleCell.swift
//  Publisher
//
//  Created by shuo on 2020/11/20.
//

import UIKit

class ArticleCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    
    func setupCellWith(article: Article) {
        
        titleLabel.text = article.title
        authorLabel.text = "Author: \(article.author.name)"
        timeLabel.text = "\(article.createdTime.dateValue())"
        categoryLabel.text = article.category
        contentLabel.text = article.content
        
        categoryLabel.layer.cornerRadius = 10
        categoryLabel.clipsToBounds = true
    }
}

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
    
    func setupCell() {
        
        titleLabel.text = "Title"
        authorLabel.text = "Alex"
        timeLabel.text = "2020/11/20"
        categoryLabel.text = "Gossiping"
        contentLabel.text = "ABCDEFG"
    }
}

//
//  DataModel.swift
//  Publisher
//
//  Created by shuo on 2020/11/20.
//

import Foundation

struct Article {
    
    var author: Author
    var title: String
    var content: String
    var createdTime: NSDate
    var id: String
    var category: String
}

struct Author {
    
    var email: String
    var id: String
    var name: String
}

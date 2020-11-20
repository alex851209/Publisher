//
//  DataModel.swift
//  Publisher
//
//  Created by shuo on 2020/11/20.
//

import Foundation
import Firebase
import CodableFirebase

struct Article: Codable {
    
    var author: Author
    var title: String
    var content: String
    var createdTime: Timestamp
    var id: String
    var category: String
}

struct Author: Codable {
    
    var email: String
    var id: String
    var name: String
}

extension Timestamp: TimestampType {}

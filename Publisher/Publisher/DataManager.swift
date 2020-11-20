//
//  DataProvider.swift
//  Publisher
//
//  Created by shuo on 2020/11/20.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class DataManager {
    
    func addData(withArticle article: Article) {
        
        let articles = Firestore.firestore().collection("articles")
        let document = articles.document()
        
        let data: [String: Any] = [
            "author": [
                "email": article.author.email,
                "id": article.author.id,
                "name": article.author.name
            ],
            "title": article.title,
            "content": article.content,
            "createdTime": article.createdTime,
            "id": document.documentID,
            "category": article.category
        ]
        
        document.setData(data) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(document.documentID)")
            }
        }
    }
}

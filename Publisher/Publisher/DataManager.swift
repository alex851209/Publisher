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
import CodableFirebase

class DataManager {
    
    let database = Firestore.firestore().collection("articles")
    
    func addDataWith(article: Article) {
        
        let document = database.document()
        
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
    
    func listenArticle(completion: @escaping ([Article]) -> (Void)) {
        
        var articles = [Article]()
        
        database.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot else {
                print("Error fetching article: \(error!)")
                return
            }
            _ = documents.documentChanges.map {
                guard let article = try? FirestoreDecoder().decode(Article.self, from: $0.document.data())
                else {
                    print("Error decoding!")
                    return
                }
                print("******\nNew Article: \(article)\n******")
                articles.insert(article, at: 0)
                completion(articles)
            }
        }
    }
}

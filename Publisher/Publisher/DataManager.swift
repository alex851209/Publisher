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
    
    let database = Firestore.firestore().collection("articles")
    
    func addData(withArticle article: Article) {
        
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
    
    func listenArticle(completion: @escaping ([[String: Any]]) -> (Void)) {
        
        var articles = [[String: Any]]()
        
        database.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot else {
                print("Error fetching article: \(error!)")
                return
            }
            _ = documents.documentChanges.map { [weak self] in
                let article = $0.document.data()
                self?.listenAuthor(with: $0.document.documentID, completion: { author in
                    print("******\nNew Article: \(article)\nby Author: \(author)\n******")
                    articles.append(article)
                    completion(articles)
                })
            }
        }
    }
    
    func listenAuthor(with documentID: String, completion: @escaping ([String: Any]) -> (Void)) {

        let document = database.document(documentID).collection("author")
        
        document.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot else {
                print("Error fetching author: \(error!)")
                return
            }
            _ = documents.documentChanges.map {
                let author = $0.document.data()
                completion(author)
            }
        }
    }
}

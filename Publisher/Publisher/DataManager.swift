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
    
    func listenArticle(completion: @escaping ([Article], [Author]) -> (Void)) {
        
        var articles = [Article]()
        var authors = [Author]()
        
        database.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot else {
                print("Error fetching article: \(error!)")
                return
            }
            _ = documents.documentChanges.map { [weak self] in
                guard let article = try? FirestoreDecoder().decode(Article.self, from: $0.document.data())
                else {
                    print("Error decoding!")
                    return
                }
                self?.listenAuthor(with: $0.document.documentID, completion: { author in
                    print("******\nNew Article: \(article)\nby Author: \(author)\n******")
                    articles.append(article)
                    authors.append(author)
                    completion(articles, authors)
                })
            }
        }
    }
    
    func listenAuthor(with documentID: String, completion: @escaping (Author) -> (Void)) {

        let document = database.document(documentID).collection("author")
        
        document.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot else {
                print("Error fetching author: \(error!)")
                return
            }
            _ = documents.documentChanges.map {
                guard let author = try? FirestoreDecoder().decode(Author.self, from: $0.document.data())
                else {
                    print("Error decoding!")
                    return
                }
                completion(author)
            }
        }
    }
}

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
            "createdTime": NSDate().timeIntervalSince1970,
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
    
    func listenArticle(completion: @escaping ([Article], [String]) -> (Void)) {
        
        var articles = [Article]()
        var times = [String]()
        
        database.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot else {
                print("Error fetching article: \(error!)")
                return
            }
            _ = documents.documentChanges.map {
                guard let article = try? $0.document.data(as: Article.self, decoder: .none),
                      let timestamp = $0.document.data()["createdTime"] as? Double
                else { return }
                print("******\nNew Article: \(article)\n******")
                let timeInterVal = TimeInterval(timestamp)
                let date = Date(timeIntervalSince1970: timeInterVal)
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy/MM/dd HH:mm"
                let today = dateFormatter.string(from: date)
                print("Time Stamp's Current Time:\(today)")
                
                times.append(today)
                articles.insert(article, at: 0)
                completion(articles, times)
            }
        }
    }
}

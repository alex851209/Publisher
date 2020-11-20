//
//  ViewController.swift
//  Publisher
//
//  Created by shuo on 2020/11/20.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var articleTableView: UITableView!
    
    let dataManager = DataManager()
    var articles = [Article]()
    var authors = [Author]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        fetchData()
    }
    
    func setupTableView() {
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
    }
    
    func fetchData() {
        
        dataManager.listenArticle(completion: { [weak self] articles, authors in
//            print("###\n\(authors.count)\n###")
            self?.articles = articles
            self?.authors = authors
            self?.articleTableView.reloadData()
        })
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        guard let articleCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleCell.self), for: indexPath) as? ArticleCell else { return cell }
        
        articleCell.setupCellWith(article: articles[indexPath.row], author: authors[indexPath.row])
        return articleCell
    }
}


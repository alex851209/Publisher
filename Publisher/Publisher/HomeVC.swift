//
//  ViewController.swift
//  Publisher
//
//  Created by shuo on 2020/11/20.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var publishView: UIView!
    
    let dataManager = DataManager()
    var maskView = UIView()
    var articles = [Article]()
    var authors = [Author]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPublishPage()
        setupButton()
        setupTableView()
        fetchData()
    }
    
    func setupTableView() {
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
    }
    
    func fetchData() {
        
        dataManager.listenArticle(completion: { [weak self] articles, authors in
            self?.articles = articles
            self?.authors = authors
            self?.articleTableView.reloadData()
        })
    }
    
    func setupButton() {
        
        addButton.layer.cornerRadius = 30
        addButton.clipsToBounds = true
        addButton.addTarget(self, action: #selector(addArticle), for: .touchUpInside)
    }
    
    func setupPublishPage() {
        
        maskView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        maskView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        maskView.isHidden = true
        view.insertSubview(maskView, belowSubview: publishView)
        
        publishView.frame = CGRect(x: 16, y: view.frame.maxY, width: view.frame.width - 32, height: 500)
        publishView.layer.cornerRadius = 10
        publishView.clipsToBounds = true
        publishView.isHidden = true
    }
    
    @objc func addArticle() {
        
        maskView.isHidden = false
        publishView.isHidden = false
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, animations: {
            self.publishView.frame = CGRect(x: 16,
                                            y: self.articleTableView.frame.minY + 130,
                                            width: self.view.frame.width - 32,
                                            height: 500)
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


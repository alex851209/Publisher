//
//  ViewController.swift
//  Publisher
//
//  Created by shuo on 2020/11/20.
//

import UIKit
import FirebaseFirestore

class HomeVC: UIViewController {

    @IBOutlet weak var articleTableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var publishView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var categoryTextField: UITextField!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBAction func closeButtonDidTap(_ sender: Any) {
        
        togglePublishPage()
        clearText()
    }
    @IBAction func publishButtonDidTap(_ sender: Any) {
        
        publish()
    }
    
    let dataManager = DataManager()
    let author = Author(email: "alex@gmail.com", id: "9527", name: "Alex")
    var maskView = UIView()
    var articles = [Article]()
    
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
        
        dataManager.listenArticle(completion: { [weak self] articles in
            self?.articles = articles
            self?.articleTableView.reloadData()
        })
    }
    
    func setupButton() {
        
        addButton.layer.cornerRadius = 30
        addButton.clipsToBounds = true
        addButton.addTarget(self, action: #selector(togglePublishPage), for: .touchUpInside)
    }
    
    func setupPublishPage() {
        
        maskView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        maskView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.2)
        maskView.isHidden = true
        view.insertSubview(maskView, belowSubview: publishView)
        
        publishView.layer.cornerRadius = 10
        publishView.clipsToBounds = true
        publishView.isHidden = true
        
        contentTextView.layer.borderWidth = 1
        contentTextView.layer.borderColor = CGColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.1)
        contentTextView.layer.cornerRadius = 5
    }
    
    @objc func togglePublishPage() {
        
        maskView.isHidden = !maskView.isHidden
        publishView.isHidden = !publishView.isHidden
    }
    
    func publish() {
        
        guard let title = titleTextField.text,
              let content = contentTextView.text,
              let category = categoryTextField.text
        else { return }
        
        let timeInterval = NSDate().timeIntervalSince1970
        let date = Date(timeIntervalSince1970: timeInterval)
        
        let newArticle = Article(author: author,
                                 title: title,
                                 content: content,
                                 createdTime: Timestamp(date: date),
                                 id: "",
                                 category: category)
        
        let hasAuthor = newArticle.author.email != "" && newArticle.author.id != "" && newArticle.author.name != ""
        let hasText = titleTextField.text != "" && categoryTextField.text != "" && contentTextView.text != ""
        let canPublish = hasAuthor && hasText
        
        if hasText == false {
            showEmptyAlert()
        } else if canPublish {
            dataManager.addDataWith(article: newArticle)
            showAlert(with: canPublish)
            togglePublishPage()
        } else {
            showAlert(with: canPublish)
        }
    }
    
    func showAlert(with canPublish: Bool) {
        
        var alert = UIAlertController()
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        
        if canPublish {
            alert = UIAlertController(title: "Publish Success", message: nil, preferredStyle: .alert)
            clearText()
        } else {
            alert = UIAlertController(title: "Publish Failure", message: "Check your Author info", preferredStyle: .alert)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showEmptyAlert() {
        
        let alert = UIAlertController(title: "Publish Failure", message: "Check your input", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func clearText() {
        
        titleTextField.text?.removeAll()
        categoryTextField.text?.removeAll()
        contentTextView.text = "Input Content"
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        guard let articleCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleCell.self), for: indexPath) as? ArticleCell else { return cell }
        
        articleCell.setupCellWith(article: articles[indexPath.row])
        return articleCell
    }
}


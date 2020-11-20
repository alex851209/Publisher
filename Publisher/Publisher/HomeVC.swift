//
//  ViewController.swift
//  Publisher
//
//  Created by shuo on 2020/11/20.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var articleTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
    }
    
    func setupTableView() {
        
        articleTableView.delegate = self
        articleTableView.dataSource = self
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        guard let articleCell = tableView.dequeueReusableCell(withIdentifier: String(describing: ArticleCell.self), for: indexPath) as? ArticleCell else { return cell }
        
        articleCell.setupCell()
        return articleCell
    }
}


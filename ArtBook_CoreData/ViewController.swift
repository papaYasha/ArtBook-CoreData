//
//  ViewController.swift
//  ArtBook_CoreData
//
//  Created by Macbook on 18.03.22.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
    }
    
    private func config() {
        configTabBar()
    }
    
    private func configTabBar() {
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonClicked))
    }
    
    @objc private func addButtonClicked() {
        performSegue(withIdentifier: Constants.segueID, sender: nil)
    }
}


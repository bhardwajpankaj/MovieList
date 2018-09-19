//
//  BaseViewController.swift
//  MovieList
//
//  Created by user on 10/09/18.
//  Copyright © 2018 pankajBhardwaj. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Current ViewConroller Loaded :",self)
        // Do any additional setup after loading the view.
        initializeTable()
    }
    
    func initializeTable()
    {
        self.tableView?.rowHeight = UITableViewAutomaticDimension;
        self.tableView?.estimatedRowHeight = CGFloat(Constants.cellDefaultHeight) // set to your "average" cell height is
    }
}

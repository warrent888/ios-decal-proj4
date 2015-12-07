//
//  QuestionViewController.swift
//  Drunkosophy
//
//  Created by Warren W Tian on 12/5/15.
//  Copyright © 2015 Warren Tian and Albert Phone. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class QuestionViewController: UIViewController {
    
    @IBOutlet var qTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.qTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}

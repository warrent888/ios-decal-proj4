//
//  CreateQuestionViewController.swift
//  Drunkosophy
//
//  Created by Warren W Tian on 12/5/15.
//  Copyright © 2015 Warren Tian and Albert Phone. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class CreateQuestionViewController: UIViewController {
    
    @IBOutlet var textField: UITextView!
    @IBOutlet var submit: UIButton!

    @IBAction func createQuestion(sender: AnyObject) {
        var question = PFObject(className: "Question")
        question["text"] = textField.text
        question["user"] = PFUser.currentUser()
        question["score"] = 0
        
        question.saveInBackground()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

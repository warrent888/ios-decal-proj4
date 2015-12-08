//
//  QuestionTableViewCell.swift
//  Drunkosophy
//
//  Created by Warren W Tian on 12/6/15.
//  Copyright © 2015 Warren Tian and Albert Phone. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class QuestionTableViewCell: UITableViewCell {
    
    var questionId = String()
    @IBOutlet var questionTextView: UITextView!
    @IBOutlet var usernameLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBAction func upvote(sender: AnyObject) {
        let query = PFQuery(className: "Question")
        query.getObjectInBackgroundWithId(questionId) {
            (question: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let question = question {
                question.incrementKey("score")
                let score = question.objectForKey("score") as! NSNumber
                self.scoreLabel.text = "\(score)"
                question.saveInBackground()
            }
        }
    }
}
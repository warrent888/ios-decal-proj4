//
//  ResponseTableViewCell.swift
//  Drunkosophy
//
//  Created by Warren W Tian on 12/7/15.
//  Copyright © 2015 Warren Tian and Albert Phone. All rights reserved.
//

import Foundation
import UIKit
import Parse
import Bolts

class ResponseTableViewCell: UITableViewCell {
    
    var responseId = String()
    @IBOutlet var responseTextView: UITextView!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var usernameLabel: UILabel!
    @IBAction func upVote(sender: AnyObject) {
        let query = PFQuery(className: "Response")
        query.getObjectInBackgroundWithId(responseId) {
            (response: PFObject?, error: NSError?) -> Void in
            if error != nil {
                print(error)
            } else if let response = response {
                response.incrementKey("score")
                let score = response.objectForKey("score") as! NSNumber
                self.scoreLabel.text = "\(score)"
                response.saveInBackground()
            }
        }
        
    }
    
}

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

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var responseTextView: UITextView!
    @IBOutlet var qTableView: UITableView!
    

    var questionText = String()
    var questionId = String()
    var feedData = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
        self.automaticallyAdjustsScrollViewInsets = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submit(sender: AnyObject) {
        var response = PFObject(className: "Response")
        
        response["text"] = responseTextView.text
        response["user"] = PFUser.currentUser()
        response["score"] = 0
        response["questionId"] = questionId
        response.saveInBackground()
        self.loadData()
        responseTextView.text = ""
    }
    
    override func viewWillAppear(animated: Bool) {
        self.questionLabel.text = questionText
    }

    func loadData() {
        self.feedData = [PFObject]()
        let findQuestionData = PFQuery(className:"Response")
        findQuestionData.whereKey("questionId", equalTo: questionId)
        findQuestionData.findObjectsInBackgroundWithBlock{ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        self.feedData.append(object)
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.qTableView.reloadData()
                }
            } else {
                print("Error")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection: Int) -> Int {
        return self.feedData.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.qTableView.dequeueReusableCellWithIdentifier("Cell") as! ResponseTableViewCell
        let row = indexPath.row
        let response = self.feedData[self.feedData.count - row - 1]
        cell.responseTextView.text = response.objectForKey("text") as! String
        let score = response.objectForKey("score") as! NSNumber
        cell.scoreLabel.text = "\(score)"
        cell.responseId = response.objectId!
        let findUser = PFUser.query()!
        findUser.whereKey("objectId", equalTo: response.objectForKey("user")!.objectId as! AnyObject)
        findUser.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?)-> Void in
            if error == nil {
                let user:PFUser = (objects! as NSArray).lastObject as! PFUser
                cell.usernameLabel.text = user.username
                
            }
        }
        return cell
    }
    
}

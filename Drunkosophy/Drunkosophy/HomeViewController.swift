//
//  HomeViewController.swift
//  Drunkosophy
//
//  Created by Warren W Tian on 12/3/15.
//  Copyright © 2015 Warren Tian and Albert Phone. All rights reserved.
//

import UIKit
import Parse
import Bolts

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var logout: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var feedData = [PFObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Show the current visitor's username
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName
        }
        self.loadData()
    }

    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
        self.loadData()
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(animated: Bool) {
        if (PFUser.currentUser() == nil) {
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") as! UIViewController
                self.presentViewController(viewController, animated: true, completion: nil)
            })
        }
    }

    @IBAction func logOutAction(sender: AnyObject){
        // Send a request to log out a user
        PFUser.logOut()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("Login") as! UIViewController
            self.presentViewController(viewController, animated: true, completion: nil)
        })
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "responseSegue" {
            if let destination = segue.destinationViewController as? QuestionViewController {
                if let index = tableView.indexPathForSelectedRow?.row {
                    let question = self.feedData[self.feedData.count - index - 1]
                    destination.questionText = question.objectForKey("text") as! String
                    destination.questionId = question.objectId!
                }
            }
        }
    }

    func loadData() {
        self.feedData = [PFObject]()
        let findQuestionData = PFQuery(className:"Question")
//        findQuestionData.findObjectsInBackgroundWithBlock(<#T##block: PFQueryArrayResultBlock?##PFQueryArrayResultBlock?##([PFObject]?, NSError?) -> Void#>)
        findQuestionData.findObjectsInBackgroundWithBlock{ (objects:[PFObject]?, error:NSError?) -> Void in
            if error == nil {
                if let objects = objects {
                    for object in objects {
                        self.feedData.append(object)
                    }
                }
                dispatch_async(dispatch_get_main_queue()) {
                    self.tableView.reloadData()
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
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell") as! QuestionTableViewCell
        let row = indexPath.row
        let question = self.feedData[self.feedData.count - row - 1]
        cell.questionTextView.text = question.objectForKey("text") as! String
        let score = question.objectForKey("score") as! NSNumber
        cell.scoreLabel.text = "\(score)"
        cell.questionId = question.objectId!
        var findUser = PFUser.query()!
        findUser.whereKey("objectId", equalTo: question.objectForKey("user")!.objectId as! AnyObject)

        findUser.findObjectsInBackgroundWithBlock{ (objects: [PFObject]?, error: NSError?)-> Void in
            if error == nil {
                let user:PFUser = (objects! as NSArray).lastObject as! PFUser
                cell.usernameLabel.text = user.username

            }
        }
        return cell
    }
    
}
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

class HomeViewController: UIViewController {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var logout: UIButton!
    var feedData:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Show the current visitor's username
        if let pUserName = PFUser.currentUser()?["username"] as? String {
            self.userNameLabel.text = "@" + pUserName
        }
        
    }

    @IBAction func unwindToHomeScreen(segue:UIStoryboardSegue) {
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
    
    func loadData() {
        feedData.removeAllObjects()
        let findQuestionData:PFQuery = PFQuery(className:"Question")
        findQuestionData.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object:PFObject! in objects! {
                    self.feedData.addObject(object)
                }
                let array:NSArray = self.feedData.reverseObjectEnumerator().allObjects
                self.feedData = array as! NSMutableArray
                self.tableView.reloadData()
            } else {
                print("Error")
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView?) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView?, numberOfRowsInSection: Int) -> Int {
        return feedData.count
    }
    
    func tableView(tableView: UITableView?, cellForRowAtIndexPath indexPath: NSIndexPath?) -> UITableViewCell? {
        let cell:QuestionTableViewCell = tableView!.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath!) as! QuestionTableViewCell
        let question:PFObject = self.feedData.objectAtIndex(indexPath!.row) as! PFObject
        cell.questionTextView.text = question.objectForKey("text") as! String
        return cell
    }
    
}
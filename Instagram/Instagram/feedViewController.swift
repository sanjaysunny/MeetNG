//
//  feedViewController.swift
//  Instagram
//
//  Created by Rob Percival on 08/09/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit

class feedViewController: UITableViewController {
    
    var titles = [String]()
    var usernames = [String]()
    var images = [UIImage]()
    var imageFiles = [PFFile]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var getFollowedUsersQuery = PFQuery(className: "followers")
        getFollowedUsersQuery.whereKey("follower", equalTo: PFUser.currentUser().username)
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                
                var followedUser = ""
                
                for object in objects {
                    
                    // Update - replaced as with as!
                    
                    followedUser = object["following"] as String
                    
                    
                    var query = PFQuery(className:"Post")
                    query.whereKey("username", equalTo:followedUser)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            // The find succeeded.
                            println("Successfully retrieved \(objects.count) scores.")
                            // Do something with the found objects
                            for object in objects {
                                
                                // Update - replaced as with as!
                                
                                self.titles.append(object["Title"] as String)
                                
                                // Update - replaced as with as!
                                
                                self.usernames.append(object["username"] as String)
                                
                                // Update - replaced as with as!
                                
                                self.imageFiles.append(object["imageFile"] as PFFile)
                                
                                self.tableView.reloadData()
                                
                            }
                        } else {
                            // Log details of the failure
                            println(error)
                        }
                    }
                    
                    
                }
                
            }
            
        }
        
        
        
            }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return titles.count
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 227
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Update - replaced as with as!
        
        var myCell:cell = self.tableView.dequeueReusableCellWithIdentifier("myCell") as cell
        
        myCell.title.text = titles[indexPath.row]
        myCell.username.text = usernames[indexPath.row]
        
        imageFiles[indexPath.row].getDataInBackgroundWithBlock{
            (imageData: NSData!, error: NSError!) -> Void in
            
            if error == nil {
                
                let image = UIImage(data: imageData)
                
                myCell.postedImage.image = image
            }
            
            
            }
        
        
        return myCell
        
    }
    
       


}

//
//  postViewController.swift
//  Instagram
//
//  Created by Rob Percival on 08/09/2014.
//  Copyright (c) 2014 Appfish. All rights reserved.
//

import UIKit

class postViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
   
    var photoSelected:Bool = false
    
    @IBOutlet var imageToPost: UIImageView!
    
    @IBAction func logout(sender: AnyObject) {
        
        PFUser.logOut()
        
        self.performSegueWithIdentifier("logout", sender: self)
        
    }
    
    @IBAction func chooseImage(sender: AnyObject) {
        
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        image.allowsEditing = false
        
        self.presentViewController(image, animated: true, completion: nil)

        
    }
    
    
    @IBOutlet var shareText: UITextField!
    
    
    @IBAction func postImage(sender: AnyObject) {
        
        var error = ""
        
        if (photoSelected == false) {
            
            error = "Please select an image to post"
            
        } else if (shareText.text == "") {
            
            error = "Please enter a message"
            
        }
        
        if (error != "") {
            
            displayAlert("Cannot Post Image", error: error)
            
        } else {
            
            activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.sharedApplication().beginIgnoringInteractionEvents()
            
            var post = PFObject(className: "Post")
            post["Title"] = shareText.text
            post["username"] = PFUser.currentUser().username
            
            post.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                
                
                if success == false {
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    self.displayAlert("Could Not Post Image", error: "Please try again later")
                    
                } else {
                    
                    let imageData = UIImagePNGRepresentation(self.imageToPost.image)
                    
                    let imageFile = PFFile(name: "image.png", data: imageData)
                    
                    post["imageFile"] = imageFile
                    
                    post.saveInBackgroundWithBlock{(success: Bool!, error: NSError!) -> Void in
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if success == false {
                            
                            self.displayAlert("Could Not Post Image", error: "Please try again later")
                            
                        } else {
                            
                            self.displayAlert("Image Posted!", error: "Your image has been posted successfully")
                            
                            // Update - replaced 0 with false
                            
                            self.photoSelected = false
                            
                            self.imageToPost.image = UIImage(named: "315px-Blank_woman_placeholder.svg")
                            
                            self.shareText.text = ""
                            
                            println("posted successfully")
                            
                        }
                        
                    }
                    
                }
            
            
            }
            
            
            
        }
        
        
    }
    
    
    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("Image selected")
        self.dismissViewControllerAnimated(true, completion: nil)
        
        imageToPost.image = image
        
        photoSelected = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Update - replaced 0 with false
        
        photoSelected = false
        
        imageToPost.image = UIImage(named: "315px-Blank_woman_placeholder.svg")
        
        shareText.text = ""
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

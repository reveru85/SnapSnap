//
//  WelcomeViewController.swift
//  Gegder
//
//  Copyright (c) 2015 Genesys. All rights reserved.
//

import UIKit
import CoreLocation

class WelcomeViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet weak var LoadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var NotNowButton: UIButton!
    @IBOutlet weak var ConnectFBButton: UIButton!
    
    var userID = ""
    var fbId = ""
    var firstName = ""
    var lastName = ""
    var gender = ""
    var email = ""
    var timezone = 0
    let loginView : FBSDKLoginButton = FBSDKLoginButton()
    var firstload = true
    var loginFromWelcomeScreen = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        ConnectFBButton.layer.backgroundColor = UIColor.darkGrayColor().colorWithAlphaComponent(0.3).CGColor
        
//        self.view.addSubview(loginView)
        loginView.center = CGPoint(x: self.view.center.x, y: self.view.center.y + 100)
        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        loginView.delegate = self
        loginView.hidden = true
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var login = false
        login = (UIApplication.sharedApplication().delegate as! AppDelegate).isFBLogin!
        if login {
            NotNowButton.setTitle("Continue", forState: UIControlState.allZeros)
            ConnectFBButton.setTitle("Logout from Facebook", forState: UIControlState.allZeros)
        } else {
            NotNowButton.setTitle("Not now", forState: UIControlState.allZeros)
            ConnectFBButton.setTitle("Connect with Facebook", forState: UIControlState.allZeros)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        loginFromWelcomeScreen = true
        
        if firstload {
            firstload = false
            
            let deviceID = UIDevice.currentDevice().identifierForVendor.UUIDString
            let deviceHash = deviceID.md5()
            
            var urlString = "http://20backendapi15.gegder.com/index.php/user/load_user/" + deviceHash!
            
            // Get UserID from server based on deviceID's hash
            var url = NSURL(string: urlString)
            var request = NSURLRequest(URL: url!)
            let queue: NSOperationQueue = NSOperationQueue.mainQueue()
            NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                if data != nil {
                    var user = JSON(data: data!)
                    self.userID = user["id"].string!
                    (UIApplication.sharedApplication().delegate as! AppDelegate).userID = self.userID
                    self.userIDLoadComplete()
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "GoToHome") {
            (UIApplication.sharedApplication().delegate as! AppDelegate).mainTabViewController = segue.destinationViewController as? UITabBarController
        }
    }
    
    func userIDLoadComplete() {
        LoadingSpinner.hidden = true
        ConnectFBButton.hidden = false
        NotNowButton.hidden = false
        
        if (FBSDKAccessToken.currentAccessToken() != nil)
        {
            // User is already logged in, do work such as go to next view controller.
            (UIApplication.sharedApplication().delegate as! AppDelegate).isFBLogin = true
            
            // Transition to home view
            self.performSegueWithIdentifier("GoToHome", sender: self)
        }
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil)
        {
            // Process error
        }
        else if result.isCancelled {
            // Handle cancellations
        }
        else {
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("public_profile")
            {
                // Do work
                returnUserData()
                if loginFromWelcomeScreen {
                    self.performSegueWithIdentifier("GoToHome", sender: self)
                }
            }
        }
    }
    
    @IBAction func FBButtonTouch(sender: UIButton) {
        loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {

        (UIApplication.sharedApplication().delegate as! AppDelegate).isFBLogin = false
        NotNowButton.setTitle("Not now", forState: UIControlState.allZeros)
        ConnectFBButton.setTitle("Connect with Facebook", forState: UIControlState.allZeros)
        
        if (UIApplication.sharedApplication().delegate as! AppDelegate).homeView != nil {
            (UIApplication.sharedApplication().delegate as! AppDelegate).homeView?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func returnUserData()
    {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "/me?fields=id,first_name,last_name,gender,email,timezone", parameters: nil)
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            
            if ((error) != nil)
            {
                // Process error
                println("Error: \(error)")
                (UIApplication.sharedApplication().delegate as! AppDelegate).isFBLogin = false
            }
            else
            {
                (UIApplication.sharedApplication().delegate as! AppDelegate).isFBLogin = true
                self.fbId = result.valueForKey("id") as! String
                self.firstName = result.valueForKey("first_name") as! String
                self.lastName = result.valueForKey("last_name") as! String
                self.gender = result.valueForKey("gender") as! String
                self.email = result.valueForKey("email") as! String
                self.timezone = result.valueForKey("timezone") as! Int
                
                self.updateUserData()
            }
        })
    }
    
    func updateUserData() {
        // Update user data
        userID = (UIApplication.sharedApplication().delegate as! AppDelegate).userID!
        var postData0 = "userId=" + userID + "&facebookId=" + self.fbId
        var postData1 = "&firstName=" + self.firstName + "&lastName=" + self.lastName
        var postData2 = "&email=" + self.email + "&gender=" + self.gender
        var postData3 = "&timezone=" + String(self.timezone)
        var postData = postData0 + postData1 + postData2 + postData3
        
        let urlPath: String = "http://20backendapi15.gegder.com/index.php/user/gegder_user_update"
        var url = NSURL(string: urlPath)
        var request: NSMutableURLRequest = NSMutableURLRequest(URL: url!)
        let queue: NSOperationQueue = NSOperationQueue.mainQueue()
        
        request.HTTPMethod = "POST"
        request.timeoutInterval = 60
        request.HTTPBody = postData.dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPShouldHandleCookies=false
        
        NSURLConnection.sendAsynchronousRequest(request, queue: queue, completionHandler: { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            if data != nil {
                var str = NSString(data: data, encoding: NSUTF8StringEncoding)
                
                if str == "completed" {
                    println("Profile update successfully.")
                }
                else if str == "not_updated" {
                    println("Profile update failed.")
                }
            }
        })
    }
}


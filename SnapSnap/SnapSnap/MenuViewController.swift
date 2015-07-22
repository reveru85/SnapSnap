//
//  MenuViewController.swift
//  Gegder
//
//  Copyright (c) 2015 Genesys. All rights reserved.
//


import UIKit

class MenuViewController: UITableViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    var parentView: UIViewController!
    var welcomeView: WelcomeViewController!
    var option: Int32!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        welcomeView = (UIApplication.sharedApplication().delegate as! AppDelegate).welcomeViewController
        
        var login : Bool
        login = (UIApplication.sharedApplication().delegate as! AppDelegate).isFBLogin!
        
        if login {
            loginButton.setTitle("Logout", forState: UIControlState.allZeros)
        } else {
            loginButton.setTitle("Login", forState: UIControlState.allZeros)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func LaunchWebView(option: Int32) {
        if option != 1 && option != 2 { return }
        
        self.option = option

        parentView.performSegueWithIdentifier("ShowWebView", sender: self)
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func AboutButtonTouch(sender: UIButton) {
        LaunchWebView(1)
    }
    
    
    @IBAction func HelpButtonTouch(sender: UIButton) {
        LaunchWebView(2)
    }
    
    @IBAction func HomeButtonTouch(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: {
            self.parentView.dismissViewControllerAnimated(true, completion: nil)
        })
    }
    
    @IBAction func LoginButtonTouch(sender: UIButton) {
        welcomeView.loginFromWelcomeScreen = false
        welcomeView.loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

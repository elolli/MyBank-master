//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate {

    @IBOutlet weak var Welcome: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if PFUser.currentUser() == nil {
            let login = PFLogInViewController()
            let signup = PFSignUpViewController()
            login.fields = PFLogInFields.UsernameAndPassword | PFLogInFields.SignUpButton | PFLogInFields.LogInButton | PFLogInFields.PasswordForgotten
            
            login.delegate = self
            signup.delegate = self
            
            login.signUpController = signup
            self.presentViewController(login, animated: true, completion: nil)
        }
        else
        {
            var username = PFUser.currentUser().username
            Welcome.text = username
        }
    }
    
    func signUpViewController(signUpController: PFSignUpViewController!, didSignUpUser user: PFUser!) {
        var account = PFObject(className: "transactions")
        account["accountholder"] = PFUser.currentUser()
        user.saveInBackgroundWithBlock{(success:Bool,error:NSError!)->Void in
            if !success {
                NSLog("%@", error)
            }
        }
    }
    
    func signUpViewControllerDidCancelSignUp(signUpController: PFSignUpViewController!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func logInViewController(logInController: PFLogInViewController!, didLogInUser user: PFUser!) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


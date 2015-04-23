//
//  AccountViewController.swift
//  MyBank
//
//  Created by Elise Lawley on 2/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController {

    @IBOutlet weak var BalanceLabel: UILabel!
    @IBOutlet weak var reasonText: UITextField!
    @IBOutlet weak var transAmount: UITextField!
    
    var trans = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var user = PFUser.currentUser()
        var query = PFQuery(className: "transactions")
        
        query.whereKey("accountholder", equalTo: user)
        
        query.findObjectsInBackgroundWithBlock{(objects:[AnyObject]!,error:NSError!)->Void in
            if error == nil {
                if let accountObjects = objects as? [PFObject]{
                    for transact in accountObjects {
                        self.trans += transact["transaction"] as! Double
                    }
                }
                let str = NSString(format:"%.2f", self.trans)
                self.BalanceLabel.text = str as String
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func makeTransaction(sender: AnyObject) {
        var deposit = (transAmount.text as NSString).doubleValue
        var reason = reasonText.text
        var transactions = PFObject(className: "transactions")
        transactions["transaction"] = deposit
        transactions["reason"] = reason
        transactions["accountholder"] = PFUser.currentUser()
        transactions.saveInBackgroundWithBlock{(success:Bool,error:NSError!)->Void in
            if !success {
                NSLog("%@", "Okay logged transaction")
            }
            else {
                NSLog("%@", error)
            }
        }
        let currentBalance = NSString(string: self.BalanceLabel.text!).doubleValue
        let total = currentBalance + deposit
        self.BalanceLabel.text = NSString (format:"%.2f", total) as String
        transAmount.text = ""
        reasonText.text = ""
    }
    

   
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

//
//  ViewController.swift
//  delphi
//
//  Created by Debparna Pratiher on 8/27/16.
//  Copyright © 2016 Debparna Pratiher. All rights reserved.
//

import UIKit

class NoViewController: UIViewController {
    
    @IBAction func clickLearnMore(sender: AnyObject) {
        
        self.performSegueWithIdentifier("showTabBarPage", sender: sender);
    }
    @IBOutlet var txtDays: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //        textField.text=""
        let localDB = NSUserDefaults.standardUserDefaults();
        let daysToNextEvent: Int = localDB.objectForKey("daysToNextEvent") as! Int!
        if(daysToNextEvent == 0){
            txtDays.text = "few days"
        } else {
            txtDays.text =  String(daysToNextEvent) +  " day(s)";
        }
        
        //createButton();
        
        
        
    }
    
    /*func createButton(){
        let button = UIButton(type: UIButtonType.Custom) as UIButton
        button.setTitle("Learn More", forState: .Normal)
        button.addTarget(self, action: "action:", forControlEvents: UIControlEvents.TouchUpInside)
        
        //then make a action method :
        
        func action(sender:UIButton!) {
            var alertView = UIAlertView();
            alertView.addButtonWithTitle("OK");
            alertView.title = "Alert";
            alertView.message = "Button Pressed!!!";
            alertView.show();
        }
        
    }*/
}
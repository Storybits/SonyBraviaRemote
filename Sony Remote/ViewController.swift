//
//  ViewController.swift
//  Sony Remote
//
//  Created by Mark Westenberg on 25/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var tvinit : Bool = false
    var textField : UITextField!
    
    func inittv(pin : String) {
        let connector = Connector()
        tvinit = true
        connector.initializeTV(pin) { (res : Int32) in
            print(res)
            if (res == 0) {
                var alert = UIAlertController(title: "Alert Title", message: "Alert Message", preferredStyle: UIAlertControllerStyle.Alert)
                
                alert.addTextFieldWithConfigurationHandler(self.configurationTextField)
                
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler:{ (UIAlertAction)in
                    //ok clicked
                    self.inittv(self.textField.text!)
                }))
                self.presentViewController(alert, animated: true, completion: {
                    
                })
                return
            }
            if (res == 1) {self.tvinit = false}
            if (self.tvinit) {return}
            
            
            connector.sendRemoteKey("AAAAAQAAAAEAAAAUAw==");
        }
        
    }
    
    func configurationTextField(textField: UITextField!)
    {
        if let tField = textField {
            
            self.textField = textField!        //Save reference to the UITextField
            self.textField.text = "Enter pin"
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        
        
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


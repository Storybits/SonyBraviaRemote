//
//  ViewController.swift
//  Sony Remote
//
//  Created by Mark Westenberg on 25/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    var tvinit = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        
        let connector = Connector()
        tvinit = true
        connector.initializeTV("") { (res : Int32) in
            print(res)
            if (res == 1) {self.tvinit = false}
            if (self.tvinit) {return}
            
            
            connector.sendRemoteKey("AAAAAQAAAAEAAAAUAw==");
        }
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


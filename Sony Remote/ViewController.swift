//
//  ViewController.swift
//  Sony Remote
//
//  Created by Mark Westenberg on 25/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        
        let connector = Connector()
        connector.initializeTV("")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}


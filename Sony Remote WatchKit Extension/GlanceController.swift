//
//  GlanceController.swift
//  Sony Remote WatchKit Extension
//
//  Created by Mark Westenberg on 25/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

import WatchKit
import Foundation


class GlanceController: WKInterfaceController {


    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        
        //UITapGestureRecognizer *newTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(myTapMethod)];
    
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}

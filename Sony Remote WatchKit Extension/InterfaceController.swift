//
//  InterfaceController.swift
//  Sony Remote WatchKit Extension
//
//  Created by Mark Westenberg on 25/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    let currentDevice = WKInterfaceDevice.currentDevice()
    var currentVolume = CGFloat()
    var volumeBarWidth = CGFloat()
    var volumeInterval = CGFloat()
    
    @IBOutlet var volumeBar: WKInterfaceImage!


    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        volumeBarWidth = currentDevice.screenBounds.width
        self.setVolume(volumeBarWidth/2)
        
        volumeInterval = volumeBarWidth/8
        
        let connectTV = Connect()
        connectTV.initializeTV("")
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    func changeVolume(volumeUp volumeUp:Bool) {
        
        if volumeUp
        {
            //more volume
            if (currentVolume < volumeBarWidth)
            {
                currentVolume+=volumeInterval
            }
            
        }
        else
        {
            //less volume
            if (currentVolume > 0)
            {
                currentVolume-=volumeInterval
            }
        }
        self.setVolume()
       
    }
    
    func setVolume() {
        self.setVolume(currentVolume)
    }
    
    func setVolume(volume:CGFloat) {
        currentVolume = volume
        self.volumeBar.setWidth(volume)
    }
    
    @IBAction func increaseVolume() {
        self.changeVolume(volumeUp: true)
    }
    
    @IBAction func decreaseVolume() {
        self.changeVolume(volumeUp: false)
    }
 
}

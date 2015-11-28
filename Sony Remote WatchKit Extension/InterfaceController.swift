//
//  InterfaceController.swift
//  Sony Remote WatchKit Extension
//
//  Created by Mark Westenberg on 25/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController, ConnectDelegate {

    let currentDevice = WKInterfaceDevice.currentDevice()
    var currentVolume = CGFloat()
    var volumeBarWidth = CGFloat()
    var volumeInterval = CGFloat()
    var muted: Bool = false
    let connectTV = Connect()
    var tvInit: Bool = false
    
    @IBOutlet var volumeBar: WKInterfaceImage!
    @IBOutlet var muteButton: WKInterfaceButton!


    
    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        volumeBarWidth = currentDevice.screenBounds.width
        self.setVolume(volumeBarWidth/2)
        
        volumeInterval = volumeBarWidth/8
        
        
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
    
    //delegate method
    func httpResponse(jsonData: AnyObject) {
        self.tvInit = true
        print("connectie met tv")
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
        connectTV.sendRemoteKey("AAAAAQAAAAEAAAASAw==")
    }
    
    @IBAction func decreaseVolume() {
        self.changeVolume(volumeUp: false)
        connectTV.sendRemoteKey("AAAAAQAAAAEAAAATAw==")
    }
 
    @IBAction func muteSound() {
        if self.muted
        {
            self.muted = false
            self.muteButton.setBackgroundImage(UIImage(named: "unmute"))
        }
        else
        {
            self.muted = true
            self.muteButton.setBackgroundImage(UIImage(named: "mute"))
        }
        
        
       connectTV.sendRemoteKey("AAAAAQAAAAEAAAAUAw==")
    }
    
    @IBAction func powerOff() {
        
        connectTV.sendRemoteKey("AAAAAQAAAAEAAAAvAw==")
    }
    
    @IBAction func channelUp() {
        
        connectTV.sendRemoteKey("AAAAAQAAAAEAAAAQAw==")
    }
    @IBAction func channelDown() {
        connectTV.sendRemoteKey("AAAAAQAAAAEAAAARAw==")
    
    }
    
    
    
}

//
//  Connect.swift
//  Sony Remote
//
//  Created by Mark Westenberg on 27/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

import Foundation
import WatchKit

var TV_IP: String = "192.168.1.30"
var API_VERSION: String = "1.0"

class Connect {
    
    var id_counter: Int = 0
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    init(){
        
        
    }
    
    func initializeTV(pin: String) {
        self.httpCall("http://\(TV_IP)/sony/system", body: self.getJsonMethod("getInterfaceInformation"), pin: pin)
        
    }
    
    
    func getJsonMethod(method: String) -> String {
        id_counter++
        return "{\"id\" : \(id_counter),\"method\" : \"\(method)\",\"params\" : [],\"version\" : \"\(API_VERSION)\"}"
        
    }
    
    
    func httpCall(urlPath: String, body: String, var pin: String) {
        
        let url : NSURL = NSURL(string: urlPath)!
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: config)
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.timeoutInterval = 5.0
        
        let requestBodyData = (body as NSString).dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPBody = requestBodyData
        request.setValue("text/plain", forHTTPHeaderField: "Content-type")
        if !pin.isEmpty
        {
            pin = ":\(pin)"
        }
        let pincode = pin.dataUsingEncoding(NSUTF8StringEncoding)
        let encodedPin = pincode!.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
        request.setValue("Basic \(encodedPin)", forHTTPHeaderField: "Authorization")
        

        let task = session.dataTaskWithRequest(request, completionHandler: {
            (data, response, error) -> Void in
            
            do {
                
                if data == nil
                {
                    throw JSONError.NoData
                }
                
                let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as AnyObject?
                
                if (jsonData == nil)
                {
                    
                    throw JSONError.ConversionFailed
                    
                }
                else
                {
                    self.httpResponse(jsonData!)
                }
                
            } catch let error as JSONError {
                // handle error
                print(error.rawValue)
                
            } catch {
                print(error)
            }
        })
        task.resume()
        
    }
    
    func httpResponse(jsonData:AnyObject) {
        print(jsonData)
        
        
    }
    
    
}

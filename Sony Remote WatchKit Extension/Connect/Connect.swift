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
var NICKNAME: String = "Macbook OSX"
var CLIENT: String = "MacOSX:5EF3FF8C-1EB0-4E1D-B53C-038969B6BC7F"

class Connect {
    
    var id_counter: Int = 0
    var authCookie: String
    
    enum JSONError: String, ErrorType {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    init(){
        self.authCookie = ""
        
    }
    
    func initializeTV(pin: String) {
       // self.httpCall("/sony/accessControl", body: self.getJsonMethod("actRegister"), pin: pin)
        self.httpCall("/sony/accessControl", body: self.getJsonMethod("actRegister", params: "{\"clientid\":\"\(CLIENT)\",\"nickname\":\"\(NICKNAME)\"},[{\"value\" : \"no\",\"function\" : \"WOL\"}]"), pin: pin)
    }
    
    
    func getJsonMethod(method: String, params: String) -> String {
        id_counter++
        return "{\"id\" : \(id_counter),\"method\" : \"\(method)\",\"params\" : [\(params)],\"version\" : \"\(API_VERSION)\"}"
        
    }
    
    
    func httpCall(urlPath: String, body: String, var pin: String) {
        
        let url : NSURL = NSURL(string: "http://\(TV_IP)\(urlPath)")!
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
                
                
                //we have a response
                let dataStr:NSString = NSString(data: data!, encoding: NSASCIIStringEncoding)!
                print(dataStr)
                
                let cookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
                let cookies = cookieStorage.cookies! as [NSHTTPCookie]
                for cookie in cookies {
                    if cookie.name == "auth"
                    {
                        self.authCookie = cookie.value
                        print(self.authCookie)
                    }
                    
                }
                
                if dataStr.hasPrefix("{")
                {
                
                    let jsonData = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as AnyObject?
                    
                    if (jsonData == nil)
                    {
                        
                        throw JSONError.ConversionFailed
                        
                    }
                    else
                    {
                        self.httpResponse(jsonData!)
                    }
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
    
    
    
    func sendRemoteKey(key:String) {
        let body = "<?xml version=\"1.0\"?><s:Envelope xmlns:s=\"http:/schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:X_SendIRCC xmlns:u=\"urn:schemas-sony-com:service:IRCC:1\"><IRCCCode>\(key)</IRCCCode></u:X_SendIRCC></s:Body></s:Envelope>"
        
        
        self.httpCall("/sony/IRCC", body: body, pin: "")
        
    }
    
}

//
//  Connector.m
//  Sony Remote
//
//  Created by Timon van Rooijen on 27/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

#import "Connector.h"

@implementation Connector

- (NSString *)getJsonRequestFromFunction:(NSString *)function andParams:(NSString *)params {
    _idCounter++;
    
    return [NSString stringWithFormat:@"{\"id\" : %d,\"method\" : \"%@\",\"params\" : [%@],\"version\" : \"%@\"}", _idCounter, function, params, APIVERSION];
}

- (void)httpError:(NSError *)error {
    _completionHandler(NO);
}

- (void)httpOK:(NSString *)response {
    //try to parse as json
    if ([response hasPrefix:@"{"]) {
        NSError *localError = nil;
        NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&localError];
        if (localError)
        {
            //json error message returned
            NSLog(@"error: %@", localError.debugDescription);
            _completionHandler(NO);
            return;
        }
        //yay, we have json
        if (parsedObject[@"error"] != nil) {
            _completionHandler(NO);
            return;
        }
        
    } else {
        _completionHandler(NO); //no json
        return;
        
    }
    
    _completionHandler(YES);
    
}

- (void) doHTTP:(NSString *)path withBody:(NSString *)body andPincode:(NSString *)pin {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@%@",tv_ip, path]];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    urlRequest.HTTPMethod           = @"POST";
    urlRequest.timeoutInterval      = 5;
    urlRequest.HTTPBody             = [[NSString stringWithFormat:@"%@",body] dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setValue:@"text/plain" forHTTPHeaderField:@"Content-type"];
    
    NSData *authData = [[NSString stringWithFormat:@"%@:%@", @"", pin] dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setValue:[NSString stringWithFormat:@"Basic %@",[authData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed]] forHTTPHeaderField:@"Authorization"];
    
    NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithRequest:urlRequest
                                    completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable connectionError)
    {
                                        
        if (connectionError || !data) {
            //handle response
            dispatch_async(dispatch_get_main_queue(), ^{
                //report failed
                [self httpError:connectionError];
                });
            return;
        }
                                        
        //post went OK
        NSString *s_response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        //get authentication cookie (if present)
        for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
            if ([cookie.name isEqualToString:@"auth"]) {
                self.authCookie = cookie.value;
            }
        }
        
        if ([s_response hasPrefix:@"{"]) {
            //json response
            //NSLog(@"response: %@", s_response);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self httpOK:s_response];
                });
            return;
            } else {
                //Geen JSON teruggekregen.
                }
                                                                       
                                                                   
             }];
    
    [dataTask resume];

}

- (void) initializeTV:(NSString *)pin withCompletionHandler:(void(^)(int))handler {
    _completionHandler = [handler copy];
    
    _idCounter = 0;
    
    //Get device info
//    [self doHTTP:@"/sony/system" withBody:[self getJsonRequestFromFunction:@"getInterfaceInformation" andParams:@""] andPincode:pin];

    
    [self doHTTP:@"/sony/accessControl" withBody:[self getJsonRequestFromFunction:@"actRegister" andParams:[NSString stringWithFormat:@"{\"clientid\":\"%@\",\"nickname\":\"%@\"},[{\"value\" : \"no\",\"function\" : \"WOL\"}]", client, nickname]] andPincode:pin];
    
}

- (void) sendRemoteKey:(NSString *)key {
    [self doHTTP:@"/sony/IRCC" withBody:[NSString stringWithFormat:@"<?xml version=\"1.0\"?><s:Envelope xmlns:s=\"http:/schemas.xmlsoap.org/soap/envelope/\" s:encodingStyle=\"http://schemas.xmlsoap.org/soap/encoding/\"><s:Body><u:X_SendIRCC xmlns:u=\"urn:schemas-sony-com:service:IRCC:1\"><IRCCCode>%@</IRCCCode></u:X_SendIRCC></s:Body></s:Envelope>",key] andPincode:@""];
    
}


@end

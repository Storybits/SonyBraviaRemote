//
//  Connector.m
//  Sony Remote
//
//  Created by Timon van Rooijen on 27/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

#import "Connector.h"

@implementation Connector

- (NSString *)getJsonRequestFromFunction:(NSString *)function {
    _idCounter++;
    return [NSString stringWithFormat:@"{\"id\" : %d,\"method\" : \"%@\",\"params\" : [],\"version\" : \"%@\"}", _idCounter, function, APIVERSION];
}

- (void)httpError:(NSError *)error {
    
}

- (void)httpOK:(NSString *)response {
    NSLog(@"response: %@", response);
    
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
                NSLog(@"auth: %@", cookie.value);
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

- (TV *) initializeTV:(NSString *)pin {
    _idCounter = 0;
    
    TV *tv = nil;
    
    [self doHTTP:@"/sony/system" withBody:[self getJsonRequestFromFunction:@"getInterfaceInformation"] andPincode:pin];
    
    return tv;
}


@end

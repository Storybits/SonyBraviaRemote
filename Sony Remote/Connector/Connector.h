//
//  Connector.h
//  Sony Remote
//
//  Created by Timon van Rooijen on 27/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TV.h"

@interface Connector : NSObject {
    void (^_completionHandler)(BOOL result);
    
}

#define APIVERSION  @"1.0"
#define tv_ip       @"192.168.1.30"
#define client      @"MacOSX:5EF3FF8C-1EB0-4E1D-B53C-038969B6BC7F"
#define nickname    @"Macbook OSX"

@property (nonatomic, assign) int               idCounter;
@property (nonatomic, strong) TV                *tv;
@property (nonatomic, strong) NSString          *authCookie;

//Geeft NIL terug als niet geautoriseerd. Dan nog een x aanroepen met pincode gevuld.
- (void) initializeTV:(NSString *)pin withCompletionHandler:(void(^)(int))handler;
- (void) sendRemoteKey:(NSString *)key;

@end

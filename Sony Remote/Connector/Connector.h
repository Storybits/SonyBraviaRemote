//
//  Connector.h
//  Sony Remote
//
//  Created by Timon van Rooijen on 27/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TV.h"

@interface Connector : NSObject

#define APIVERSION  @"1.0"
#define tv_ip       @"192.168.1.115"

@property (nonatomic, assign) int               idCounter;
@property (nonatomic, strong) TV                *tv;
@property (nonatomic, strong) NSString          *authCookie;

//Geeft NIL terug als niet geautoriseerd. Dan nog een x aanroepen met pincode gevuld.
- (TV *) initializeTV:(NSString *)ip withPincode:(NSString *)pin;

@end

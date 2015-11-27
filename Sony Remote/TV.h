//
//  TV.h
//  Sony Remote
//
//  Created by Timon van Rooijen on 27/11/15.
//  Copyright © 2015 Mark Westenberg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TV : NSObject

@property (nonatomic, strong)   NSString    *interfaceVersion;
@property (nonatomic, strong)   NSString    *modelName;
@property (nonatomic, strong)   NSString    *productCategory;
@property (nonatomic, strong)   NSString    *productName;


@end

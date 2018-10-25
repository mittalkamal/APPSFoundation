//
//  APPSDDLogLevel.h
//
//  Created by Chris Morris on 7/17/14.
//  Copyright (c) 2014 Appstronomy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSDDLogLevel : NSObject


#pragma mark - Logging via Lumberjack

+ (int)ddLogLevel;

+ (void)ddSetLogLevel:(int)logLevel;


@end

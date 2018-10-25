//
//  APPSDDLogLevel.m
//
//  Created by Chris Morris on 7/17/14.
//  Copyright (c) 2014 Appstronomy LLC. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "APPSDDLogLevel.h"
#import "APPSLumberjack.h"

@implementation APPSDDLogLevel

#pragma mark - Logging via Lumberjack

// Static: One shared log level
static int __ddLogLevel = DDLogLevelDebug;

+ (int)ddLogLevel
{
    return __ddLogLevel;
}

+ (void)ddSetLogLevel:(int)logLevel
{
    __ddLogLevel = logLevel;
}

@end

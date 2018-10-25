//
//  APPSTargetConfiguration.m
//
//  Created by Sohail Ahmed on 8/26/15.
//

#import "APPSTargetConfiguration.h"


@implementation APPSTargetConfiguration

// static
static NSNumber *__isRunningTests;


#pragma mark - Inquiries

+ (BOOL)isRunningTests;
{
    if (!__isRunningTests) {
        __isRunningTests = @(NSClassFromString(@"XCTestCase") != Nil);
    }
    
    return [__isRunningTests boolValue];
}


+ (NSString *)resourceToken
{
    NSString *token = @"";
    
    if ([self isRunningTests]) {
        token = kAPPSTargetConfigurationResourceToken_Test;
    }
    else {
        token = kAPPSTargetConfigurationResourceToken_Main;
    }
    
    return token;
}



@end

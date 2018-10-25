//
//  APPSTargetConfiguration.h
//
//  Created by Sohail Ahmed on 8/26/15.
//

#import <Foundation/Foundation.h>

#pragma mark - Target Configuration Resource Tokens

static NSString *const kAPPSTargetConfigurationResourceToken_Main       = @"main";
static NSString *const kAPPSTargetConfigurationResourceToken_Test       = @"test";

/**
 Provides information about the currently running target, such as whether we are running tests 
 at present.
 */
@interface APPSTargetConfiguration : NSObject

#pragma mark - Inquiries

/**
 We need a mechanism to detect if we have been invoked / are running from a unit test.
 If we are, we'll want to exit early instead of doing all kinds of view controller setup.
 This function determines based on the environment, if we're running in a unit test process.
 */
+ (BOOL)isRunningTests;


/**
 Returns a token appropriate for use in filenames for the current target configuration (i.e. "main", "test").
 
 @return A string for the current target configuration.
 */
+ (NSString *)resourceToken;


@end

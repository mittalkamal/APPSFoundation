//
//  APPSBaseTestCase.m
//
//  Created by Sohail Ahmed on 5/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "APPSBaseTestCase.h"
#import "APPSDDLogFormatter.h"

@implementation APPSBaseTestCase


#pragma mark - File Level Setup and Tear Down

/**
 In your subclasses, make a call to super (this method) FIRST, before you do all
 of your own set up operations.
 */
+ (void)setUp {
    [super setUp];
    
    // We only want the logger configuration run once, but we have no "main" class to do
    // that in, so we'll settle for at the start of each test class, ensuring we only do
    // this once:
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self configureLoggers];
    });
    
    logDebug(@"+++++++++++++++++++++++++ class level set up: starting +++++++++++++++++++++++++");
}


/**
 In your subclasses, make a call to super (this method) LAST, after you do all
 of your own tear down operations.
 */
+ (void)tearDown {
#if defined (CONFIGURATION_CODECOVERAGE)
    __gcov_flush(); // Temporary hack to force .gcda code coverage file generation, per: https://devforums.apple.com/message/870971#870971
#endif
    
    [super tearDown];
    
    logDebug(@"========================= class level tear down: completed =========================");
}



#pragma mark - Test Level Setup and Tear Down

/**
 In your subclasses, make a call to super (this method) FIRST, before you do all
 of your own set up operations. We do NOT issue a save here, so the Managed Objects created
 only exist in the default managed object context.
 */
- (void)setUp {
    [super setUp];
    
    logDebug(@"~~~~~~~~~~~~~~~~~~~~~~~~~ test level set up: starting ~~~~~~~~~~~~~~~~~~~~~~~~~");
}


/**
 In your subclasses, make a call to super (this method) LAST, after you do all
 of your own tear down operations.
 */
- (void)tearDown {
    [super tearDown];
    
    logDebug(@"------------------------- test level tear down: completed -------------------------");
}



#pragma mark - Logging Configuration

+ (void)configureLoggers {
    // Configure loggers to format using our more verbose formatter style:
    APPSDDLogFormatter *logFormatter = [[APPSDDLogFormatter alloc] init];
	[[DDASLLogger sharedInstance] setLogFormatter:logFormatter];
	[[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];
    
    // Add the standard output and Xcode console loggers to where our output goes:
    [DDLog addLogger:[DDASLLogger sharedInstance]];
	[DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    logInfo(@"Lumberjack Logging for XCTest Target Successfully Configured.");
}



@end

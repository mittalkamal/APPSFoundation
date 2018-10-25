//
//  APPSReachabilityManager.m
//
//  Created by Sohail Ahmed on 9/8/15.
//

#import "APPSReachabilityManager.h"
#import "TMReachability.h"
#import "APPSLumberjack.h"


@implementation APPSReachabilityManager

static APPSReachabilityManager *__sharedInstance = nil;

#pragma mark - Default Manager

+ (APPSReachabilityManager *)sharedManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __sharedInstance = [[self alloc] init];
        logInfo(@"Instantiated Reachability Manager: %@", __sharedInstance);
    });
    
    return __sharedInstance;
}



#pragma mark - Memory Management

- (void)dealloc {
    // Stop Notifier
    if (_reachability) {
        [_reachability stopNotifier];
    }
}



#pragma mark - Inquiries

+ (BOOL)isReachable
{
    return [[[APPSReachabilityManager sharedManager] reachability] isReachable];
}


+ (BOOL)isUnreachable
{
    return ![[[APPSReachabilityManager sharedManager] reachability] isReachable];
}


+ (BOOL)isReachableViaWWAN
{
    return [[[APPSReachabilityManager sharedManager] reachability] isReachableViaWWAN];
}


+ (BOOL)isReachableViaWiFi
{
    return [[[APPSReachabilityManager sharedManager] reachability] isReachableViaWiFi];
}



#pragma mark - Private Initialization

- (id)init
{
    self = [super init];
    
    if (self) {
        // Initialize Reachability
        self.reachability = [TMReachability reachabilityWithHostname:kAPPSReachabilityManager_SentinelHostname];
        
        // Start Monitoring
        [self.reachability startNotifier];
        
        logInfo(@"Initiated Reachability monitoring using hostname: %@", kAPPSReachabilityManager_SentinelHostname);
    }
    
    return self;
}


@end

//
//  APPSReachabilityManager.h
//
//  Created by Sohail Ahmed on 9/8/15.
//

#import <Foundation/Foundation.h>

/**
 This is the host we try to connect to, as our litmus test of whether the app (device)
 has connectivity out to the Internet.
 */
static NSString * const kAPPSReachabilityManager_SentinelHostname = @"www.google.com";


@class TMReachability;

/**
 This Reachability Manager is our way of providing a convenient interface to the Tony Million Reachability class
 (which was itself adapted from Apple's example code). We don't pull Reachability in as a Cocoapod, because it
 has conflicts with Apple's namespace. That's why we've copied it in and renamed "TMReachability".
 
 We use a generic website address (google) to determine if we have Internet connectivity.
 
 You can use this class to simply determine at the time, if we have connectivity (assuming we were started on app launch).
 
 This class is based on code and ideas published here: http://code.tutsplus.com/tutorials/ios-sdk-detecting-network-changes-with-reachability--mobile-18299
 */
@interface APPSReachabilityManager : NSObject

#pragma mark strong

/**
 Our instance of the Reachability class, which does all of the heavy lifting. You can swap it out with another instance
 that you instantiate to point to a different resource, if need be.
 */
@property (strong, nonatomic) TMReachability *reachability;


#pragma mark - Shared Manager

+ (APPSReachabilityManager *)sharedManager;


#pragma mark - Inquiries

+ (BOOL)isReachable;

+ (BOOL)isUnreachable;

+ (BOOL)isReachableViaWWAN;

+ (BOOL)isReachableViaWiFi;


@end

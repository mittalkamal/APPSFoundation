//
//  APPSBuildConfiguration.m
//  Appstronomy Standard Kit
//
//  Created by Sohail Ahmed on 6/11/15.
//  Copyright (c) 2014 Appstronomy LLC. All rights reserved.
//

#import "APPSBuildConfiguration.h"


@interface APPSBuildConfiguration ()
@end


@implementation APPSBuildConfiguration

// static
static APPSBuildConfiguration *__sharedInstance = nil;
static BOOL __isSetup = NO;
static BOOL __hasAlredyWarnedAboutNotBeingSetup = NO;


#pragma mark - Singleton

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceTokenSharedInstance;
    
    dispatch_once(&onceTokenSharedInstance, ^{
        // Instantiation; we use [self class] so we can be subclassed if ever needed:
        __sharedInstance = [[[self class] alloc] init];
        
        // Default to an Development build, unless advised otherwise. This allows us
        // to work optimally with unit tests that may not ever explicitly configure us.
        __sharedInstance.type = APPSBuildConfigurationType_Development;
    });
    
    return __sharedInstance;
}



#pragma mark - Instantiation

+ (instancetype)sharedInstanceUsingConfigurationType:(APPSBuildConfigurationType)configurationType;
{
    APPSBuildConfiguration *sharedInstance = [APPSBuildConfiguration sharedInstance];
    
    sharedInstance.type = configurationType;
    
    __isSetup = YES; // Mark that the configuration type we hold is a conscious choice that the host app has made.
    
    NSLog(@"APPSBuildConfiguration: Configured to use '%@' build configuration type.", [APPSBuildConfiguration displayFriendlyName]);
    
    return sharedInstance;
}



#pragma mark - Inquiries

+ (enum APPSBuildConfigurationType)type;
{
    return [(APPSBuildConfiguration *)[self sharedInstance] type];
}


+ (void)displaySetupWarningIfNecessary;
{
    if (!__isSetup && !__hasAlredyWarnedAboutNotBeingSetup) {
        NSLog(@"WARNING: APPSBuildConfiguration class has not yet been setup by host app. "
                              "Defaulting to: '%@'", [self displayFriendlyName]);
        __hasAlredyWarnedAboutNotBeingSetup = YES;
    }
}


+ (BOOL)isDevelopmentBuild;
{
    [self displaySetupWarningIfNecessary];
    
    return (APPSBuildConfigurationType_Development == [(APPSBuildConfiguration *)[self sharedInstance] type]);
}


+ (BOOL)isAdHocBetaBuild;
{
    [self displaySetupWarningIfNecessary];
    
    return (APPSBuildConfigurationType_AdHoc == [(APPSBuildConfiguration *)[self sharedInstance] type]);
}


+ (BOOL)isAppStoreBuild;
{
    [self displaySetupWarningIfNecessary];
    
    return (APPSBuildConfigurationType_AppStore == [(APPSBuildConfiguration *)[self sharedInstance] type]);
}


+ (NSString *)resourceToken
{
    NSString *buildToken = @"";
    
    if (self.isDevelopmentBuild) {
        buildToken = kAPPSBuildConfigurationResourceToken_Development;
    }
    else if (self.isAdHocBetaBuild) {
        buildToken = kAPPSBuildConfigurationResourceToken_AdHocBeta;
    }
    else if (self.isAppStoreBuild) {
        buildToken = kAPPSBuildConfigurationResourceToken_AppStore;
    }
    
    return buildToken;
}


+ (NSString *)displayFriendlyName
{
    NSString *buildToken = @"";
    
    switch ([self type]) {
        case APPSBuildConfigurationType_Development:
            buildToken = kAPPSBuildConfigurationDisplayFriendlyName_Development;
            break;
        case APPSBuildConfigurationType_AdHoc:
            buildToken = kAPPSBuildConfigurationDisplayFriendlyName_AdHocBeta;
            break;
        case APPSBuildConfigurationType_AppStore:
            buildToken = kAPPSBuildConfigurationDisplayFriendlyName_AppStore;
            break;
            
        default:
            buildToken = kAPPSBuildConfigurationDisplayFriendlyName_Unknown;
            break;
    }
    
    return buildToken;
}


@end

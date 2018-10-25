//
//  APPSBuildConfiguration.h
//  Appstronomy Standard Kit
//
//  Created by Sohail Ahmed on 6/11/15.
//  Copyright (c) 2014 Appstronomy LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

// Build Configuration Types
typedef NS_ENUM(NSUInteger, APPSBuildConfigurationType) {
    APPSBuildConfigurationType_Unknown = 0,
    APPSBuildConfigurationType_Development,
    APPSBuildConfigurationType_AdHoc,
    APPSBuildConfigurationType_AppStore
};

// Build Configuration Resource Tokens
static NSString *const kAPPSBuildConfigurationResourceToken_Development = @"debug";
static NSString *const kAPPSBuildConfigurationResourceToken_AdHocBeta   = @"adhoc";
static NSString *const kAPPSBuildConfigurationResourceToken_AppStore    = @"appstore";

// Build Configuration Display-friendly Names
static NSString *const kAPPSBuildConfigurationDisplayFriendlyName_Development = @"Development";
static NSString *const kAPPSBuildConfigurationDisplayFriendlyName_AdHocBeta   = @"Beta";
static NSString *const kAPPSBuildConfigurationDisplayFriendlyName_AppStore    = @"App Store";
static NSString *const kAPPSBuildConfigurationDisplayFriendlyName_Unknown     = @"Unknown";

/**
 The build configuration conveniences here save you from having to litter your application code with 
 messy pre-processor macros.
 
 However, if your app uses a different nomenclature for configurations than those assumed here, then these build inquiry
 methods cannot be used. 
 
 It is recommended that your app, which links with the Appstronomy Standard Kit as a dependency, use the following configurations:
 
    * @c CONFIGURATION_DEBUG -      A development build. Usually corresponds to the scheme 'Development'.
    * @c CONFIGURATION_ADHOC -      A limited testing distribution for alpha and beta builds.
                                    Usually corresponds to the scheme 'AdHoc'.
    * @c CONFIGURATION_APPSTORE -   A build targeted for the App Store. Usually corresponds to the scheme 'Release'.
 
 Although this class does @em not look for preprocessor macros, your encompassing app should, and then set that value on the shared 
 instance of this class, so that it is conveniently and globally available through out static inquiry methods.
 
 It is recommended that you implement the following method in your host app (and then call it within your host app), 
 at the earliest point in your app's lifecycle as you deem safe. Alternatively, you can just paste the contents of this 
 example method into an early entry point within your app.
 
     - (void)configureBuildConfiguration;
     {
         APPSBuildConfigurationType configurationType = APPSBuildConfigurationType_AppStore; // Default
         
         #ifdef CONFIGURATION_DEBUG
             configurationType = APPSBuildConfigurationType_Development;
         #elif CONFIGURATION_ADHOC
             configurationType = APPSBuildConfigurationType_AdHoc;
         #elif CONFIGURATION_APPSTORE
             configurationType = APPSBuildConfigurationType_AppStore;
         #endif
         
         [APPSBuildConfiguration sharedInstanceUsingConfigurationType:configurationType];
     }
 
 We only use NSLog statements in this class, since it is advised that you set up the shared instance even before logging
 services like Cocoa Lumberjack. That's because logging configuration is often dependent on the currently running 
 build configuration.
 */
@interface APPSBuildConfiguration : NSObject

#pragma mark scalar

/**
 The property that holds the build type we represent. We no longer set this from a compile time preprocessor variable,
 as the Appstronomy Standard Kit is a framework that will be compiled independently. Therefore, host applications
 that make use of the Appstronomy Standard Kit should set this value on the @c sharedInstance immediately.
 */
@property (assign, nonatomic) enum APPSBuildConfigurationType type;



#pragma mark - Instantiation

/**
 This is the simplest way to ensure instantiation and that the @c APPSBuildConfigurationType
 has been set.
 
 @param configurationType       The enum value set by the host application to indicate whether this is a
                                development build, adhoc build or appstore build.
 
 @return The shared instance.   Although, you are encouraged to just continue to use the convenience class methods
                                to retrieve the shared instance in future calls, after this call has been made to 
                                set the configuration type..
 */
+ (instancetype)sharedInstanceUsingConfigurationType:(APPSBuildConfigurationType)configurationType;



#pragma mark - Inquiries

/**
 Advises on the current build configuration type, by returning the enum option that we've defined in this
 header. The enum belongs to @c APPSBuildConfigurationType. This value is retrieved from our shared instance's
 property of the same name.
 
 @return An enum option indicating the build configuration type.
 */
+ (enum APPSBuildConfigurationType)type;


/**
 Advises if the current build configuration represents a development build.
 
 @return YES if this app's current build is using a development configuration.
 */
+ (BOOL)isDevelopmentBuild;


/**
 Advises if the current build configuration represents an adhoc build.
 
 @return YES if this app's current build is using an adhoc configuration.
 */
+ (BOOL)isAdHocBetaBuild;


/**
 Advises if the current build configuration represents an appstore build.
 
 @return YES if this app's current build is using an appstore configuration.
 */
+ (BOOL)isAppStoreBuild;


/**
 Returns a token appropriate for use in filenames for the current build configuration (i.e. "debug", "adhoc", "appstore").
 
 @return A string for the current build configuration.
 */
+ (NSString *)resourceToken;


/**
 Returns a display friendly name of the configuration, appropriate for use in display text, reflecting the current build configuration.
 Names may be long and/or contain spaces, such as "App Store" or "Development".
 
 @return A display-friendly name for the current build configuration.
 */
+ (NSString *)displayFriendlyName;


@end

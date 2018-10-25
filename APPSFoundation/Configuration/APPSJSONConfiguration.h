//
//  APPSJSONConfiguration.h
//
//  Created by Sohail Ahmed on 9/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APPSJSONConfiguration : NSObject

/**
 The bundle in which configuration data files can be found. If not set, we'll use the default bundle.
 */
@property (strong, nonatomic) NSBundle *dataSetBundle;



#pragma mark - Configuration

/**
 Subclasses must call super (to invoke our implementation) before adding in their own
 default configuration logic.
 */
- (void)applyDefaultConfiguration;



#pragma mark - Utilities

- (NSString *)filePathForResourceNamed:(NSString *)resourceName;

- (id)jsonObjectEntriesForResourceNamed:(NSString *)resourceName;


@end

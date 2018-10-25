//
//  APPSJSONConfiguration.m
//
//  Created by Sohail Ahmed on 9/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "APPSImports+Macros.h"
#import "APPSJSONConfiguration.h"


@implementation APPSJSONConfiguration

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self applyDefaultConfiguration];
    }
    return self;
}



#pragma mark - Configuration

- (void)applyDefaultConfiguration
{
    // The default bundle we use is the app's own main bundle. However, unit tests
    // with resources that only exist in the test target, will need to set this
    // explicitly to point to their Test NSBundle:
    if (!self.dataSetBundle) { self.dataSetBundle = [NSBundle mainBundle]; }
}



#pragma mark - Utilities

- (NSString *)filePathForResourceNamed:(NSString *)resourceName;
{
    NSString *resourceFilePath = [self.dataSetBundle pathForResource:resourceName ofType:@"json"];
    
    APPSAssert(resourceFilePath, @"Could not build path for resource named '%@.json'", resourceName);
    
    return resourceFilePath;
}


- (id)jsonObjectEntriesForResourceNamed:(NSString *)resourceName;
{
    NSString *resourceFilePath = [self filePathForResourceNamed:resourceName];
    
    APPSAssert([[NSFileManager defaultManager] fileExistsAtPath:resourceFilePath],
               @"There was no JSON file to load for resource with name '%@'. "
               "We were looking at file path: %@", resourceName, resourceFilePath);
    
    NSError *error = nil;
    id JSONEntries = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:resourceFilePath]
                                                     options:(NSJSONReadingOptions)kNilOptions
                                                       error:&error];
    
    APPSAssert(!error, @"Problem with loading of configuration JSON resource '%@'. Details:\n%@",
               resourceName, [error localizedDescription]);
    
    return JSONEntries;
}


@end

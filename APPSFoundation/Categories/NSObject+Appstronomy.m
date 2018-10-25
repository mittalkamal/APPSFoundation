//
//  NSObject+Appstronomy.m
//
//  Created by Sohail Ahmed on 7/10/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "NSObject+Appstronomy.h"
#import <objc/runtime.h>

@implementation NSObject (Appstronomy)

#pragma mark - Introspection

+ (BOOL)apps_hasPropertyNamed:(NSString *)name
{
    // CREDIT: http://stackoverflow.com/a/20926187/535054
    return (class_getProperty(self, [name UTF8String]) != NULL);
}



#pragma mark - Loading Attribute Property Values in Bulk

- (void)apps_loadPropertyAttributes:(NSDictionary *)valuesDictionary;
{
    // Loop through all keys:
    for (NSString *key in [valuesDictionary allKeys]) {
        // Before we set it, we'll ensure we have a property with that name:
        if ([[self class] apps_hasPropertyNamed:key]) {
            // Safe to set our property with the requested value:
            [self setValue:valuesDictionary[key] forKey:key];
        }
    }
}



#pragma mark - Block Conveniences

- (void)apps_performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay
{
    int64_t delta = (int64_t)(1.0e9 * delay);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}


@end

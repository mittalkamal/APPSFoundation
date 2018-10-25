//
//  NSObject+Appstronomy.h
//
//  Created by Sohail Ahmed on 7/10/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Appstronomy)

#pragma mark - Introspection

/**
 Will advise if we have a property with the specified name.
 
 @param name The name of the property to check for.
 
 @return YES if we have such a property.
 */
+ (BOOL)apps_hasPropertyNamed:(NSString *)name;



#pragma mark - Loading Attribute Property Values in Bulk

/**
 Intelligently loads values from the provided dictionary onto this model.
 
 @param valuesDictionary The key-value pairs we are to set. We'll ignore keys we don't
 understand, so you can pass in a large dictionary where only a part of it is actually
 meant for us.
 */
- (void)apps_loadPropertyAttributes:(NSDictionary *)valuesDictionary;



#pragma mark - Block Conveniences

/**
 Allows you to process some block of operations, after a specified delay.
 Sourced from: http://forrst.com/posts/Delayed_Blocks_in_Objective_C-0Fn
 */
- (void)apps_performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end

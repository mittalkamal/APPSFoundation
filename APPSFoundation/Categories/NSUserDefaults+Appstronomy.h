//
//  NSUserDefaults+Appstronomy.h
//  PKPDCalculator
//
//  Created by Ken Grigsby on 6/22/15.
//  Copyright (c) 2015 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Appstronomy)

/**
 Sets the value of the specified default key to the specified date.
 
 @param date         The date to store in the defaults database.
 @param defaultName  The key with which to associate with the value.
 */
- (void)apps_setDate:(NSDate *)date forKey:(NSString *)defaultName;

/**
 Returns the date associated with the specified key.
 
 @param defaultName A key in the current user's defaults database.
 
 @return The date associated with the specified key, or nil if the key was not found.

 */
- (NSDate *)apps_dateForKey:(NSString *)defaultName;

@end

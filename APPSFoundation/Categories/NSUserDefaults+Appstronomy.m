//
//  NSUserDefaults+Appstronomy.m
//  PKPDCalculator
//
//  Created by Ken Grigsby on 6/22/15.
//  Copyright (c) 2015 Appstronomy, LLC. All rights reserved.
//

#import "NSUserDefaults+Appstronomy.h"
#import "APPSImports+Macros.h"

@implementation NSUserDefaults (Appstronomy)

- (void)apps_setDate:(NSDate *)date forKey:(NSString *)defaultName
{
    [self setObject:date forKey:defaultName];
}


- (NSDate *)apps_dateForKey:(NSString *)defaultName
{
    id date = [self objectForKey:defaultName];
    APPSAssert(!date || [date isKindOfClass:[NSDate class]], @"Object for key: '%@' was not of expected type NSDate", defaultName);
    return date;
}

@end

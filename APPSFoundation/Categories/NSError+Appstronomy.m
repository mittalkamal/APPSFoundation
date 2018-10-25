//
//  NSError+Appstronomy.m
//
//  Created by Sohail Ahmed on 7/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "NSError+Appstronomy.h"

@implementation NSError (Appstronomy)

#pragma mark - Logging

- (NSString *)apps_detailsForLogging; {
    return [self apps_detailsForLoggingAtLevel:0];
}


- (NSString *)apps_detailsForLoggingAtLevel:(NSUInteger)level {
    NSMutableString *logString = [NSMutableString string];
	
    [logString appendFormat:@"NSError[%2lu]: %@ => %@", (unsigned long)level, self, [self userInfo]];
    
	if ([[self userInfo] isKindOfClass:[NSDictionary class]]) {
		NSDictionary *dict = [self userInfo];
		
        for (NSObject *key in [dict allKeys]) {
			id info = [dict objectForKey:key];
			if ([info isKindOfClass:[NSError class]]) {
				NSError *childError = info;
				[logString appendString:[childError apps_detailsForLoggingAtLevel:(level+1)]];
			}
            else {
				[logString appendFormat:@"NSError[%2lu]: %@", (unsigned long)(level+1), self];
			}
		}
	} else {
		[logString appendFormat:@"%@", [self userInfo]];
	}
    
    return logString;
}


@end

//
//  NSDictionary+Appstronomy.m
//  AppstronomyStandardKit
//
//  Created by Sohail Ahmed on 3/12/16.
//  Copyright © 2016 Appstronomy, LLC. All rights reserved.
//

#import "NSDictionary+Appstronomy.h"

@implementation NSDictionary (Appstronomy)

- (NSString *)apps_asPrettyPrintedJSONString;
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];
    
    return jsonString;
}

@end

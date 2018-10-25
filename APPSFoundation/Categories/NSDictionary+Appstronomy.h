//
//  NSDictionary+Appstronomy.h
//  AppstronomyStandardKit
//
//  Created by Sohail Ahmed on 3/12/16.
//  Copyright © 2016 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Appstronomy)

/**
 Creates a representation of this dictionary as a pretty-printed JSON string.
 
 @return Pretty printed JSON text.
 */
- (NSString *)apps_asPrettyPrintedJSONString;


@end

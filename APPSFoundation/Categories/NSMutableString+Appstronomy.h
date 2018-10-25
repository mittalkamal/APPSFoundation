//
//  NSMutableString+Appstronomy.h
//  APPSFoundation
//
//  Created by Ken Grigsby on 4/29/17.
//  Copyright © 2017 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableString (Appstronomy)

/**
 This is a convenience method for [NSMutableString replaceOccurrencesOfString:withString:options:range:]
 with 0 for options and the entire string for the search range.
 */
- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement;

@end

NS_ASSUME_NONNULL_END

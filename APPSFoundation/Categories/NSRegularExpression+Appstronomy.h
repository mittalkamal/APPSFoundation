//
//  NSRegularExpression+Appstronomy.h
//  Appstronomy Standard Kit
//
//  Created by Sohail Ahmed on 5/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This entire class is about conveniences to regular expression matching.
 */
@interface NSRegularExpression (Appstronomy)

#pragma mark - Match Retrieval: Class Methods

/**
 Convience method. It's not going to be efficient, you can't specify options or inspect any errors, but it's
 really quick short hand for the 80% of the time you need it.
 */
+ (NSString *)apps_matchInTestString:(NSString *)testString atIndex:(NSUInteger)index usingRegexPattern:(NSString *)pattern;


/**
 Convenience cover method where we specify useNilForNoMatch:NO.
 */
+ (NSString *)apps_matchInTestString:(NSString *)testString atIndex:(NSUInteger)index usingRegexPattern:(NSString *)pattern useNilForNoMatch:(BOOL)useNilForNoMatch;



#pragma mark - Match Retrieval: Instance Methods

/**
 Convenience. Instead of calling "-rangeAtIndex:" on the regular expression
 and then "-substringWithRange:" on the original string with that range, this
 method combines it all together.
 
 In the case a match index has no match (where the range is {NSNotFound, 0}),
 we return an empty string @"" unless "useNilForNoMatch" is passed in as YES.
 */
- (NSString *)apps_matchInTestString:(NSString *)testString atIndex:(NSUInteger)index;


/**
 Convenience for longer version of method, where we assume using an empty string for no match
 instead of the option to use nil.
 */
- (NSString *)apps_matchInTestString:(NSString *)testString atIndex:(NSUInteger)index useNilForNoMatch:(BOOL)useNilForNoMatch;


@end

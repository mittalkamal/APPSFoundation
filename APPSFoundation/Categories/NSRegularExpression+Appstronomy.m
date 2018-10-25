//
//  NSRegularExpression+Appstronomy.m
//  Appstronomy Standard Kit
//
//  Created by Sohail Ahmed on 5/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "NSRegularExpression+Appstronomy.h"

@implementation NSRegularExpression (Appstronomy)

#pragma mark - Match Retrieval: Class Methods

/**
 Convience method. It's not going to be efficient, you can't specify options or inspect any errors, but it's
 really quick short hand for the 80% of the time you need it.
 */
+ (NSString *)apps_matchInTestString:(NSString *)testString
                           atIndex:(NSUInteger)index
                 usingRegexPattern:(NSString *)pattern
                  useNilForNoMatch:(BOOL)useNilForNoMatch
{
	NSError *error = NULL;
	NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:pattern
																		   options:NSRegularExpressionCaseInsensitive
																			 error:&error];
	
	return [regex apps_matchInTestString:testString atIndex:index useNilForNoMatch:useNilForNoMatch];
}


/**
 Convenience cover method where we specify useNilForNoMatch:NO.
 */
+ (NSString *)apps_matchInTestString:(NSString *)testString
                           atIndex:(NSUInteger)index
                 usingRegexPattern:(NSString *)pattern
{
	return [self apps_matchInTestString:testString atIndex:index usingRegexPattern:pattern useNilForNoMatch:NO];
}



#pragma mark - Match Retrieval: Instance Methods

/**
 Convenience - instead of calling "-rangeAtIndex:" on the regular expression
 and then "-substringWithRange:" on the original string with that range, this
 method combines it all together.
 
 In the case a match index has no match (where the range is {NSNotFound, 0}),
 we return an empty string @"" unless "useNilForNoMatch" is passed in as YES.
 */
- (NSString *)apps_matchInTestString:(NSString *)testString
                           atIndex:(NSUInteger)index
                  useNilForNoMatch:(BOOL)useNilForNoMatch
{
    NSTextCheckingResult *match = [self firstMatchInString:testString
                                                   options:0
                                                     range:NSMakeRange(0, [testString length])];
    
    NSString *matchedSegmentString = nil;
    
    if (match) {
        NSRange matchRange = [match rangeAtIndex:index];
        
        // Did the match item at the given index match any content?
        if (!NSEqualRanges(matchRange, NSMakeRange(NSNotFound, 0))) {
            // YES: We have content for this match item.
            matchedSegmentString = [testString substringWithRange:matchRange];
        }
        // NO: We don't have match content for this item. Should we return an empty string instead of nil?
        else if (!useNilForNoMatch) {
            // YES: Return an empty string:
            matchedSegmentString = @"";
        }
    }
    
    return matchedSegmentString;
}


/**
 Convenience for longer version of method, where we assume using an empty string for no match
 instead of the option to use nil.
 */
- (NSString *)apps_matchInTestString:(NSString *)testString
                           atIndex:(NSUInteger)index
{
    return [self apps_matchInTestString:testString atIndex:index useNilForNoMatch:NO];
}

@end

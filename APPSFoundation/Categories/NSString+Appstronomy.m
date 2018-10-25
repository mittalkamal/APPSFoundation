//
//  NSString+Appstronomy.m
//
//  Created by Sohail Ahmed on 5/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "NSString+Appstronomy.h"

static NSString * const kNSStringAppstronomyThreadDictionary_apps_asNumberKey = @"com.appstronomy.threadDictionary.asNumberKey";


@implementation NSString (Appstronomy)


#pragma mark - Modified Variations

- (NSString *)apps_stringByTrimmingWhitespaceBothEnds;
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}


- (NSString *)apps_stringByStrippingWhitespaceEverywhere;
{
    NSArray *words = [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *strippedString = [words componentsJoinedByString:@""];

    return strippedString;
}


- (NSString *)apps_stringByCapitalizingFirstLetter
{
    NSString *requestedValue = self;
    
    if (!self || self.length == 0) {
        // Do nothing
    }
    else if (self.length == 1) {
        requestedValue = self.capitalizedString;
    }
    else {
        requestedValue = [NSString stringWithFormat:@"%@%@", [[self substringToIndex:1] uppercaseString], [self substringFromIndex:1]];
    }
    
    return requestedValue;
}


+ (NSString *)apps_stringWithFormat:(NSString *)format arguments:(NSArray *)arguments
{
    if ( arguments.count > 10 ) {
        @throw [NSException exceptionWithName:NSRangeException reason:@"Maximum of 10 arguments allowed" userInfo:@{@"collection": arguments}];
    }
    
    // We'll add 10 useless 'X' elements so that when we de-reference, we never go out of bounds.
    NSArray *a = [arguments arrayByAddingObjectsFromArray:@[@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X",@"X"]];
    return [NSString stringWithFormat:format, a[0], a[1], a[2], a[3], a[4], a[5], a[6], a[7], a[8], a[9], a[10] ];
}


#pragma mark - Inquiries

- (BOOL) apps_caseInsensitiveIsEqualToString: (NSString *) otherString {
    return [self caseInsensitiveCompare:otherString]==NSOrderedSame;
}

- (BOOL)apps_contains:(NSString *)otherString options:(NSStringCompareOptions)options;
{
    NSRange range = [self rangeOfString:otherString options:options];
    return (range.location != NSNotFound);
}


- (BOOL)apps_containsCharacters:(NSString *)characters;
{
    return [self apps_containsAny:[NSCharacterSet characterSetWithCharactersInString:characters]];
}


- (BOOL)apps_containsAny:(NSCharacterSet *)characterSet;
{
    NSRange range = [self rangeOfCharacterFromSet:characterSet];
    
    return (range.location != NSNotFound);
}


- (BOOL)apps_hasContent;
{
    return ([self apps_stringByTrimmingWhitespaceBothEnds].length > 0);
}


- (BOOL)apps_isBlank;
{
    return ([@"" isEqualToString:[self apps_stringByTrimmingWhitespaceBothEnds]]);
}


+ (BOOL)apps_isBlank:(NSString *)testString;
{
    if (!testString) return YES;
    
    return [testString apps_isBlank];
}


+ (BOOL)apps_string:(NSString *)a isEqualToString:(NSString *)b
{
    return ((a.length == 0) && (b.length == 0)) || [a isEqualToString:b];
}


- (BOOL)apps_isNumeric;
{
    return ([self apps_asNumber] != nil);
}


- (NSNumber *)apps_asNumber;
{
    NSMutableDictionary *threadDictionary = [NSThread currentThread].threadDictionary;
    NSNumberFormatter *numberFormatter = threadDictionary[kNSStringAppstronomyThreadDictionary_apps_asNumberKey];
    if (!numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        threadDictionary[kNSStringAppstronomyThreadDictionary_apps_asNumberKey] = numberFormatter;
    }
    
    // Adapted from Dave DeLong's answer in the comments of: http://stackoverflow.com/a/1320411/535054
    NSNumber *retrievedNumber = [numberFormatter numberFromString:self];

    return retrievedNumber;
}


@end

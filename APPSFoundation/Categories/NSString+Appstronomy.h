//
//  NSString+Appstronomy.h
//
//  Created by Sohail Ahmed on 5/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Appstronomy)

#pragma mark - Modified Variations

/**
 Trims whitespace and newline characters from the beginning and end of this string.
 This String instance is not modified; a variation is created and returned.
 
 @return A new String object that reflects the modifications.
 */
- (NSString *)apps_stringByTrimmingWhitespaceBothEnds;



/**
 Trims whitespace and newline characters from everywhere in this string.
 This String instance is not modified; a variation is created and returned.

 @return A new String object that reflects the modifications.
*/
- (NSString *)apps_stringByStrippingWhitespaceEverywhere;


/**
 Only capitalizes the first letter. All other characters in the String are left alone,
 regardless of their case.
 
 @return A new string instance, with the first letter capitalized.
 */
- (NSString *)apps_stringByCapitalizingFirstLetter;


/**
 Builds a new string with a format string and an array of arguments to the format string.
 This only supports up to 10 arguments, however. Credit and discussion here:
 
 http://stackoverflow.com/a/1061750/535054
 
 @param format    The normal format string you would give to NSString's -stringWithFormat: method.
 @param arguments An array of arguments that should match the format string you give.
 
 @return A newly instantiated string.
 */
+ (NSString *)apps_stringWithFormat:(NSString *)format arguments:(NSArray *)arguments;



#pragma mark - Inquiries

/** 
 Method to allow case insensitive equality checking in clean if pattern while abstracting comparison
 to NSOrderedSame which does not evaluate as true by itself.
 
  @param otherString The string to test against for equality
  @return YES if the otherString is equal to us modulo case
 */
- (BOOL) apps_caseInsensitiveIsEqualToString: (NSString *) otherString;

/**
 Checks to see if this instance contains the provided other string, using the provided
 comparison options.
 
 @param otherString The string to search for within our contents.
 @param options Comparison options, such as case sensitivity, regex based, etc. Bitwise OR these options.
 @return YES if the otherString can be found within our contents.
 */
- (BOOL)apps_contains:(NSString *)otherString options:(NSStringCompareOptions)options;


/**
 Checks to see if this instance contains any characters that can be found inside the provided string.
 
 @param characters A String that is used to house individual characters (order doesn't matter) that we will look for.
 @return YES if any character in the provided characters String is contained by us.
 */
- (BOOL)apps_containsCharacters:(NSString *)characters;


/**
 Checks to see if this instance contains any characters from the provided character set.
 
 @param characterSet Contains characters, any one of which contained within us, triggers a match.
 @return YES if any character in the provided characters set is contained by us.
 */
- (BOOL)apps_containsAny:(NSCharacterSet *)characterSet;


/**
 Advises on whether this string has content.

 The reverse of apps_isBlank.
 
 @return YES if we are of greater than zero length, once stripped of whitespace and newlines.
 */
- (BOOL)apps_hasContent;


/**
 Advises on whether this string is empty.
 
 @return YES if we are of zero length, once stripped of whitespace and newlines.
 */
- (BOOL)apps_isBlank;


/**
 Class method variation of "-isBlank" that takes a test String.
 
 @param testString The string to evaluate.
 @return YES if the provided test string is of zero length, once stripped of whitespace and newlines.
 */
+ (BOOL)apps_isBlank:(NSString *)testString;


/**
 Returns YES if strings a and b both have zero length or [a isEqualToString:b]
 
 @param a first string
 @param b second string
 
 @return YES if strings a and b both have zero length or [a isEqualToString:b]
 */
+ (BOOL)apps_string:(NSString *)a isEqualToString:(NSString *)b;


/**
 Determines if the value we hold in this String, is actually numeric.
 
 @return YES, if the number is numeric.
 */
- (BOOL)apps_isNumeric;


/**
 Returns the NSNumber representation of the value we hold in this String.
 Callers are strongly advised to first call @p apps_isNumeric, before 
 they attempt to retrieve our numeric value.
 
 @return The NSNumber representation of the value we hold.
 */
- (NSNumber *)apps_asNumber;




@end

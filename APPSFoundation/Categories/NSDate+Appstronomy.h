//
//  NSDate+Appstronomy.h
//
//  Created by Sohail Ahmed on 2014-09-07.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - Time Conveniences

static const NSTimeInterval kAPPSTimeInterval_Second = 1;
static const NSTimeInterval kAPPSTimeInterval_Minute = 60 * kAPPSTimeInterval_Second;
static const NSTimeInterval kAPPSTimeInterval_Hour   = 60 * kAPPSTimeInterval_Minute;


@interface NSDate (Appstronomy)

#pragma mark - Date Comparisons

/**
 Tells you if we come before the other date passed in for comparison.
 
 @param otherDate The other date that we are comparing with ourselves.
 
 @return YES if we are earlier than the other date passed in.
 */
- (BOOL)apps_isEarlierThan:(NSDate *)otherDate;


/**
 Tells you if we come after the other date passed in for comparison.
 
 @param otherDate The other date that we are comparing with ourselves.
 
 @return YES if we are later than the other date passed in.
 */
- (BOOL)apps_isLaterThan:(NSDate *)otherDate;


/**
 Tells you if we are within a given number of seconds of the other date provided,
 regardless of before/after ordering.
 
 @param toleranceInSeconds How many seconds grace we can be different.
 @param otherDate          The other date we will compare ourselves to.
 
 @return YES if we are within tolerance.
 */
- (BOOL)apps_isWithinTolerance:(NSTimeInterval)toleranceInSeconds ofOtherDate:(NSDate *)otherDate;



#pragma mark - Date Math

/**
 Computes the absolute number of days intervening the two provided dates.
 Uses calendar identifier @c NSCalendarIdentifierGregorian as the basis to
 provide answers. Note that only whole, completed days are returned in the 
 count. Partial days are not rounded, even if "close".
 
 @param startDate The first date to be compared.
 @param endDate   The second date to be compared.
 
 @return An integer value of whole days.
 */
+ (NSUInteger)apps_numberOfWholeDaysBetween:(NSDate *)startDate and:(NSDate *)endDate;


/**
 A cover method for +apps_numberOfWholeDaysBetween:and: that uses this instance
 as one of the date endpoints.
 
 @param otherDate The date to be compared to this one.
 
 @return The intervening number of whole days between us and the other date provided.
 */
- (NSUInteger)apps_numberOfWholeDaysBetweenUsAndDate:(NSDate *)otherDate;



#pragma mark - Conveniently Formatted

/**
 Creates a string using the current date, using the NSDateFormatterShortStyle style,
 which in western locales like the United States, will typically generate a string like so:
 "4/22/14".
 
 @return A short form date.
 */
+ (NSString *)apps_rightNowAsStringShortStyle;


/**
 Creates a string using the current date, using the NSDateFormatterLongStyle style,
 which in western locales like the United States, will typically generate a string like so:
 "January 15, 2016".
 
 @return A long form date.
 */
+ (NSString *)apps_rightNowAsStringLongStyle;


/**
 Creates a string using the current time, similar to NSDateFormatterShortStyle style,
 except that we use path safe date component separators. This is not meant to reflect locale
 specifics, but rather, be handy for debugging or creating parts of filenames.
 
 A typical result will look like: "2016.11.25" (conducive to alphanumeric sortable ordering).
 
 @return A short form date that we can append in filenames.
 */
+ (NSString *)apps_rightNowAsStringPathSafeShortStyle;


- (NSString *)apps_dateStringWithLongStyle;

- (NSString *)apps_dateTimeStringWithLongStyle;

@end

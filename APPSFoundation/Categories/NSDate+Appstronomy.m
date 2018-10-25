//
//  NSDate+Appstronomy.m
//
//  Created by Sohail Ahmed on 2014-09-07.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "NSDate+Appstronomy.h"

@implementation NSDate (Appstronomy)

#pragma mark - Date Comparisons

- (BOOL)apps_isEarlierThan:(NSDate *)otherDate
{
    return ([self compare:otherDate] == NSOrderedAscending);
}


- (BOOL)apps_isLaterThan:(NSDate *)otherDate
{
    // Just leverage the is-earlier method, swapping operands:
    return [otherDate apps_isEarlierThan:self];
}


- (BOOL)apps_isWithinTolerance:(NSTimeInterval)toleranceInSeconds ofOtherDate:(NSDate *)otherDate;
{
    NSTimeInterval absoluteDifferenceInSeconds = fabs([self timeIntervalSinceDate:otherDate]);
    
    return absoluteDifferenceInSeconds < toleranceInSeconds;
}


#pragma mark - Date Math

+ (NSUInteger)apps_numberOfWholeDaysBetween:(NSDate *)startDate and:(NSDate *)endDate;
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:NSCalendarWrapComponents];

    return [components day];
}


- (NSUInteger)apps_numberOfWholeDaysBetweenUsAndDate:(NSDate *)otherDate;
{
    return [NSDate apps_numberOfWholeDaysBetween:self and:otherDate];
}




#pragma mark - Conveniently Formatted

+ (NSString *)apps_rightNowAsStringShortStyle;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return dateString;
}


+ (NSString *)apps_rightNowAsStringLongStyle;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return dateString;
}


+ (NSString *)apps_rightNowAsStringPathSafeShortStyle;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy.MM.dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    
    return dateString;
}


- (NSString *)apps_dateStringWithLongStyle;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    NSString *dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}


- (NSString *)apps_dateTimeStringWithLongStyle;
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterLongStyle];
    [dateFormatter setTimeStyle:NSDateFormatterLongStyle];
    NSString *dateString = [dateFormatter stringFromDate:self];
    
    return dateString;
}


@end

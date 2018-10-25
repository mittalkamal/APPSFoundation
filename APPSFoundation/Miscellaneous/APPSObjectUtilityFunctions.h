//
//  APPSObjectUtilityFunctions.h
//
//  Created by Sohail Ahmed on 7/9/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This 'class' is strictly a container for utility C functions. Since these functions will often call out to Objective-C,
 they couldn't be placed in a regular .c file.
 
 This class should be pulled into the precompiled header, and as such, callers need not reference this class directly at
 all. All that is needed, is to straight up, call the C function you wish, from those included in this header file.
 */
@interface APPSObjectUtilityFunctions : NSObject

#pragma mark - Inquiries: Class Cluster

/**
 Since NSDate is the abstract superclass of a class cluster, we often don't get instances at runtime that claim to be
 of class 'NSDate'. Often times, we'll see one of its private subclasses, which report themselves with names like '__NSDate'.
 
 Often, we just care that it is a date object we can use the NSDate API on. We'll often fail using a check like:
 
 [candidateDateObject isKindOfClass:[NSDate class]])
 
 which you would think would pass! So, the next best approach is to see if the object responds to a selector that
 is something rather unique to the NSDate API. That's what we do here.
 
 @param candidateDateObject The object we want to test, to see if it is an NSDate or some kind of NSDate like object.
 @return YES if the provided object is effectively an NSDate (or some private internal class in the NSDate class cluster).
 */
BOOL apps_isDateObject(id candidateDateObject);


@end

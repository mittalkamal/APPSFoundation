//
//  NSError+Appstronomy.h
//
//  Created by Sohail Ahmed on 7/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Provides utilities, primarily for helping log details of an NSError.
 Inspired by Jeremy Przasnyski's NSError+ICLog.m category from 6/28/09.
 */
@interface NSError (Appstronomy)

#pragma mark - Logging

/**
 Expands out the parts of this NSError, starting at a default level of zero,
 with child errors being tagged with progressively higher levels. Levels of 
 logging refers to how NSErrors can be nested, and it is helpful to actually
 print out all of the various levels, instead of just the top level error.
 
 @return A string that contains all of the nested NSError information in this error.
 */
- (NSString *)apps_detailsForLogging;


/**
 Expands out the parts of this NSError, recursively calling this method on
 child NSErrors, so that the amalgamated string returned is suitable for logging.
 
 We pull out logging information for the specified nesting depth. That is, the recursion
 makes its way to the deepest level of error, and then returns the amalgamated error descriptions
 each time this method call is unwound off the recursion stack.
 
 @param level The depth of nested NSError info we should retrieve.
 @return The NSError details nested in this NSError at the specified level, and deeper.
 */
- (NSString *)apps_detailsForLoggingAtLevel:(NSUInteger)level;

@end

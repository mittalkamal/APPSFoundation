//
//  NSMutableArray+Appstronomy.h
//  Appstronomy Standard Kit
//
//  Created by Sohail Ahmed on 2014-11-13.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Appstronomy)

/**
 Replaces (only) the first match, if indeed a match was found.
 
 @param objectToReplace The object we'll find and remove.
 @param object The object we'll insert at the very spot we found the 'objectToReplace'.
 
 @return The index of where the replacement occurred.
 */
- (NSUInteger)apps_replaceObject:(id)objectToReplace withObject:(id)object;

@end

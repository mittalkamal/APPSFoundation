//
//  NSMutableArray+Appstronomy.m
//  Appstronomy Standard Kit
//
//  Created by Sohail Ahmed on 2014-11-13.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "NSMutableArray+Appstronomy.h"

@implementation NSMutableArray (Appstronomy)

- (NSUInteger)apps_replaceObject:(id)objectToReplace withObject:(id)object;
{
    NSUInteger index = [self indexOfObject:objectToReplace];
    if (index != NSNotFound) {
        [self replaceObjectAtIndex:index withObject:object];
    }
    return index;
}

@end

//
//  NSArray+Appstronomy.m
//  Appstronomy Standard Kit
//
//  Created by Tim Capes on 2014-12-07.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "NSArray+Appstronomy.h"

@implementation NSArray (Appstronomy)

- (NSArray *)apps_mapObjectsUsingBlock:(id (^)(id object, NSUInteger idx))block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    [self enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        [result addObject:block(object, index)];
    }];

    return result;
}

- (NSArray *)apps_map:(id (^)(id obj))block
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[self count]];
    
    for (id obj in self) {
        [result addObject:block(obj)];
    }

    return result;
}

- (NSArray *)apps_filter:(BOOL (^)(id obj))block
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (id obj in self) {
        if (block(obj)) {
            [result addObject:obj];
        }
    }
    
    return result;
}

- (BOOL)apps_containsString:(NSString *)otherString
{
    for (NSString *iteratedElement in self) {
        if ([iteratedElement isEqualToString:otherString]) {
            return YES;
        }
    }

    return NO;
}


- (BOOL)apps_isEmpty;
{
    return ([self count] == 0);
}


- (BOOL)apps_hasContent;
{
    return ([self count] > 0);
}



// CREDIT: http://stackoverflow.com/a/5821015/535054
- (NSArray *)apps_sortedArray;
{
    if ([self count] == 0) { return self; } // Nothing to sort
    
    NSArray *sortedArray = self;
    
    if ([[self firstObject] respondsToSelector:@selector(compare:)]) {
        sortedArray = [self sortedArrayUsingSelector:@selector(compare:)];
    }
    else {
        NSLog(@"Could not sort this array; we don't contain objects that respond to the selector 'compare:'.");
    }
    
    return sortedArray;
}


- (NSArray *)apps_distinctArrayUsingKeyPath:(NSString *)keyPath
{
    NSMutableArray *distinctObjects = [NSMutableArray arrayWithCapacity:self.count];
    NSMutableSet *distinctKeys = [NSMutableSet setWithCapacity:self.count];
    
    for (id obj in self) {
        
        id distinctKey = [obj valueForKeyPath:keyPath];
        if (![distinctKeys containsObject:distinctKey]) {
            [distinctObjects addObject:obj];
            [distinctKeys addObject:distinctKey];
        }
    }
    
    return [distinctObjects copy];
}


- (NSString *)apps_asPrettyPrintedJSONString;
{
    NSError *error = nil;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                        options:NSJSONWritingPrettyPrinted
                                                          error:&error];
    
    NSString *jsonString = [[NSString alloc] initWithData:jsonData
                                                 encoding:NSUTF8StringEncoding];

    return jsonString;
}


@end

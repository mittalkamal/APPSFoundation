//
//  NSArray+Appstronomy.h
//
//  Created by Tim Capes on 2014-12-07.
//

#import <Foundation/Foundation.h>

@interface NSArray (Appstronomy)

- (NSArray *)apps_mapObjectsUsingBlock:(id (^)(id obj, NSUInteger idx))block;


/**
 Iterates over each element of the receiver calling the block with each element and
 returning the results.
 
 @param block block to be executed given each element of the receiver
 
 @return array of the return values of executing the block for each element of the receiver
 */
- (NSArray *)apps_map:(id (^)(id obj))block;


/**
 Iterates over each element of the receiver calling the block with each element and returns
 the elements whose block returned true.
 
 @param block block to be executed given each element of the receiver
 
 @return array of receiver elements for whom block returned true
 */
- (NSArray *)apps_filter:(BOOL (^)(id obj))block;

- (BOOL)apps_containsString:(NSString *)otherString;


/**
 Advises if there are currently zero elements in this array.
 
 @return YES if there are no elements contained in this array.
 */
- (BOOL)apps_isEmpty;


/**
 Advises if there are any items present in this array.
 
 @return YES if one or more items are present.
 */
- (BOOL)apps_hasContent;


/**
 For simple arrays, where the contents can be sorted using the default @c compare: method,
 such as NSString objects, use this method to get a new array, sorted using the selector @c compare:.
 
 @return A new, sorted array.
 */
- (NSArray *)apps_sortedArray;


/**
 Returns an array where each object has a distinct value for the given key path.
 The returned array maintains the original ordering.
 
 @param keyPath key path applied to array objects to determine uniqueness
 
 @return array of unique objects based on keyPath
 */
- (NSArray *)apps_distinctArrayUsingKeyPath:(NSString *)keyPath;


/**
 Creates a representation of this array as a pretty-printed JSON string.
 
 @return Pretty printed JSON text.
 */
- (NSString *)apps_asPrettyPrintedJSONString;

@end
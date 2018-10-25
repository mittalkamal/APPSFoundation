//
//  APPSImports+Macros.h
//
//  Created by Sohail Ahmed on 5/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#ifndef Appstronomy_Standard_Kit_APPSImports_Macros_h
#define Appstronomy_Standard_Kit_APPSImports_Macros_h

#import "APPSAssertHandler.h"


#pragma mark - RGB Colors

/**
 These macros let you create instances of UIColor using RGB values, most commonly identified with web programming and design.
 CREDIT: http://foobarpig.com/iphone/uicolor-cheatsheet-color-list-conversion-from-and-to-rgb-values.html
 */
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define UIColorFromRGBWithAlpha(rgbValue, alphaValue) [UIColor colorWithRed:((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0 green:((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0 blue:((CGFloat)(rgbValue & 0xFF))/255.0 alpha:alphaValue]


#pragma mark - Formatting

#define boolAsString(theCondition) (theCondition ? @"YES" : @"NO")
#define boolAsTrueFalseString(theCondition) (theCondition ? @"true" : @"false")



#pragma mark - Suppress Compiler Warnings

// CREDIT: http://www.faqoverflow.com/stackoverflow/7017281.html
#define SuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)


#pragma mark - Device Detection

#define isIPad   (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define isIPhone (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define isIPhone6 (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone && CGRectGetWidth([UIScreen mainScreen].nativeBounds) == 750.0)


#pragma mark - Object Comparison

/**
 Returns return true if both objA and objB are nil OR [objA isEqual:objB]
 */
#define areBothNilOrIsEqual(objA, objB)    ( (!objA && !objB) || [objA isEqual:objB] )


#pragma mark - KVO Context

#define APPSKVOContext(ctx) static void * ctx = &ctx

#endif

#pragma mark - Build Configuration Detection





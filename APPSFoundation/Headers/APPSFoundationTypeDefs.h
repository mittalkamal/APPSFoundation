//
//  APPSFoundationTypeDefs.h
//
//  Created by Sohail Ahmed on 5/7/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

@import Foundation;

#ifndef Appstronomy_Standard_Kit_APPSTypeDefs_h
#define Appstronomy_Standard_Kit_APPSTypeDefs_h

#pragma mark - Generic Callbacks

typedef void (^APPSCallbackBlock)();
typedef void (^APPSCallbackWithSingleIntBlock)(NSUInteger value);
typedef void (^APPSCallbackWithSingleStringBlock)(NSString *value);
typedef void (^APPSCallbackWithSingleObjectBlock)(id object);
typedef void (^APPSCallbackWithDoubleObjectBlock)(id object1, id object2);
typedef void (^APPSCallbackWithStatusAndErrorBlock)(BOOL success, NSError *error);
typedef void (^APPSCallbackWithStatusBlock)(BOOL success);

#endif

//
//  APPSObjectUtilityFunctions.m
//
//  Created by Sohail Ahmed on 7/9/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "APPSObjectUtilityFunctions.h"

@implementation APPSObjectUtilityFunctions

#pragma mark - Inquiries: Class Cluster

BOOL apps_isDateObject(id candidateDateObject) {
    return [candidateDateObject respondsToSelector:@selector(timeIntervalSinceReferenceDate)];
}

@end

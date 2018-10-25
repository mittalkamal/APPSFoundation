//
//  APPSBaseUnit.m
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/28/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

#import "APPSBaseUnit.h"
#import "APPSUnit_Private.h"

@implementation APPSBaseUnit
{
    NSString *_unitString;
}

- (instancetype)initWithUnitString:(NSString *)unitString multiplier:(NSDecimalNumber *)multiplier
{
    self = [super initWithMultiplier:multiplier];
    if (self) {
        _unitString = [unitString copy];
    }
    return self;
}

- (NSString *)unitString
{
    return _unitString;
}


@end

@implementation APPSMassUnit @end
@implementation APPSLengthUnit @end
@implementation APPSVolumeUnit @end
@implementation APPSTimeUnit @end

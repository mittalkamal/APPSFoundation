//
//  APPSCompoundUnit.m
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/28/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

#import "APPSCompoundUnit.h"
#import "APPSUnit_Private.h"


@implementation APPSCompoundUnit
{
    NSString *_unitString;
    APPSUnit *_dividendUnit;
    APPSUnit *_divisorUnit;
}

- (instancetype)initWithUnitString:(NSString *)unitString dividendUnit:(APPSUnit *)dividendUnit divisorUnit:(APPSUnit *)divisorUnit
{
    NSDecimalNumber *multiplier = [[dividendUnit _multiplier] decimalNumberByDividingBy:[divisorUnit _multiplier]];
    
    self = [self initWithMultiplier:multiplier];
    if (self) {
        _unitString = [unitString copy];
        _dividendUnit = dividendUnit;
        _divisorUnit = divisorUnit;
    }
    
    return self;
}

- (BOOL)isNull
{
    // Return true if classes are the same
    return [_dividendUnit isMemberOfClass:_divisorUnit.class];
}

- (NSString *)unitString
{
    return _unitString;
}

- (BOOL)_isCompatibleWithUnit:(APPSUnit *)unit
{
    BOOL isCompatible = NO;
    
    if ([unit isKindOfClass:self.class]) {
        APPSCompoundUnit *compoundUnit = (APPSCompoundUnit *)unit;
        isCompatible = ([_divisorUnit _isCompatibleWithUnit:compoundUnit->_divisorUnit] &&
                        [_dividendUnit _isCompatibleWithUnit:compoundUnit->_dividendUnit]);
    }
    
    return isCompatible;
}

@end

//
//  APPSUnit_Private
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/23/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

#import "APPSUnit.h"

@interface APPSUnit ()

- (instancetype)initWithMultiplier:(NSDecimalNumber *)multiplier;
- (BOOL)_isCompatibleWithUnit:(APPSUnit *)unit;
- (double)_valueByConvertingValue:(double)value toUnit:(APPSUnit *)toUnit;
- (NSDecimalNumber *)_valueInBaseUnitByConvertngValue:(double)value;
- (NSDecimalNumber *)_multiplier;

@end

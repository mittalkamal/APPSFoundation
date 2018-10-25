//
//  APPSQuantity.m
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/19/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

#import "APPSQuantity.h"
#import "APPSUnit.h"
#import "APPSUnit_Private.h"

@interface APPSQuantity ()
@property (nonatomic) double value;
@property (nonatomic, strong) APPSUnit *unit;
@end

@implementation APPSQuantity

+ (instancetype)quantityWithUnit:(APPSUnit *)unit doubleValue:(double)value;
{
    return [[APPSQuantity alloc] initWithUnit:unit doubleValue:value];
}


- (instancetype)initWithUnit:(APPSUnit *)unit doubleValue:(double)value
{
    self = [super init];
    if (self) {
        self.value = value;
        self.unit = unit;
    }
    
    return self;
}


- (id)copyWithZone:(nullable NSZone *)zone;
{
    // This is a value class
    return self;
}


- (BOOL)isCompatibleWithUnit:(APPSUnit *)unit
{
    return [self.unit _isCompatibleWithUnit:unit];
}


- (double)doubleValueForUnit:(APPSUnit *)unit
{
    return  [self.unit _valueByConvertingValue:self.value toUnit:unit];
}


- (NSComparisonResult)compare:(APPSQuantity *)quantity
{
    if (![self.unit _isCompatibleWithUnit:quantity.unit]) {
        [NSException raise:NSInvalidArgumentException format: @"Quantity 1 %@ has incompatible unit", quantity.unit.unitString];
        return NSOrderedSame;
    }
    
    NSDecimalNumber *leftNumber = [self.unit _valueInBaseUnitByConvertngValue:self.value];
    NSDecimalNumber *rightNumber = [quantity.unit _valueInBaseUnitByConvertngValue:quantity.value];
    return [leftNumber compare:rightNumber];
}


- (NSString *)description
{
    static NSNumberFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [NSNumberFormatter new];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
    });
    
    return [NSString stringWithFormat:@"%@ %@", [formatter stringFromNumber:@(self.value)], self.unit.unitString];
}


@end

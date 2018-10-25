//
//  APPSQuantity.h
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/19/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class APPSUnit;


@interface APPSQuantity : NSObject <NSCopying>

- (instancetype)init NS_UNAVAILABLE;

/**
 Instantiates and returns a new quantity object.
 
 @param unit  The units for the given value. This defines the set of compatible units. For example, if you create a quantity with a meter unit, it is compatible with any other length units.
 @param value The value of this quantity, measured using the unit parameter.
 
 @return A newly instantiated quantity instance.
 */
+ (instancetype)quantityWithUnit:(APPSUnit *)unit doubleValue:(double)value;


/**
 Returns a boolean value indicating whether the quantity is compatible with the provided unit.
 
 Individual units are compatible if they measure the same feature. For example, all length units are compatible. All mass units are also compatible. However, a length unit is not compatible with a mass unit.
 
 Complex units are compatible if the equation defining the units are compatible. Specifically, it must use the same operators, and the operands must be compatible. For example, meters per second and miles per hour are compatible. The left operands are both length units, the right operands are both time units and they all use a division operator.

 @param unit The target unit.
 
 @return Yes if the quantity is compatible; otherwise, NO.
 */
- (BOOL)isCompatibleWithUnit:(APPSUnit *)unit;


/**
 Returns the quantity’s value in the provided unit.
 
 This method converts the quantity’s value to the desired units. You do not need to know the quantity’s original units. You can request the value in whatever units you want, as long as they are compatible with the quantity. This lets each application (or each locale) work with its preferred units.
 
 In most cases, you know which units are compatible with a given quantity from context. 
 
 If you need to programatically check wether a particular unit is compatible with a particular quantity, call the quantity’s isCompatibleWithUnit: method.
 
 @param unit The target unit. If the quantity is not compatible with this unit, it throws an exception (NSInvalidArgumentException).
 
 @return The quantity’s value in the provided units.
 */
- (double)doubleValueForUnit:(APPSUnit *)unit;


/**
 Compares two values after converting them to the same units.
 
 Returns whether the quantity argument is less than, equal to, or greater than the current quantity. This method automatically converts the quantities into the same units before comparing the values. You just need to ensure that the quantities have compatible units.
 
 In most cases, the compatible units are clear from context. To see the unit types associated with different quantity sample types, see the type identifiers in HealthKit Constants Reference.
 
 If you need to programatically check whether a particular unit is compatible with a particular quantity, call the quantity’s isCompatibleWithUnit: method.
 
 @param quantity The quantity to compare. This method throws an exception if the quantities do not have compatible units (NSInvalidArgumentException).
 
 @return NSOrderedDescending if the parameter is less than the receiver. NSOrderedAscending if the parameter is greater than the receiver. NSOrderedSame if the quantities are equal.
 */
- (NSComparisonResult)compare:(APPSQuantity *)quantity;

@end

NS_ASSUME_NONNULL_END
//
//  APPSUnit.h
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/19/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface APPSUnit : NSObject <NSCopying>

/// Returns a unique string representation for the unit that could be used with +unitFromString:
@property (readonly, strong) NSString *unitString;

- (instancetype)init NS_UNAVAILABLE;

/**
 Returns the unit instance described by the provided string.
 
 @param string A string representation of the unit. For example, count, kg, or m/s^2.
 
 @return The unit object described by the string. If the string does not represent a valid unit, this method throws an exception (NSInvalidArgumentException).
 */
+ (instancetype)unitFromString:(NSString *)string;

// Unit strings are composed of the following units:
// International System of Units (SI) units:
// g                (grams)   [Mass]
// m                (meters)  [Length]
// L,l              (liters)  [Volume]
// s                (seconds) [Time]
// mol<molar mass>  (moles)   [Mass] <molar mass> is the number of grams per mole. For example, mol<180.1558>

// SI units can be prefixed as follows:
// da   (deca-)   = 10                 d    (deci-)   = 1/10
// h    (hecto-)  = 100                c    (centi-)  = 1/100
// k    (kilo-)   = 1000               m    (milli-)  = 1/1000
// M    (mega-)   = 10^6               mc   (micro-)  = 10^-6
// G    (giga-)   = 10^9               n    (nano-)   = 10^-9
// T    (tera-)   = 10^12              p    (pico-)   = 10^-12


// Non-SI units:
//
// [Mass]
// oz   (ounces)  = 28.3495 g
// lb   (pounds)  = 453.592 g
// st   (stones)  = 6350.0 g
//
// [Length]
// in   (inches)  = 0.0254 m
// ft   (feet)    = 0.3048 m
// mi   (miles)   = 1609.34 m
//
// [Volume]
// fl_oz_us  (US customary fluid ounces)= 0.0295735295625 L
// fl_oz_imp (Imperial fluid ounces)    = 0.028413075 L
// pt_us     (US customary pint)        = 0.473176473 L
// pt_imp    (Imperial pint)            = 0.5682815 L
// cup_us    (US customary cup)         = 0.2365882365 L
// cup_imp   (Imperial cup)             = 0.28413075 L
//
// [Time]
// min  (minutes) = 60 s
// hr   (hours)   = 3600 s
// d    (days)    = 86400 s
//

// !!!
// COMBINING UNITS ARE ONLY IMPLEMENTED FOR A SINGLE DIVISION, NO MULTIPLICATION, OR POWERS
// !!!

// THE FOLLOWING COMMENT WAS COPIED FROM HEALTHKIT AND REPRESENTS FUTURE FUNCTIONALITY OF APPUNIT
// Units can be combined using multiplication (. or *) and division (/), and raised to integral powers (^).
// For simplicity, only a single '/' is allowed in a unit string, and multiplication is evaluated first.
// So "kg/m.s^2" is equivalent to "kg/(m.s^2)" and "kg.m^-1.s^-2".

/**
 Returns a Boolean value indicating whether the unit is null.
 
 Null units occur only when you create compound units in which all the units cancel out. For example, if you tried to create a unit by dividing deciliters by liters (dL/L), you would end up with a null unit.
 
 @return YES if the unit is null; otherwise, NO.
 */
- (BOOL)isNull;

@end

typedef NS_ENUM(NSInteger, APPSMetricPrefix) {
    APPSMetricPrefixNone = 0, //10^0
    
    APPSMetricPrefixPico,     //10^-12
    APPSMetricPrefixNano,     //10^-9
    APPSMetricPrefixMicro,    //10^-6
    APPSMetricPrefixMilli,    //10^-3
    APPSMetricPrefixCenti,    //10^-2
    APPSMetricPrefixDeci,     //10^-1
    APPSMetricPrefixDeca,     //10^1
    APPSMetricPrefixHecto,    //10^2
    APPSMetricPrefixKilo,     //10^3
    APPSMetricPrefixMega,     //10^6
    APPSMetricPrefixGiga,     //10^9
    APPSMetricPrefixTera      //10^12
};

/* Mass Units */
@interface APPSUnit (Mass)
+ (instancetype)gramUnitWithMetricPrefix:(APPSMetricPrefix)prefix;       // g
+ (instancetype)gramUnit;   // g
+ (instancetype)ounceUnit;  // oz
+ (instancetype)poundUnit;  // lb
+ (instancetype)moleUnitWithMetricPrefix:(APPSMetricPrefix)prefix molarMass:(double)gramsPerMole;   // mol<double>
+ (instancetype)moleUnitWithMolarMass:(double)gramsPerMole; // mol<double>

+ (NSArray *)availableMassUnitStrings;
+ (NSArray *)availableMolorMassUnitStringsForMolarMass:(double)gramsPerMole;

@end

/* Length Units */
@interface APPSUnit (Length)
+ (instancetype)meterUnitWithMetricPrefix:(APPSMetricPrefix)prefix;      // m
+ (instancetype)meterUnit;  // m
+ (instancetype)inchUnit;   // in
+ (instancetype)footUnit;   // ft
+ (instancetype)yardUnit;   // yd
+ (instancetype)mileUnit;   // mi

+ (NSArray *)availableLengthUnitStrings;
@end


/* Volume Units */
@interface APPSUnit (Volume)
+ (instancetype)literUnitWithMetricPrefix:(APPSMetricPrefix)prefix;      // L
+ (instancetype)literUnit;              // L
+ (instancetype)fluidOunceUSUnit;       // fl_oz_us
+ (instancetype)fluidOunceImperialUnit; // fl_oz_imp
+ (instancetype)pintUSUnit;             // pt_us
+ (instancetype)pintImperialUnit;       // pt_imp
+ (instancetype)cupUSUnit;              // cup_us
+ (instancetype)cupImperialUnit;        // cup_imp

+ (NSArray *)availableVolumeUnitStrings;
@end


/* Time Units */
@interface APPSUnit (Time)
+ (instancetype)secondUnitWithMetricPrefix:(APPSMetricPrefix)prefix;     // s
+ (instancetype)secondUnit; // s
+ (instancetype)minuteUnit; // min
+ (instancetype)hourUnit;   // hr
+ (instancetype)dayUnit;    // d

+ (NSArray *)availableTimeUnitStrings;
@end

@interface APPSUnit (Math)
//- (APPSUnit *)unitMultipliedByUnit:(APPSUnit *)unit;
- (APPSUnit *)unitDividedByUnit:(APPSUnit *)unit;
//- (APPSUnit *)unitRaisedToPower:(NSInteger)power;
//- (APPSUnit *)reciprocalUnit;
@end

/* Mole Constants */
#define APPSUnitMolarMassBloodGlucose (180.15588000005408)

NS_ASSUME_NONNULL_END

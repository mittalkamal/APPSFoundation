//
//  APPSQuantityTest.m
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/19/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

@import APPSFoundation;

#import "APPSBaseTestCase.h"

@interface APPSQuantityTest : APPSBaseTestCase

@end

@implementation APPSQuantityTest


/**
 Verify copy returns same instance as the original
 */
- (void)testCopy
{
    APPSQuantity *oneMeter = [APPSQuantity quantityWithUnit:[APPSUnit meterUnit] doubleValue:1.0];
    APPSQuantity *oneMeterCopy = [oneMeter copy];
    XCTAssertEqual(oneMeter, oneMeterCopy);
}


/**
 Verify isCompatibleWithUnit returns false for incompatible units
 */
- (void)testIncompatibleUnits
{
    APPSUnit *metersPerSecond = [APPSUnit unitFromString:@"m/s"];
    
    APPSQuantity *oneGram = [APPSQuantity quantityWithUnit:[APPSUnit gramUnit] doubleValue:1.0];
    APPSQuantity *oneMeter = [APPSQuantity quantityWithUnit:[APPSUnit meterUnit] doubleValue:1.0];
    APPSQuantity *oneSecond = [APPSQuantity quantityWithUnit:[APPSUnit secondUnit] doubleValue:1.0];
    APPSQuantity *oneLiter = [APPSQuantity quantityWithUnit:[APPSUnit literUnit] doubleValue:1.0];
    APPSQuantity *oneMeterPerSecond = [APPSQuantity quantityWithUnit:metersPerSecond doubleValue:1.0];
    
    XCTAssertFalse([oneGram isCompatibleWithUnit:[APPSUnit meterUnit]]);     // compare mass and length
    XCTAssertFalse([oneGram isCompatibleWithUnit:[APPSUnit secondUnit]]);    // compare mass and time
    XCTAssertFalse([oneGram isCompatibleWithUnit:[APPSUnit literUnit]]);     // compare mass and volume
    XCTAssertFalse([oneGram isCompatibleWithUnit:metersPerSecond]);          // compare mass and metersPerSecond
    
    XCTAssertFalse([oneMeter isCompatibleWithUnit:[APPSUnit gramUnit]]);     // compare length and mass
    XCTAssertFalse([oneMeter isCompatibleWithUnit:[APPSUnit secondUnit]]);   // compare length and time
    XCTAssertFalse([oneMeter isCompatibleWithUnit:[APPSUnit literUnit]]);    // compare length and volume
    XCTAssertFalse([oneMeter isCompatibleWithUnit:metersPerSecond]);         // compare length and metersPerSecond
    
    XCTAssertFalse([oneSecond isCompatibleWithUnit:[APPSUnit meterUnit]]);   // compare time and length
    XCTAssertFalse([oneSecond isCompatibleWithUnit:[APPSUnit gramUnit]]);    // compare time and mass
    XCTAssertFalse([oneSecond isCompatibleWithUnit:[APPSUnit literUnit]]);   // compare time and volume
    XCTAssertFalse([oneSecond isCompatibleWithUnit:metersPerSecond]);        // compare time and metersPerSecond
    
    XCTAssertFalse([oneLiter isCompatibleWithUnit:[APPSUnit meterUnit]]);    // compare volume and length
    XCTAssertFalse([oneLiter isCompatibleWithUnit:[APPSUnit secondUnit]]);   // compare volume and time
    XCTAssertFalse([oneLiter isCompatibleWithUnit:[APPSUnit gramUnit]]);     // compare volume and mass
    XCTAssertFalse([oneLiter isCompatibleWithUnit:metersPerSecond]);         // compare volume and metersPerSecond

    XCTAssertFalse([oneMeterPerSecond isCompatibleWithUnit:[APPSUnit meterUnit]]);     // compare metersPerSecond and length
    XCTAssertFalse([oneMeterPerSecond isCompatibleWithUnit:[APPSUnit secondUnit]]);    // compare metersPerSecond and time
    XCTAssertFalse([oneMeterPerSecond isCompatibleWithUnit:[APPSUnit literUnit]]);     // compare metersPerSecond and volume
    XCTAssertFalse([oneMeterPerSecond isCompatibleWithUnit:[APPSUnit gramUnit]]);      // compare metersPerSecond and mass
    
}


/**
 Verify doubleValueForUnit throws an exception when using incompatible units
 */
- (void)testDoubleValueForUnitThrowsExceptionWithIncompatibleUnits
{
    APPSUnit *metersPerSecond = [APPSUnit unitFromString:@"m/s"];

    APPSQuantity *oneGram = [APPSQuantity quantityWithUnit:[APPSUnit gramUnit] doubleValue:1.0];
    APPSQuantity *oneMeter = [APPSQuantity quantityWithUnit:[APPSUnit meterUnit] doubleValue:1.0];
    APPSQuantity *oneSecond = [APPSQuantity quantityWithUnit:[APPSUnit secondUnit] doubleValue:1.0];
    APPSQuantity *oneLiter = [APPSQuantity quantityWithUnit:[APPSUnit literUnit] doubleValue:1.0];
    APPSQuantity *oneMeterPerSecond = [APPSQuantity quantityWithUnit:metersPerSecond doubleValue:1.0];
    
    XCTAssertThrows([oneGram doubleValueForUnit:[APPSUnit meterUnit]]);     // compare mass and length
    XCTAssertThrows([oneGram doubleValueForUnit:[APPSUnit secondUnit]]);    // compare mass and time
    XCTAssertThrows([oneGram doubleValueForUnit:[APPSUnit literUnit]]);     // compare mass and volume
    XCTAssertThrows([oneGram doubleValueForUnit:metersPerSecond]);          // compare mass and metersPerSecond
    
    XCTAssertThrows([oneMeter doubleValueForUnit:[APPSUnit gramUnit]]);     // compare length and mass
    XCTAssertThrows([oneMeter doubleValueForUnit:[APPSUnit secondUnit]]);   // compare length and time
    XCTAssertThrows([oneMeter doubleValueForUnit:[APPSUnit literUnit]]);    // compare length and volume
    XCTAssertThrows([oneMeter doubleValueForUnit:metersPerSecond]);         // compare length and metersPerSecond
    
    XCTAssertThrows([oneSecond doubleValueForUnit:[APPSUnit meterUnit]]);   // compare time and length
    XCTAssertThrows([oneSecond doubleValueForUnit:[APPSUnit gramUnit]]);    // compare time and mass
    XCTAssertThrows([oneSecond doubleValueForUnit:[APPSUnit literUnit]]);   // compare time and volume
    XCTAssertThrows([oneSecond doubleValueForUnit:metersPerSecond]);        // compare time and metersPerSecond
    
    XCTAssertThrows([oneLiter doubleValueForUnit:[APPSUnit meterUnit]]);    // compare volume and length
    XCTAssertThrows([oneLiter doubleValueForUnit:[APPSUnit secondUnit]]);   // compare volume and time
    XCTAssertThrows([oneLiter doubleValueForUnit:[APPSUnit gramUnit]]);     // compare volume and mass
    XCTAssertThrows([oneLiter doubleValueForUnit:metersPerSecond]);         // compare volume and metersPerSecond
    
    XCTAssertThrows([oneMeterPerSecond doubleValueForUnit:[APPSUnit meterUnit]]);     // compare metersPerSecond and length
    XCTAssertThrows([oneMeterPerSecond doubleValueForUnit:[APPSUnit secondUnit]]);    // compare metersPerSecond and time
    XCTAssertThrows([oneMeterPerSecond doubleValueForUnit:[APPSUnit literUnit]]);     // compare metersPerSecond and volume
    XCTAssertThrows([oneMeterPerSecond doubleValueForUnit:[APPSUnit gramUnit]]);      // compare metersPerSecond and mass
}


/**
 Verify compare throws an exception when using incompatible units
 */
- (void)testCompareThrowsExceptionWithIncompatibleUnits
{
    APPSUnit *metersPerSecond = [APPSUnit unitFromString:@"m/s"];

    APPSQuantity *oneGram = [APPSQuantity quantityWithUnit:[APPSUnit gramUnit] doubleValue:1.0];
    APPSQuantity *oneMeter = [APPSQuantity quantityWithUnit:[APPSUnit meterUnit] doubleValue:1.0];
    APPSQuantity *oneSecond = [APPSQuantity quantityWithUnit:[APPSUnit secondUnit] doubleValue:1.0];
    APPSQuantity *oneLiter = [APPSQuantity quantityWithUnit:[APPSUnit literUnit] doubleValue:1.0];
    APPSQuantity *oneMeterPerSecond = [APPSQuantity quantityWithUnit:metersPerSecond doubleValue:1.0];
    
    XCTAssertThrows([oneGram compare:oneMeter]);            // compare mass and length
    XCTAssertThrows([oneGram compare:oneSecond]);           // compare mass and time
    XCTAssertThrows([oneGram compare:oneLiter]);            // compare mass and volume
    XCTAssertThrows([oneGram compare:oneMeterPerSecond]);   // compare mass and oneMeterPerSecond
    
    XCTAssertThrows([oneMeter compare:oneGram]);            // compare length and mass
    XCTAssertThrows([oneMeter compare:oneSecond]);          // compare length and time
    XCTAssertThrows([oneMeter compare:oneLiter]);           // compare length and volume
    XCTAssertThrows([oneMeter compare:oneMeterPerSecond]);  // compare length and oneMeterPerSecond
   
    XCTAssertThrows([oneSecond compare:oneMeter]);          // compare time and length
    XCTAssertThrows([oneSecond compare:oneGram]);           // compare time and mass
    XCTAssertThrows([oneSecond compare:oneLiter]);          // compare time and volume
    XCTAssertThrows([oneSecond compare:oneMeterPerSecond]); // compare time and oneMeterPerSecond
    
    XCTAssertThrows([oneLiter compare:oneMeter]);           // compare volume and length
    XCTAssertThrows([oneLiter compare:oneSecond]);          // compare volume and time
    XCTAssertThrows([oneLiter compare:oneGram]);            // compare volume and mass
    XCTAssertThrows([oneLiter compare:oneMeterPerSecond]);  // compare volume and oneMeterPerSecond
    
    XCTAssertThrows([oneMeterPerSecond compare:oneMeter]);  // compare metersPerSecond and length
    XCTAssertThrows([oneMeterPerSecond compare:oneSecond]); // compare metersPerSecond and time
    XCTAssertThrows([oneMeterPerSecond compare:oneGram]);   // compare metersPerSecond and mass
    XCTAssertThrows([oneMeterPerSecond compare:oneLiter]);  // compare metersPerSecond and volume
}


- (void)testIsCompatibleWithUnit_Mass
{
    APPSQuantity *oneGram = [APPSQuantity quantityWithUnit:[APPSUnit gramUnit] doubleValue:1.0];
    for (NSString *unitString in [APPSUnit availableMassUnitStrings]) {
        XCTAssertTrue([oneGram isCompatibleWithUnit:[APPSUnit unitFromString:unitString]], "Test failed for %@", unitString);
    }
}


- (void)testIsCompatibleWithUnit_Length
{
    APPSQuantity *oneMeter = [APPSQuantity quantityWithUnit:[APPSUnit meterUnit] doubleValue:1.0];
    for (NSString *unitString in [APPSUnit availableLengthUnitStrings]) {
        XCTAssertTrue([oneMeter isCompatibleWithUnit:[APPSUnit unitFromString:unitString]], "Test failed for %@", unitString);
    }
}


- (void)testIsCompatibleWithUnit_Time
{
    APPSQuantity *oneSecond = [APPSQuantity quantityWithUnit:[APPSUnit secondUnit] doubleValue:1.0];
    for (NSString *unitString in [APPSUnit availableTimeUnitStrings]) {
        XCTAssertTrue([oneSecond isCompatibleWithUnit:[APPSUnit unitFromString:unitString]], "Test failed for %@", unitString);
    }
}


- (void)testIsCompatibleWithUnit_Volume
{
    APPSQuantity *oneLiter = [APPSQuantity quantityWithUnit:[APPSUnit literUnit] doubleValue:1.0];
    for (NSString *unitString in [APPSUnit availableVolumeUnitStrings]) {
        XCTAssertTrue([oneLiter isCompatibleWithUnit:[APPSUnit unitFromString:unitString]], "Test failed for %@", unitString);
    }
}


/**
 Iterate through all combinations of length/time units and verify they are compatible with m/s.
 */
- (void)testIsCompatibleWithUnit_MetersPerSecond
{
    APPSUnit *metersPerSecond = [APPSUnit unitFromString:@"m/s"];
    APPSQuantity *oneMeterPerSecond = [APPSQuantity quantityWithUnit:metersPerSecond doubleValue:1.0];
    
    for (NSString *lengthUnitString in [APPSUnit availableLengthUnitStrings]) {
        for (NSString *timeUnitString in [APPSUnit availableTimeUnitStrings]) {
            NSString *unitString = [NSString stringWithFormat:@"%@/%@", lengthUnitString, timeUnitString];
            XCTAssertTrue([oneMeterPerSecond isCompatibleWithUnit:[APPSUnit unitFromString:unitString]], "Test failed for %@", unitString);
        }
    }
}



#pragma mark - Length Conversions

- (void)testDoubleValueForUnit_inchToCentimeter
{
    APPSUnit *fromUnit = [APPSUnit inchUnit];
    APPSUnit *toUnit = [APPSUnit meterUnitWithMetricPrefix:APPSMetricPrefixCenti];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = 2.54;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.01);
}


- (void)testDoubleValueWithUnit_centimeterToInch
{
    APPSUnit *fromUnit = [APPSUnit meterUnitWithMetricPrefix:APPSMetricPrefixCenti];
    APPSUnit *toUnit = [APPSUnit inchUnit];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = 0.3937;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.0001);
}



#pragma mark - Mass Conversions

- (void)testDoubleValueForUnit_poundToKilogram
{
    APPSUnit *fromUnit = [APPSUnit poundUnit];
    APPSUnit *toUnit = [APPSUnit gramUnitWithMetricPrefix:APPSMetricPrefixKilo];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = .4536;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.0001);
}


- (void)testDoubleValueWithUnit_kilogramToPound
{
    APPSUnit *fromUnit = [APPSUnit gramUnitWithMetricPrefix:APPSMetricPrefixKilo];
    APPSUnit *toUnit = [APPSUnit poundUnit];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = 2.2046;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.0001);
}


- (void)testDoubleValueWithUnit_molarMassToGram
{
    APPSUnit *fromUnit = [APPSUnit moleUnitWithMolarMass:APPSUnitMolarMassBloodGlucose];
    APPSUnit *toUnit = [APPSUnit gramUnit];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = APPSUnitMolarMassBloodGlucose;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.000001);
}


- (void)testDoubleValueWithUnit_gramToMolarMass
{
    APPSUnit *fromUnit = [APPSUnit gramUnit];
    APPSUnit *toUnit = [APPSUnit moleUnitWithMolarMass:APPSUnitMolarMassBloodGlucose];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = 1./APPSUnitMolarMassBloodGlucose;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.000001);
}



#pragma mark - Time Conversions

- (void)testDoubleValueForUnit_secondsToDays
{
    APPSUnit *fromUnit = [APPSUnit secondUnit];
    APPSUnit *toUnit = [APPSUnit dayUnit];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = 0.00001157;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.00000001);
}


- (void)testDoubleValueWithUnit_daysToSeconds
{
    APPSUnit *fromUnit = [APPSUnit dayUnit];
    APPSUnit *toUnit = [APPSUnit secondUnit];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = 86400;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.0001);
}



#pragma mark - Volume Conversions

- (void)testDoubleValueForUnit_litersToOuncesUS
{
    APPSUnit *fromUnit = [APPSUnit literUnit];
    APPSUnit *toUnit = [APPSUnit fluidOunceUSUnit];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = 33.814;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.001);
}


- (void)testDoubleValueWithUnit_ouncesUSToLiters
{
    APPSUnit *fromUnit = [APPSUnit fluidOunceUSUnit];
    APPSUnit *toUnit = [APPSUnit literUnit];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = 0.02957;
    
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.0001);
}



#pragma mark - Volume Conversions

- (void)testDoubleValueForUnit_kmPerHourToFeetPerSecond
{
    APPSUnit *fromUnit = [APPSUnit unitFromString:@"km/hr"];
    APPSUnit *toUnit = [APPSUnit unitFromString:@"ft/s"];
    APPSQuantity *oneFromUnit = [APPSQuantity quantityWithUnit:fromUnit doubleValue:1.0];
    double expectResult = 0.91134441528142318;
    XCTAssertEqualWithAccuracy([oneFromUnit doubleValueForUnit:toUnit], expectResult, 0.0000001);
}


#pragma mark - Descriptions

- (void)testDescription
{
    APPSQuantity *quantity = [APPSQuantity quantityWithUnit:[APPSUnit inchUnit] doubleValue:1.0];
    NSString *expectResult = @"1 in";
    
    XCTAssertEqualObjects(quantity.description, expectResult);
}


- (void)testDescription2
{
    APPSQuantity *quantity = [APPSQuantity quantityWithUnit:[APPSUnit inchUnit] doubleValue:2.54];
    NSString *expectResult = @"2.54 in";
    
    XCTAssertEqualObjects(quantity.description, expectResult);
}



#pragma mark - Compare

- (void)testCompare_Length
{
    APPSQuantity *littleQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"cm"] doubleValue:1.0];
    APPSQuantity *bigQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"km"] doubleValue:1.0];
    
    XCTAssertEqual([littleQuantity compare:bigQuantity], NSOrderedAscending);
    XCTAssertEqual([bigQuantity compare:littleQuantity], NSOrderedDescending);
    XCTAssertEqual([littleQuantity compare:littleQuantity], NSOrderedSame);
}


- (void)testCompare_Mass
{
    APPSQuantity *littleQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"g"] doubleValue:1.0];
    APPSQuantity *bigQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"kg"] doubleValue:1.0];
    
    XCTAssertEqual([littleQuantity compare:bigQuantity], NSOrderedAscending);
    XCTAssertEqual([bigQuantity compare:littleQuantity], NSOrderedDescending);
    XCTAssertEqual([littleQuantity compare:littleQuantity], NSOrderedSame);
}


- (void)testCompare_Time
{
    APPSQuantity *littleQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"s"] doubleValue:1.0];
    APPSQuantity *bigQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"ks"] doubleValue:1.0];
    
    XCTAssertEqual([littleQuantity compare:bigQuantity], NSOrderedAscending);
    XCTAssertEqual([bigQuantity compare:littleQuantity], NSOrderedDescending);
    XCTAssertEqual([littleQuantity compare:littleQuantity], NSOrderedSame);
}


- (void)testCompare_Volume
{
    APPSQuantity *littleQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"L"] doubleValue:1.0];
    APPSQuantity *bigQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"kL"] doubleValue:1.0];
    
    XCTAssertEqual([littleQuantity compare:bigQuantity], NSOrderedAscending);
    XCTAssertEqual([bigQuantity compare:littleQuantity], NSOrderedDescending);
    XCTAssertEqual([littleQuantity compare:littleQuantity], NSOrderedSame);
}


- (void)testCompare_MetersPerSecond
{
    APPSQuantity *littleQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"m/s"] doubleValue:1.0];
    APPSQuantity *bigQuantity = [APPSQuantity quantityWithUnit:[APPSUnit unitFromString:@"km/s"] doubleValue:1.0];
    
    XCTAssertEqual([littleQuantity compare:bigQuantity], NSOrderedAscending);
    XCTAssertEqual([bigQuantity compare:littleQuantity], NSOrderedDescending);
    XCTAssertEqual([littleQuantity compare:littleQuantity], NSOrderedSame);
}

@end

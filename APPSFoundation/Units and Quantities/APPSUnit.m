//
//  APPSUnit.m
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/19/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

#import "APPSUnit.h"
#import "NSArray+Appstronomy.h"
#import "APPSBaseUnit.h"
#import "APPSCompoundUnit.h"

static NSMutableDictionary *unitsCache;
static const NSString * APPSUnitClassNameKey = @"className";
static const NSString * APPSUnitMultiplierKey = @"multiplier";


@implementation APPSUnit
{
    NSDecimalNumber *_multiplier;
}


+ (void)initialize
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        unitsCache = [NSMutableDictionary new];
    });
}


+ (instancetype)unitFromString:(NSString *)inputString
{
    static NSMutableDictionary *constructors;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSString *massUnitClassString = NSStringFromClass(APPSMassUnit.class);
        NSString *lengthUnitClassString = NSStringFromClass(APPSLengthUnit.class);
        NSString *volumeUnitClassString = NSStringFromClass(APPSVolumeUnit.class);
        NSString *timeUnitClassString = NSStringFromClass(APPSTimeUnit.class);
        
        constructors = [NSMutableDictionary dictionaryWithDictionary:
                        @{
                          // Mass; 1 [unit] = [multiplier] grams
                          @"oz":  @{ APPSUnitClassNameKey: massUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:283495 exponent:-4 isNegative:NO] },
                          @"lb":  @{ APPSUnitClassNameKey: massUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:45359237 exponent:-5 isNegative:NO] },
                          
                          
                          // Length; 1 [unit] = [multiplier] meters
                          @"in":  @{ APPSUnitClassNameKey: lengthUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:254 exponent:-4 isNegative:NO] },
                          @"ft":  @{ APPSUnitClassNameKey: lengthUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:3048 exponent:-4 isNegative:NO] },
                          @"yd":  @{ APPSUnitClassNameKey: lengthUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:9144 exponent:-4 isNegative:NO] },
                          @"mi":  @{ APPSUnitClassNameKey: lengthUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:1609344 exponent:-3 isNegative:NO] },
                          
                          
                          // Volume; 1 [unit] = [multiplier] liters
                          @"fl_oz_us":   @{ APPSUnitClassNameKey: volumeUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:295735295625 exponent:-13 isNegative:NO] },
                          @"fl_oz_imp":  @{ APPSUnitClassNameKey: volumeUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:28413075 exponent:-9 isNegative:NO] },
                          @"pt_us":      @{ APPSUnitClassNameKey: volumeUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:473176473 exponent:-9 isNegative:NO] },
                          @"pt_imp":     @{ APPSUnitClassNameKey: volumeUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:5682815 exponent:-7 isNegative:NO] },
                          @"cup_us":     @{ APPSUnitClassNameKey: volumeUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:2365882365 exponent:-10 isNegative:NO] },
                          @"cup_imp":    @{ APPSUnitClassNameKey: volumeUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:28413075 exponent:-8 isNegative:NO] },
                          
                          
                          // Time; 1 [unit] = [multiplier] seconds
                          @"min": @{ APPSUnitClassNameKey: timeUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:60 exponent:0 isNegative:NO] },
                          @"hr":  @{ APPSUnitClassNameKey: timeUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:3600 exponent:0 isNegative:NO] },
                          @"d":   @{ APPSUnitClassNameKey: timeUnitClassString, APPSUnitMultiplierKey: [NSDecimalNumber decimalNumberWithMantissa:86400 exponent:0 isNegative:NO] },
                          }];
        
        // Add SI unit constructors
        [constructors addEntriesFromDictionary:[self constructorForRootUnit:@"g" className:massUnitClassString]];
        [constructors addEntriesFromDictionary:[self constructorForRootUnit:@"mol" className:massUnitClassString]];
        [constructors addEntriesFromDictionary:[self constructorForRootUnit:@"m" className:lengthUnitClassString]];
        [constructors addEntriesFromDictionary:[self constructorForRootUnit:@"L" className:volumeUnitClassString]];
        [constructors addEntriesFromDictionary:[self constructorForRootUnit:@"l" className:volumeUnitClassString]];
        [constructors addEntriesFromDictionary:[self constructorForRootUnit:@"s" className:timeUnitClassString]];
    });
    
    if (inputString.length == 0) {
        [NSException raise:NSInvalidArgumentException format: @"Unable to parse factorization string %@", inputString];
        return nil;
    }
    
    // Check cache for unit
    APPSUnit *unit = unitsCache[inputString];
    if (unit) { return unit; }
    
    // Check for division "/"
    NSRange divisorRange = [inputString rangeOfString:@"/"];
    if (divisorRange.length > 0) {
        NSString *dividend = [inputString substringToIndex:divisorRange.location];
        NSString *divisor = [inputString substringFromIndex:NSMaxRange(divisorRange)];
        APPSUnit *dividendUnit = [APPSUnit unitFromString:dividend];
        APPSUnit *divisorUnit = [APPSUnit unitFromString:divisor];
        
        unit = [[APPSCompoundUnit alloc] initWithUnitString:inputString dividendUnit:dividendUnit divisorUnit:divisorUnit];
    }
    else {
        // Parse input string for optional molar mass
        NSString *prefixAndRoot;
        NSDecimalNumber *molarMass;
        if (![self parseInputString:inputString outPrefixAndRoot:&prefixAndRoot outMolarMass:&molarMass]) {
            [NSException raise:NSInvalidArgumentException format: @"Unable to parse factorization string %@", inputString];
            return nil;
        }
        
        NSDictionary *constructor = constructors[prefixAndRoot];
        // Throw exception if prefixAndRoot is unknown
        if (!constructor) {
            [NSException raise:NSInvalidArgumentException format: @"Unable to parse factorization string %@", inputString];
            return nil;
        }
        
        // Create unit
        Class class = NSClassFromString(constructor[APPSUnitClassNameKey]);
        NSDecimalNumber *multiplier = constructor[APPSUnitMultiplierKey];
        
        if ([prefixAndRoot hasSuffix:@"mol"] && molarMass) {
            multiplier = [molarMass decimalNumberByMultiplyingBy:multiplier];
        }
        
        unit = [[class alloc] initWithUnitString:inputString multiplier:multiplier];
    }
    
    // Cache unit
    unitsCache[inputString] = unit;
    
    return unit;
}


+ (NSDictionary *)constructorForRootUnit:(NSString *)root className:(NSString *)className
{
    NSArray *metricPrefixes = [self metricPrefixes];
    NSMutableDictionary *prefixesDictionary = [NSMutableDictionary dictionaryWithCapacity:metricPrefixes.count];
    
    for (NSString *metricPrefix in metricPrefixes) {
        NSString *unitString = [metricPrefix stringByAppendingString:root];
        prefixesDictionary[unitString] = @{ APPSUnitClassNameKey: className, APPSUnitMultiplierKey: [self _multiplierForPrefixString:metricPrefix] };
    }
    return prefixesDictionary;
}


+ (BOOL)parseInputString:(NSString *)inputString outPrefixAndRoot:(NSString **)outPrefixAndRoot outMolarMass:(NSDecimalNumber **)outMolarMass
{
    NSScanner *scanner = [NSScanner scannerWithString:inputString];
    NSDecimal gramsPerMole;
    BOOL success = YES;
    
    // scan for molarMass
    if ([scanner scanUpToString:@"<" intoString:outPrefixAndRoot] && !scanner.isAtEnd) {
        if ([scanner scanString:@"<" intoString:NULL] &&
            [scanner scanDecimal:&gramsPerMole] &&
            [scanner scanString:@">" intoString:NULL]) {
            if (outMolarMass) {  *outMolarMass = [NSDecimalNumber decimalNumberWithDecimal:gramsPerMole]; }
        }
        else {
            // Error
            success = NO;
        }
    } else {
        if (outPrefixAndRoot) {
            *outPrefixAndRoot = inputString;
        }
    }
    
    return success;
}


- (instancetype)initWithMultiplier:(NSDecimalNumber *)multiplier
{
    self = [super init];
    if (self) {
        _multiplier = multiplier;
    }
    return self;
}


- (id)copyWithZone:(nullable NSZone *)zone;
{
    // This is a value class
    return self;
}


- (BOOL)isNull
{
    return NO;
}


- (BOOL)_isCompatibleWithUnit:(APPSUnit *)unit
{
    return [self isMemberOfClass:unit.class];
}


- (double)_valueByConvertingValue:(double)value toUnit:(APPSUnit *)toUnit
{
    if (![self _isCompatibleWithUnit:toUnit]) {
        [NSException raise:NSInvalidArgumentException format: @"Attempt to convert incompatible units: %@, %@", self.unitString, toUnit.unitString];
        return 0;
    }
    
    if (self == toUnit) { return value; }
    
    NSDecimalNumber *valueInBaseUnit = [self _valueInBaseUnitByConvertngValue:value];
    NSDecimalNumber *valueInTargetUnit = [valueInBaseUnit decimalNumberByDividingBy:toUnit->_multiplier];
    
    return valueInTargetUnit.doubleValue;
}


- (NSDecimalNumber *)_valueInBaseUnitByConvertngValue:(double)value
{
    NSDecimalNumber *source = (NSDecimalNumber*)[NSDecimalNumber numberWithDouble:value];
    NSDecimalNumber *valueInBaseUnit = [source decimalNumberByMultiplyingBy:_multiplier];
    return valueInBaseUnit;
}


- (NSDecimalNumber *)_multiplier
{
    return _multiplier;
}


- (NSString *)description
{
    return self.unitString;
}


+ (NSArray *)metricPrefixes
{
    NSArray *prefixes = @[@"p", @"n", @"mc", @"m", @"c", @"d", @"", @"da", @"h", @"k", @"M", @"G", @"T"];
    return prefixes;
}


+ (NSArray *)metricUnitStringsForUnit:(NSString *)unit
{
    return [self.metricPrefixes apps_map:^NSString*(NSString *prefix) {
        return [prefix stringByAppendingString:unit];
    }];
}


+ (NSString *)_prefixStringForMetricPrefix:(APPSMetricPrefix)prefix
{
    switch (prefix) {
        case APPSMetricPrefixNone:  return @"";
        case APPSMetricPrefixPico:  return @"p";
        case APPSMetricPrefixNano:  return @"n";
        case APPSMetricPrefixMicro: return @"mc";
        case APPSMetricPrefixMilli: return @"m";
        case APPSMetricPrefixCenti: return @"c";
        case APPSMetricPrefixDeci:  return @"d";
        case APPSMetricPrefixDeca:  return @"da";
        case APPSMetricPrefixHecto: return @"h";
        case APPSMetricPrefixKilo:  return @"k";
        case APPSMetricPrefixMega:  return @"M";
        case APPSMetricPrefixGiga:  return @"G";
        case APPSMetricPrefixTera:  return @"T";
            
        default: return nil;
    }
}


+ (NSDecimalNumber *)_multiplierForPrefixString:(NSString *)prefix
{
    static NSDictionary *metricMultiplers;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        metricMultiplers = @{
                             @"p":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:-12 isNegative:NO],
                             @"n":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:-9 isNegative:NO],
                             @"mc": [NSDecimalNumber decimalNumberWithMantissa:1 exponent:-6 isNegative:NO],
                             @"m":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:-3 isNegative:NO],
                             @"c":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:-2 isNegative:NO],
                             @"d":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:-1 isNegative:NO],
                             @"":   [NSDecimalNumber one],
                             @"da": [NSDecimalNumber decimalNumberWithMantissa:1 exponent:1 isNegative:NO],
                             @"h":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:2 isNegative:NO],
                             @"k":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:3 isNegative:NO],
                             @"M":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:6 isNegative:NO],
                             @"G":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:9 isNegative:NO],
                             @"T":  [NSDecimalNumber decimalNumberWithMantissa:1 exponent:12 isNegative:NO],
                             };
    });
    
    return metricMultiplers[prefix];
}


@end



#pragma mark - Mass

@implementation APPSUnit (Mass)

+ (instancetype)gramUnitWithMetricPrefix:(APPSMetricPrefix)prefix
{
    NSString *prefixString = [self _prefixStringForMetricPrefix:prefix];
    return [self unitFromString:[prefixString stringByAppendingString:@"g"]];
}


+ (instancetype)gramUnit
{
    return [self unitFromString:@"g"];
}


+ (instancetype)ounceUnit
{
    return [self unitFromString:@"oz"];
}


+ (instancetype)poundUnit
{
    return [self unitFromString:@"lb"];
}


+ (instancetype)moleUnitWithMetricPrefix:(APPSMetricPrefix)prefix molarMass:(double)gramsPerMole;   // mol<double>
{
    NSString *prefixString = [self _prefixStringForMetricPrefix:prefix];
    NSString *unitString = [NSString stringWithFormat:@"%@mol<%@>", prefixString, @(gramsPerMole).stringValue];
    return [self unitFromString:unitString];
}


+ (instancetype)moleUnitWithMolarMass:(double)gramsPerMole; // mol<double>
{
    return [self moleUnitWithMetricPrefix:APPSMetricPrefixNone molarMass:gramsPerMole];
}


+ (NSArray *)availableMassUnitStrings
{
    NSArray *unitStrings = [self metricUnitStringsForUnit:@"g"];
    unitStrings = [unitStrings arrayByAddingObjectsFromArray:@[@"oz", @"lb"]];
    return unitStrings;
}


+ (NSArray *)availableMolorMassUnitStringsForMolarMass:(double)gramsPerMole
{
    NSArray *unitStrings = [self metricUnitStringsForUnit:@"mol"];
    unitStrings = [unitStrings apps_map:^NSString *(NSString *obj) {
        return [NSString stringWithFormat:@"%@<%@>", obj, @(gramsPerMole).stringValue];
    }];
    return unitStrings;
}


@end



#pragma mark - Length

@implementation APPSUnit (Length)

+ (instancetype)meterUnitWithMetricPrefix:(APPSMetricPrefix)prefix
{
    NSString *prefixString = [self _prefixStringForMetricPrefix:prefix];
    return [self unitFromString:[prefixString stringByAppendingString:@"m"]];
}


+ (instancetype)meterUnit
{
    return [self meterUnitWithMetricPrefix:APPSMetricPrefixNone];
}


+ (instancetype)inchUnit
{
    return [self unitFromString:@"in"];
}


+ (instancetype)footUnit
{
    return [self unitFromString:@"ft"];
}


+ (instancetype)yardUnit
{
    return [self unitFromString:@"yd"];
}


+ (instancetype)mileUnit
{
    return [self unitFromString:@"mi"];
}


+ (NSArray *)availableLengthUnitStrings
{
    NSArray *unitStrings = [self metricUnitStringsForUnit:@"m"];
    unitStrings = [unitStrings arrayByAddingObjectsFromArray:@[@"in", @"ft", @"yd", @"mi"]];
    return unitStrings;
}


@end


#pragma mark - Volume

@implementation APPSUnit (Volume)

+ (instancetype)literUnitWithMetricPrefix:(APPSMetricPrefix)prefix
{
    NSString *prefixString = [self _prefixStringForMetricPrefix:prefix];
    return [self unitFromString:[prefixString stringByAppendingString:@"L"]];
}


+ (instancetype)literUnit
{
    return [self unitFromString:@"L"];
}


+ (instancetype)fluidOunceUSUnit
{
    return [self unitFromString:@"fl_oz_us"];
}


+ (instancetype)fluidOunceImperialUnit
{
    return [self unitFromString:@"fl_oz_imp"];
}


+ (instancetype)pintUSUnit
{
    return [self unitFromString:@"pt_us"];
}


+ (instancetype)pintImperialUnit
{
    return [self unitFromString:@"pt_imp"];
}


+ (instancetype)cupUSUnit
{
    return [self unitFromString:@"cup_us"];
}


+ (instancetype)cupImperialUnit
{
    return [self unitFromString:@"cup_imp"];
}


+ (NSArray *)availableVolumeUnitStrings
{
    NSArray *unitStrings = [self metricUnitStringsForUnit:@"L"];
    unitStrings = [unitStrings arrayByAddingObjectsFromArray:@[@"fl_oz_us", @"fl_oz_imp", @"pt_us", @"pt_imp", @"cup_us", @"cup_imp"]];
    return unitStrings;
}


@end



#pragma mark - Time

@implementation APPSUnit (Time)

+ (instancetype)secondUnitWithMetricPrefix:(APPSMetricPrefix)prefix
{
    NSString *prefixString = [self _prefixStringForMetricPrefix:prefix];
    return [self unitFromString:[prefixString stringByAppendingString:@"s"]];
}


+ (instancetype)secondUnit
{
    return [self unitFromString:@"s"];
}


+ (instancetype)minuteUnit
{
    return [self unitFromString:@"min"];
}


+ (instancetype)hourUnit
{
    return [self unitFromString:@"hr"];
}


+ (instancetype)dayUnit
{
    return [self unitFromString:@"d"];
}


+ (NSArray *)availableTimeUnitStrings
{
    NSArray *unitStrings = [self metricUnitStringsForUnit:@"s"];
    unitStrings = [unitStrings arrayByAddingObjectsFromArray:@[@"min", @"hr", @"d"]];
    return unitStrings;
}

@end



#pragma mark - Time

@implementation APPSUnit (Math)

- (APPSUnit *)unitDividedByUnit:(APPSUnit *)unit
{
    NSString *unitString = [NSString stringWithFormat:@"%@/%@", self.unitString, unit.unitString];
    return [APPSUnit unitFromString:unitString];
}


@end


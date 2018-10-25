//
//  APPSBaseUnit.h
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/28/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

#import "APPSUnit.h"

/**
 This is for the private use of APPSUnit.
 This is the base class of "Single" unit classes such as
 Mass, Length, and Time.
 */

@interface APPSBaseUnit : APPSUnit

- (instancetype)initWithUnitString:(NSString *)unitString multiplier:(NSDecimalNumber *)multiplier;

@end


// These subclasses are used to determine compatiblity
@interface APPSMassUnit : APPSBaseUnit @end
@interface APPSLengthUnit : APPSBaseUnit @end
@interface APPSVolumeUnit : APPSBaseUnit @end
@interface APPSTimeUnit : APPSBaseUnit @end

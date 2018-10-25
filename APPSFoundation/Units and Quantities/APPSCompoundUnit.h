//
//  APPSCompoundUnit.h
//  AppstronomyStandardKit
//
//  Created by Ken Grigsby on 12/28/15.
//  Copyright © 2015 Appstronomy, LLC. All rights reserved.
//

#import "APPSUnit.h"

/**
 This is for the private use of APPSUnit.
 This class is used to represent combinations of "Single" units such
 as "m/s" or "kg/min".
 */

@interface APPSCompoundUnit : APPSUnit

- (instancetype)initWithUnitString:(NSString *)unitString dividendUnit:(APPSUnit *)dividendUnit divisorUnit:(APPSUnit *)divisorUnit;

@end

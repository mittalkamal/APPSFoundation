//
//  NSMutableString+Appstronomy.m
//  APPSFoundation
//
//  Created by Ken Grigsby on 4/29/17.
//  Copyright © 2017 Appstronomy, LLC. All rights reserved.
//

#import "NSMutableString+Appstronomy.h"

@implementation NSMutableString (Appstronomy)

- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement
{
    return [self replaceOccurrencesOfString:target withString:replacement options:0 range:NSMakeRange(0, self.length)];
}

@end

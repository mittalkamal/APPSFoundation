//
//  NSArray+AppstronomyTests.m
//  AppstronomyStandardKit
//
//  Created by Sohail Ahmed on 3/12/16.
//  Copyright © 2016 Appstronomy, LLC. All rights reserved.
//

#import "APPSBaseTestCase.h"
#import "APPSImports+Categories.h"


@interface NSArrayAppstronomyTests : APPSBaseTestCase
@end


@implementation NSArrayAppstronomyTests

#pragma mark - Tests

- (void)test_apps_asPrettyPrintedJSONString;
{
    NSArray *sampleArray = @[@1, @2, @3];
    NSString *jsonResult = [sampleArray apps_asPrettyPrintedJSONString];
    NSString *jsonExpected = @"[\n  1,\n  2,\n  3\n]";
    
    XCTAssertNotNil(jsonResult);
    XCTAssertEqualObjects(jsonExpected, jsonResult, @"Expected JSON: %@ but received JSON: %@", jsonExpected, jsonResult);
}

@end

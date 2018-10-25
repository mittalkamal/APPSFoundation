//
//  NSDictionary+AppstronomyTests.m
//  AppstronomyStandardKit
//
//  Created by Sohail Ahmed on 3/12/16.
//  Copyright © 2016 Appstronomy, LLC. All rights reserved.
//

#import "APPSBaseTestCase.h"
#import "APPSImports+Categories.h"

@interface NSDictionaryAppstronomyTests : APPSBaseTestCase
@end


@implementation NSDictionaryAppstronomyTests

#pragma mark - Tests

- (void)test_apps_asPrettyPrintedJSONString;
{
    NSDictionary *sample = @{@"one": @1, @"two": @2, @"three": @3};
    NSString *jsonResult = [sample apps_asPrettyPrintedJSONString];
    NSString *jsonExpected = @"{\n  \"one\" : 1,\n  \"two\" : 2,\n  \"three\" : 3\n}";
    
    XCTAssertNotNil(jsonResult);
    XCTAssertEqualObjects(jsonExpected, jsonResult, @"Expected JSON: %@ but received JSON: %@", jsonExpected, jsonResult);
}


@end

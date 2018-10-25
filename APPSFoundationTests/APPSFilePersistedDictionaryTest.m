//
//  APPSFilePersistedDictionaryTest.m
//  AppstronomyStandardKit
//
//  Created by Sohail Ahmed on 1/8/16.
//  Copyright © 2016 Appstronomy, LLC. All rights reserved.
//

@import APPSFoundation;

#import "APPSBaseTestCase.h"
#import "APPSFilePersistedDictionary.h"


#pragma mark - Constants

static NSString *const kAPPSTest_Key1 = @"testKey1";
static NSString *const kAPPSTest_Key2 = @"testKey2";
static NSString *const kAPPSTest_Key3 = @"testKey3";


@interface APPSFilePersistedDictionaryTest : APPSBaseTestCase
@property (strong, nonatomic) NSString *resourceName;
@property (strong, nonatomic) NSString *libraryDirectory;
@property (strong, nonatomic) NSString *documentsDirectory;
@property (strong, nonatomic) NSString *cachesDirectory;
@property (strong, nonatomic) NSString *applicationSupportDirectory;
@property (strong, nonatomic) NSString *temporaryDirectory;
@property (strong, nonatomic) NSDictionary *starterDictionary;
@property (strong, nonatomic) APPSFilePersistedDictionary *defaultPersistedDictionary;
@end


@implementation APPSFilePersistedDictionaryTest

#pragma mark - Lifecycle

- (void)setUp;
{
    [super setUp];

    self.resourceName                = @"MyTest";
    self.libraryDirectory            = [APPSFilePersistedDictionary libraryDirectory];
    self.documentsDirectory          = [APPSFilePersistedDictionary documentsDirectory];
    self.temporaryDirectory          = [APPSFilePersistedDictionary temporaryDirectory];
    self.cachesDirectory             = [APPSFilePersistedDictionary cachesDirectory];
    self.applicationSupportDirectory = [APPSFilePersistedDictionary applicationSupportDirectory];

    self.starterDictionary           = @{ kAPPSTest_Key1 : @"testValue1",
                                          kAPPSTest_Key2 : @[@1, @2, @3],
                                          kAPPSTest_Key3 : [NSDate date]};

    self.defaultPersistedDictionary  = [[APPSFilePersistedDictionary alloc] initWithResourceName:self.resourceName];
}


- (void)tearDown;
{
    // Remove the persisted file:
    [[NSFileManager defaultManager] removeItemAtPath:[self.defaultPersistedDictionary resolvedFilePath] error:nil];
    
    // Clear our reference:
    self.defaultPersistedDictionary = nil;
    
    [super tearDown];
}


#pragma mark - Tests

#pragma mark * Location Types

- (void)test_resolvedResourcePath__usingDefaultDirectory;
{
    APPSFilePersistedDictionary *persistedDict = [[APPSFilePersistedDictionary alloc] initWithResourceName:self.resourceName];
    
    NSString *actualResolvedFilePath = persistedDict.resolvedFilePath;
    NSString *expectedResolvedFilePath = [NSString stringWithFormat:@"%@/%@.plist", self.applicationSupportDirectory, self.resourceName];
    
    XCTAssertEqualObjects(actualResolvedFilePath, expectedResolvedFilePath);
}


- (void)test_resolvedResourcePath__usingDocumentsDirectory;
{
    APPSFilePersistedDictionary *persistedDict = [[APPSFilePersistedDictionary alloc]
                                                  initWithResourceName:self.resourceName
                                                  inLocationType:APPSFilePersistedDictionaryLocationType_DocumentsDirectory];
    
    NSString *actualResolvedFilePath = persistedDict.resolvedFilePath;
    NSString *expectedResolvedFilePath = [NSString stringWithFormat:@"%@/%@.plist", self.documentsDirectory, self.resourceName];
    
    XCTAssertEqualObjects(actualResolvedFilePath, expectedResolvedFilePath);
}


- (void)test_resolvedResourcePath__usingLibraryDirectory;
{
    APPSFilePersistedDictionary *persistedDict = [[APPSFilePersistedDictionary alloc]
                                                  initWithResourceName:self.resourceName
                                                  inLocationType:APPSFilePersistedDictionaryLocationType_LibraryDirectory];
    
    NSString *actualResolvedFilePath = persistedDict.resolvedFilePath;
    NSString *expectedResolvedFilePath = [NSString stringWithFormat:@"%@/%@.plist", self.libraryDirectory, self.resourceName];
    
    XCTAssertEqualObjects(actualResolvedFilePath, expectedResolvedFilePath);
}


- (void)test_resolvedResourcePath__usingCachesDirectory;
{
    APPSFilePersistedDictionary *persistedDict = [[APPSFilePersistedDictionary alloc]
                                                  initWithResourceName:self.resourceName
                                                  inLocationType:APPSFilePersistedDictionaryLocationType_CachesDirectory];
    
    NSString *actualResolvedFilePath = persistedDict.resolvedFilePath;
    NSString *expectedResolvedFilePath = [NSString stringWithFormat:@"%@/%@.plist", self.cachesDirectory, self.resourceName];
    
    XCTAssertEqualObjects(actualResolvedFilePath, expectedResolvedFilePath);
}


- (void)test_resolvedResourcePath__usingApplicationSupportDirectory;
{
    APPSFilePersistedDictionary *persistedDict = [[APPSFilePersistedDictionary alloc]
                                                  initWithResourceName:self.resourceName
                                                  inLocationType:APPSFilePersistedDictionaryLocationType_ApplicationSupportDirectory];
    
    NSString *actualResolvedFilePath = persistedDict.resolvedFilePath;
    NSString *expectedResolvedFilePath = [NSString stringWithFormat:@"%@/%@.plist", self.applicationSupportDirectory, self.resourceName];
    
    XCTAssertEqualObjects(actualResolvedFilePath, expectedResolvedFilePath);
}


- (void)test_resolvedResourcePath__usingTemporaryDirectory;
{
    APPSFilePersistedDictionary *persistedDict = [[APPSFilePersistedDictionary alloc]
                                                  initWithResourceName:self.resourceName
                                                  inLocationType:APPSFilePersistedDictionaryLocationType_TemporaryDirectory];
    
    NSString *actualResolvedFilePath = persistedDict.resolvedFilePath;
    NSString *expectedResolvedFilePath = [NSString stringWithFormat:@"%@/%@.plist", self.temporaryDirectory, self.resourceName];
    
    XCTAssertEqualObjects(actualResolvedFilePath, expectedResolvedFilePath);
}


- (void)test_resolvedResourcePath__usingCustomDirectory;
{
    NSString *customDirectory = [self.documentsDirectory stringByAppendingPathComponent:@"MyCustomSubDirectory"];
    APPSFilePersistedDictionary *persistedDict = [[APPSFilePersistedDictionary alloc]
                                                  initWithResourceName:self.resourceName inCustomDirectory:customDirectory];
    
    NSString *actualResolvedFilePath = persistedDict.resolvedFilePath;
    NSString *expectedResolvedFilePath = [NSString stringWithFormat:@"%@/%@.plist", customDirectory, self.resourceName];
    
    XCTAssertEqualObjects(actualResolvedFilePath, expectedResolvedFilePath);
    XCTAssertTrue([[NSFileManager defaultManager] fileExistsAtPath:customDirectory], @"Custom directory was not created!");
}


#pragma mark * Reading and Writing Values

- (void)test_persistedValueForKey;
{
    [self loadStarterDictionaryContents];
    
    for (NSString *iteratedKey in self.starterDictionary.allKeys) {
        id iteratedValue = self.starterDictionary[iteratedKey];
        id iteratedValueRetrieved = [self.defaultPersistedDictionary persistedValueForKey:iteratedKey];

        XCTAssertNotNil(iteratedValue);
        XCTAssertNotNil(iteratedValueRetrieved);
        
        // Are we dealing with date values?
        if ([iteratedValue isKindOfClass:[NSDate class]]) {
            // YES: Dates are trickier to compare. We'll get the number of seconds since an epoch, and ensure we're not looking at
            // sub-second storage representational differences.
            XCTAssertEqual((long)[iteratedValue timeIntervalSinceReferenceDate],
                           (long)[iteratedValueRetrieved timeIntervalSinceReferenceDate],
                           @"Dates don't match for key '%@': {%@, %@}",
                          iteratedKey, iteratedValue, iteratedValueRetrieved);
        }
        else {
            XCTAssertEqualObjects(iteratedValue, iteratedValueRetrieved, @"Values didn't match for key '%@'", iteratedKey);
        }
    }
}


- (void)test_persistValue_forKey__insertedValue;
{
    [self loadStarterDictionaryContents];
    
    NSString *testValue = @"banana";
    NSString *testKey = @"fruit";
    
    [self.defaultPersistedDictionary persistValue:testValue forKey:testKey];

    NSString *retrievedValue = [self.defaultPersistedDictionary persistedValueForKey:testKey];
    
    XCTAssertEqualObjects(testValue, retrievedValue, @"Values didn't match for insert operation with key '%@'", testKey);
}


- (void)test_persistValue_forKey__updatedValue;
{
    [self loadStarterDictionaryContents];

    NSString *testValue = @"The Modified Test Value";
    NSString *testKey = kAPPSTest_Key1;
    
    [self.defaultPersistedDictionary persistValue:testValue forKey:testKey];
    
    NSString *retrievedValue = [self.defaultPersistedDictionary persistedValueForKey:testKey];
    
    XCTAssertEqualObjects(testValue, retrievedValue, @"Values didn't match for update operation with key '%@'", testKey);
}


- (void)test_removePersistedValueForKey;
{
    [self loadStarterDictionaryContents];

    NSString *testKey = kAPPSTest_Key1;
    
    // Request removal of the entry with this key:
    [self.defaultPersistedDictionary removePersistedValueForKey:testKey];
    
    // Now confirm it doesn't exist:
    id retrievedValue = [self.defaultPersistedDictionary persistedValueForKey:testKey];

    XCTAssertNil(retrievedValue, @"The persisted dictionary did not actually remove the entry for key '%@'", testKey);
}


#pragma mark * File Operations

- (void)test_lastModifiedDate;
{
    [self loadStarterDictionaryContents];

    NSDate *modificationDate1 = [self.defaultPersistedDictionary lastModifiedDate];
    XCTAssertNotNil(modificationDate1);
    
    // Introduce a short, synchronous delay, per the code examples found here: https://www.objc.io/issues/15-testing/xctest/
    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                             beforeDate:[NSDate dateWithTimeIntervalSinceNow:2]];

    [self.defaultPersistedDictionary persistValue:@"dummy value" forKey:@"dummy key"];

    NSDate *modificationDate2 = [self.defaultPersistedDictionary lastModifiedDate];
    XCTAssertNotNil(modificationDate2);
    
    NSLog(@"Modification Timestamps: {%@, %@}", modificationDate1, modificationDate2);
    XCTAssertTrue([modificationDate2 apps_isLaterThan:modificationDate1], @"The file timestamp should have changed.");
}


- (void)test_remove;
{
    self.defaultPersistedDictionary  = [[APPSFilePersistedDictionary alloc] initWithResourceName:self.resourceName];
    NSDate *modificationDate = [self.defaultPersistedDictionary lastModifiedDate];
    XCTAssertNil(modificationDate, @"The dictionary should not yet have been persisted");

    [self.defaultPersistedDictionary persistValue:@"dummy value" forKey:@"dummy key"];
    modificationDate = [self.defaultPersistedDictionary lastModifiedDate];
    XCTAssertNotNil(modificationDate, @"We should have had a date returned, indicating that the file really existed.");

    // Now delete the stored directory, and confirm it:
    [self.defaultPersistedDictionary remove];
    modificationDate = [self.defaultPersistedDictionary lastModifiedDate];
    XCTAssertNil(modificationDate, @"The dictionary should no longer exist; no longer be persisted");
}



#pragma mark - Helpers

- (void)loadStarterDictionaryContents;
{
    for (NSString *iteratedKey in self.starterDictionary.allKeys) {
        id iteratedValue = self.starterDictionary[iteratedKey];
        [self.defaultPersistedDictionary persistValue:iteratedValue forKey:iteratedKey];
    }
}

@end

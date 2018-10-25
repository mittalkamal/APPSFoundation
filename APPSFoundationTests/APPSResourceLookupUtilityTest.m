//
//  APPSResourceLookupUtilityTest.m
//  PKPDCalculator
//
//  Created by Ken Grigsby on 3/30/15.
//

#import "APPSBaseTestCase.h"
#import "APPSResourceLookupUtility.h"
#import "APPSBuildConfiguration.h"

@interface APPSResourceLookupUtilityTest : APPSBaseTestCase

// Set these to create the appropriate files before calling configureTest.
@property (nonatomic) BOOL shouldCreateHostNameConfigFile;
@property (nonatomic) BOOL shouldCreateUserNameConfigFile;
@property (nonatomic) BOOL shouldCreateBuildNameConfigFile;
@property (nonatomic) BOOL shouldCreateBaseNameConfigFile;

/**
 These are created in configureTest and should be used to
 test assertions
 */
@property (nonatomic, strong) NSBundle *configBundle;
@property (nonatomic, copy)   NSString *configDirectoryPath;
@property (nonatomic, copy)   NSString *baseName;
@property (nonatomic, copy)   NSString *hostNameConfigFilePath;
@property (nonatomic, copy)   NSString *userNameConfigFilePath;
@property (nonatomic, copy)   NSString *buildNameConfigFilePath;
@property (nonatomic, copy)   NSString *baseNameConfigFilePath;
@end


@implementation APPSResourceLookupUtilityTest

- (void)setUp
{
    [super setUp];
}


- (void)tearDown
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    
    XCTAssertTrue([fm removeItemAtPath:self.configDirectoryPath error:&error]);
    
    // Remove any files that could have been created, so there are no leftovers we prematurely find between tests:
    [fm removeItemAtPath:self.hostNameConfigFilePath error:&error];
    [fm removeItemAtPath:self.userNameConfigFilePath error:&error];
    [fm removeItemAtPath:self.buildNameConfigFilePath error:&error];
    [fm removeItemAtPath:self.baseNameConfigFilePath error:&error];

    [super tearDown];
}



#pragma mark - Directory Tests

/**
 Find the <basename>.<username>.<hostname>.json file when it's the
 only one that exists.
 */
- (void)testFindingHostNameFileInDirectory
{
    // Setup
    self.shouldCreateHostNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName directoryPath:self.configDirectoryPath];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.hostNameConfigFilePath, resultFilePath);
}


/**
 Find the <basename>.<username>.json file when it's the
 only one that exists.
 */
- (void)testFindingUserNameFileInDirectory
{
    // Setup
    self.shouldCreateUserNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName directoryPath:self.configDirectoryPath];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.userNameConfigFilePath, resultFilePath);
}


/**
 Find the <basename>.json file when it's the
 only one that exists.
 */
- (void)testFindingBaseNameFileInDirectory
{
    // Setup
    self.shouldCreateBaseNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName directoryPath:self.configDirectoryPath];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.baseNameConfigFilePath, resultFilePath);
}


/**
 Find the <basename>.<username>.<hostname>.json file. All three exist, but the file path returned
 should be the most specific of the three, which is the 'hostNameConfigFilePath'.
 */
- (void)testFindingHostNameFileInDirectory2
{
    // Setup
    self.shouldCreateHostNameConfigFile = YES;
    self.shouldCreateUserNameConfigFile = YES;
    self.shouldCreateBaseNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName directoryPath:self.configDirectoryPath];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.hostNameConfigFilePath, resultFilePath);
}


/**
 Find the <basename>.<username>.json file when it and the <basename>.json file exist.
 */
- (void)testFindingUserNameFileInDirectory2
{
    // Setup
    self.shouldCreateUserNameConfigFile = YES;
    self.shouldCreateBaseNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName directoryPath:self.configDirectoryPath];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.userNameConfigFilePath, resultFilePath);
}



#pragma mark - Bundle Tests

/**
 Find the <basename>.<username>.<hostname>.json file when it's the
 only one that exists.
 */
- (void)testFindingHostNameFileInBundle
{
    // Setup
    self.shouldCreateHostNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName bundle:self.configBundle];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.hostNameConfigFilePath, resultFilePath);
}


/**
 Find the <basename>.<username>.json file when it's the
 only one that exists.
 */
- (void)testFindingUserNameFileInBundle
{
    // Setup
    self.shouldCreateUserNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName bundle:self.configBundle];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.userNameConfigFilePath, resultFilePath);
}


/**
 Find the <basename>.json file when it's the
 only one that exists.
 */
- (void)testFindingBaseNameFileInBundle
{
    // Setup
    self.shouldCreateBaseNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName bundle:self.configBundle];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.baseNameConfigFilePath, resultFilePath);
}


/**
 Find the  <basename>.<username>.<hostname>.json file all three exist.
 */
- (void)testFindingHostNameFileInBundle2
{
    // Setup
    self.shouldCreateHostNameConfigFile = YES;
    self.shouldCreateUserNameConfigFile = YES;
    self.shouldCreateBaseNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName bundle:self.configBundle];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.hostNameConfigFilePath, resultFilePath);
}


/**
 Find the <basename>.<username>.json file when it and the <basename>.json file exist.
 */
- (void)testFindingUserNameFileInBundle2
{
    // Setup
    self.shouldCreateUserNameConfigFile = YES;
    self.shouldCreateBaseNameConfigFile = YES;
    
    [self configureTest];
    
    // Execute
    APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:self.baseName bundle:self.configBundle];
    NSString *resultFilePath = [lookup firstMatchingFilePath];
    
    // Verify
    XCTAssertEqualObjects(self.userNameConfigFilePath, resultFilePath);
}



#pragma mark - Helpers

- (void)configureTest
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    NSString *fileName;
    NSString *hostName = self.hostName;
    NSString *userName = [[NSProcessInfo processInfo].environment[@"SIMULATOR_HOST_HOME"] lastPathComponent];
    NSString *buildToken = [APPSBuildConfiguration resourceToken];
    
    self.baseName = @"Base.config";
    self.configDirectoryPath = [NSTemporaryDirectory() stringByAppendingString:[NSProcessInfo processInfo].globallyUniqueString];
    XCTAssertTrue([fm createDirectoryAtPath:self.configDirectoryPath withIntermediateDirectories:YES attributes:nil error:&error]);
    self.configBundle = [NSBundle bundleWithPath:self.configDirectoryPath];
    
    if (self.shouldCreateHostNameConfigFile) {
        fileName = [NSString stringWithFormat:@"%@.%@.%@.%@.json", self.baseName, buildToken, userName, hostName];
        self.hostNameConfigFilePath = [self.configDirectoryPath stringByAppendingPathComponent:fileName];
        XCTAssertTrue([@"TEST FILE CONTENTS" writeToFile:self.hostNameConfigFilePath atomically:NO encoding:NSUTF8StringEncoding error:&error],
                      @"Error creating '%@': %@", self.hostNameConfigFilePath, error);
    }
    
    if (self.shouldCreateUserNameConfigFile) {
        fileName = [NSString stringWithFormat:@"%@.%@.%@.json", self.baseName, buildToken, userName];
        self.userNameConfigFilePath = [self.configDirectoryPath stringByAppendingPathComponent:fileName];
        XCTAssertTrue([@"TEST FILE CONTENTS" writeToFile:self.userNameConfigFilePath atomically:NO encoding:NSUTF8StringEncoding error:&error],
                      @"Error creating '%@': %@", self.userNameConfigFilePath, error);
    }
    
    if (self.shouldCreateBuildNameConfigFile) {
        fileName = [NSString stringWithFormat:@"%@.%@.json", self.baseName, buildToken];
        self.buildNameConfigFilePath = [self.configDirectoryPath stringByAppendingPathComponent:fileName];
        XCTAssertTrue([@"TEST FILE CONTENTS" writeToFile:self.buildNameConfigFilePath atomically:NO encoding:NSUTF8StringEncoding error:&error],
                      @"Error creating '%@': %@", self.buildNameConfigFilePath, error);
    }
    
    if (self.shouldCreateBaseNameConfigFile) {
        fileName = [NSString stringWithFormat:@"%@.json", self.baseName];
        self.baseNameConfigFilePath = [self.configDirectoryPath stringByAppendingPathComponent:fileName];
        XCTAssertTrue([@"TEST FILE CONTENTS" writeToFile:self.baseNameConfigFilePath atomically:NO encoding:NSUTF8StringEncoding error:&error],
                      @"Error creating '%@': %@", self.baseNameConfigFilePath, error);
    }
}


// This was copied from APPSConfigurationLookup to remove ".local"
- (NSString *)hostName
{
    NSString *hostName = [NSProcessInfo processInfo].hostName;
    
    // Remove ".local" from hostName
    NSStringCompareOptions compareOptions = NSBackwardsSearch | NSAnchoredSearch;
    NSRange range = [hostName rangeOfString:@".local" options:compareOptions];
    
    if (range.location != NSNotFound) {
        hostName = [hostName substringToIndex:range.location];
    }
    
    return hostName;
}


@end

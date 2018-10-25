//
//  APPSResourceLookupUtility.m
//  Appstronomy Standard Kit
//
//  Created by Ken Grigsby on 3/26/15.
//

#import "APPSResourceLookupUtility.h"
#import "APPSBuildConfiguration.h"
#import "APPSTargetConfiguration.h"
#import "NSString+Appstronomy.h"
#import "APPSLumberjack.h"
#import "APPSAssertHandler.h"
#import "APPSImports+Macros.h"


@interface APPSResourceLookupUtility ()
@end


@implementation APPSResourceLookupUtility

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self commonInitialization];
    }
    
    return self;
}


- (instancetype)initWithFilenames:(NSArray *)filenames
                    fileExtension:(NSString *)fileExtension
                    directoryPath:(NSString *)directoryPath
{
    [self commonInitialization];
    
    if (filenames)      { self.filenames = filenames; }
    if (fileExtension)  { self.fileExtension = fileExtension; }
    if (directoryPath)  { self.directoryPath = directoryPath; }

    return [self initWithBaseName:nil directoryPath:self.directoryPath];
}


- (instancetype)initWithFilenames:(NSArray *)filenames
                    fileExtension:(NSString *)fileExtension
                           bundle:(NSBundle *)bundle
{
    [self commonInitialization];
    
    if (filenames)      { self.filenames = filenames; }
    if (fileExtension)  { self.fileExtension = fileExtension; }
    if (bundle)         { self.bundle = bundle; }

    return [self initWithBaseName:nil bundle:self.bundle];
}


- (instancetype)initWithBaseName:(NSString *)baseName directoryPath:(NSString *)directoryPath
{
    [self commonInitialization];
    
    self.baseName = baseName;
    self.directoryPath = directoryPath;

    self.filenames = [[self buildFilenames] array];
    return (APPSResourceLookupUtility *)[super initWithFilenames:self.filenames
                                                   fileExtension:self.fileExtension
                                                   directoryPath:self.directoryPath];
}


- (instancetype)initWithBaseName:(NSString *)baseName bundle:(NSBundle *)bundle;
{
    NSParameterAssert(baseName != nil);

    [self commonInitialization];
    
    self.baseName = baseName;
    self.bundle = bundle;
    self.filenames = [[self buildFilenames] array];
    
    return (APPSResourceLookupUtility *)[super initWithFilenames:self.filenames fileExtension:self.fileExtension bundle:bundle];
}


- (void)commonInitialization;
{
    // Apply defaults
    self.fileExtension          = kAPPSResourceLookupUtility_DefaultFileExtension;
    self.buildToken             = [APPSBuildConfiguration resourceToken];
    self.targetToken            = [APPSTargetConfiguration resourceToken];
    self.searchWithBuildToken   = kAPPSResourceLookupUtility_DefaultSearchWith_BuildToken;
    self.searchWithTargetToken  = kAPPSResourceLookupUtility_DefaultSearchWith_TargetToken;
    self.searchWithUsername     = kAPPSResourceLookupUtility_DefaultSearchWith_Username;
    self.searchWithHostname     = kAPPSResourceLookupUtility_DefaultSearchWith_Hostname;
}



#pragma mark - Property Overrides

- (void)setBuildToken:(NSString *)buildToken
{
    _buildToken = [buildToken mutableCopy];
    self.filenames = nil; // Clear out cached filenames; they are no longer necessarily correct.
}


- (void)setBaseName:(NSString *)baseName
{
    _baseName = [baseName mutableCopy];
    self.filenames = nil; // Clear out cached filenames; they are no longer necessarily correct.
}


- (void)setTargetToken:(NSString *)targetToken
{
    _targetToken = [targetToken mutableCopy];
    self.filenames = nil; // Clear out cached filenames; they are no longer necessarily correct.
}



#pragma mark - Configuration

/**
 The utility method constructs all of the possible filenames that we should look
 for, and sequences them in the order that they should be searched for.

 @return An ordered sequence of candidate filenames (minus any extension).
 */
- (NSOrderedSet *)buildFilenames
{
    NSString *hostname = (self.searchWithHostname ? [APPSResourceLookupUtility hostname] : nil);
    NSString *username = (self.searchWithUsername ? [APPSResourceLookupUtility username] : nil);
    NSString *buildToken = (self.searchWithBuildToken ? self.buildToken : nil);
    NSString *targetToken = (self.searchWithTargetToken ? self.targetToken : nil);

    NSMutableOrderedSet *filenames = [NSMutableOrderedSet orderedSetWithCapacity:20];

    // Pass 1: All Tokens
    [self buildFilenamesUsingBaseName:self.baseName
                           buildToken:buildToken
                          targetToken:targetToken
                             username:username
                             hostname:hostname
                           appendInto:filenames];

    // Pass 1.1: All Except: {Target Token}
    [self buildFilenamesUsingBaseName:self.baseName
                           buildToken:buildToken
                          targetToken:nil
                             username:username
                             hostname:hostname
                           appendInto:filenames];

    // Pass 2: All Except: {Build Token}
    [self buildFilenamesUsingBaseName:self.baseName
                           buildToken:nil
                          targetToken:targetToken
                             username:username
                             hostname:hostname
                           appendInto:filenames];

    // Pass 3: All Except: {Username}
    [self buildFilenamesUsingBaseName:self.baseName
                           buildToken:buildToken
                          targetToken:targetToken
                             username:nil
                             hostname:hostname
                           appendInto:filenames];

    // Pass 4: All Except: {Build Token, Username}
    [self buildFilenamesUsingBaseName:self.baseName
                           buildToken:nil
                          targetToken:targetToken
                             username:nil
                             hostname:hostname
                           appendInto:filenames];

    // Pass 5: Only: {Build Token, Target Token}
    [self buildFilenamesUsingBaseName:self.baseName
                           buildToken:buildToken
                          targetToken:targetToken
                             username:nil
                             hostname:nil
                           appendInto:filenames];

    // Pass 6: Only: {Target Token}
    [self buildFilenamesUsingBaseName:self.baseName
                           buildToken:nil
                          targetToken:targetToken
                             username:nil
                             hostname:nil
                           appendInto:filenames];

    // Now find the entry representing just the base name, and move it to the end of the ordered search list:
    if ([filenames containsObject:self.baseName]) {
        [filenames removeObject:self.baseName];
        [filenames addObject:self.baseName];
    }

    logDebug(@"Full list of filenames generated: %@", filenames);
    
    return filenames;
}


- (id)buildFilenamesUsingBaseName:(NSString *)baseName
                       buildToken:(NSString *)buildToken
                      targetToken:(NSString *)targetToken
                         username:(NSString *)username
                         hostname:(NSString *)hostname
                       appendInto:(NSMutableOrderedSet *)filenames
{
    // Setup the search tokens. At the core, there will always be the base name:
    NSMutableArray *providedTokens = [@[baseName] mutableCopy];
    
    // Now add in the other tokens in order, based on whether they've been provided:
    if (buildToken)  { [providedTokens addObject:buildToken]; }
    if (targetToken) { [providedTokens addObject:targetToken]; }
    if (username)    { [providedTokens addObject:username];   }
    if (hostname)    { [providedTokens addObject:hostname];   }
    
    NSUInteger numberOfTokensUsed = providedTokens.count;

    // Build an array of substitution strings, one per provided token:
    NSMutableArray *substitutionStrings = [NSMutableArray arrayWithCapacity:numberOfTokensUsed];
    for (int index = 0; index < numberOfTokensUsed; ++index) {
        [substitutionStrings addObject:@"%@"];
    }

    // Now create a copy of the provided tokens that we'll strip down
    // as we loop through each more general filename variation:
    NSMutableArray *searchTokens = [providedTokens mutableCopy];

    while ([substitutionStrings count] > 0) {
        // Build a filename:
        NSArray *arguments = searchTokens;
        NSString *format = [substitutionStrings componentsJoinedByString:@"."];
        NSString *filename = [NSString apps_stringWithFormat:format arguments:arguments];
        [filenames addObject:filename];
        
        // Remove a token and substitution string from their respective mutable arrays:
        [searchTokens removeLastObject];
        [substitutionStrings removeLastObject];
    }

    return filenames;
}


+ (NSString *)hostname
{
    // Check for a real device since using *some* NSProcessInfo information on actual devices can lead to semaphore traps.
    // See: https://github.com/appstronomy/icpd-pkpd-calculator/issues/891
    if ([self isRealDeviceNotRunningTests]) { return nil; } // BAIL.
    
    NSString *hostname = [NSProcessInfo processInfo].hostName;
    
    // Remove ".local" from hostname
    NSStringCompareOptions compareOptions = NSBackwardsSearch | NSAnchoredSearch;
    NSRange range = [hostname rangeOfString:@".local" options:compareOptions];
    
    if (range.location != NSNotFound) {
        hostname = [hostname substringToIndex:range.location];
    }
    
    return hostname;
}


+ (NSString *)username
{
    // Check for a real device since using *some* NSProcessInfo information on actual devices can lead to semaphore traps.
    // See: https://github.com/appstronomy/icpd-pkpd-calculator/issues/891
    if ([self isRealDeviceNotRunningTests]) { return nil; } // BAIL.

    NSDictionary *env = [NSProcessInfo processInfo].environment;
    NSString *username;
    
    username = NSUserName(); // Returns empty string in simulator
    
    if (username.length == 0) {
        
        // Derive user name from SIMULATOR_HOST_HOME
        NSString *hostHome = env[@"SIMULATOR_HOST_HOME"];
        if (hostHome) {
            username = hostHome.lastPathComponent;
        }
    }
    
    return username;
}


#pragma mark - Overrides: APPSFileSetLookup

- (NSString *)firstMatchingFilePath;
{
    if (!self.filenames) {
        self.filenames = [[self buildFilenames] array];
    }

    return [super firstMatchingFilePath];
}



#pragma mark - Utilities

- (NSArray *)arrayFromJSONFile;
{
    NSString *filePath = [self firstMatchingFilePath];
    APPSAssert(filePath, @"No file path was resolved in file lookup in order to retrieve "
               "JSON array contents. Details: %@", [self debugDescription]);
    
    NSURL *dataURL = [NSURL fileURLWithPath:filePath];
    
    NSData *fileData = [NSData dataWithContentsOfURL:dataURL];
    NSError *error = nil;
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:&error];
    
    APPSAssert(!error, @"Problem with converting data to an array from file '%@'. Details:\n%@",
               dataURL, [error localizedDescription]);

    return jsonArray;
}


- (NSDictionary *)dictionaryFromJSONFile;
{
    NSString *filePath = [self firstMatchingFilePath];
    APPSAssert(filePath, @"No file path was resolved in file lookup in order to retrieve "
               "JSON dictionary contents. Details: %@", [self debugDescription]);

    NSURL *dataURL = [NSURL fileURLWithPath:filePath];
    
    NSData *fileData = [NSData dataWithContentsOfURL:dataURL];
    NSError *error = nil;
    
    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:fileData options:0 error:&error];
    
    APPSAssert(!error, @"Problem with converting data to a dictionary from file '%@'. Details:\n%@",
               dataURL, [error localizedDescription]);
    
    return jsonDictionary;
}



#pragma mark - Target Inquiries

+ (BOOL)isRealDeviceNotRunningTests;
{
    // Check for a real device since using *some* NSProcessInfo information on actual devices can lead to semaphore traps.
    // See: https://github.com/appstronomy/icpd-pkpd-calculator/issues/891
    return ([APPSResourceLookupUtility apps_isRealDevice] && ![APPSTargetConfiguration isRunningTests]);
}


+ (BOOL)apps_isRealDevice;
{
#if TARGET_OS_SIMULATOR
    return NO;
#else
    return YES;
#endif
}



#pragma mark - Debugging Support

- (NSString *)debugDescription;
{
    // Print the class name and memory address, per: http://stackoverflow.com/a/7555194/535054
    NSMutableString *message = [NSMutableString stringWithFormat:@"<%@: %p> ; data: {\n\t", [[self class] description], (__bridge void *)self];
    [message appendFormat:@"baseName: %@\n\t",      self.baseName];
    [message appendFormat:@"fileExtension: %@\n\t", self.fileExtension];
    [message appendFormat:@"bundle: %@\n\t",        self.bundle];
    [message appendFormat:@"directoryPath: %@\n",   self.directoryPath];
    [message appendFormat:@"buildToken: %@\n",      self.buildToken];
    [message appendFormat:@"targetToken: %@\n",     self.targetToken];
    [message appendString:@"}\n"];
    
    return message;
}

@end

//
//  APPSFilePersistedDictionary.m
//  AppstronomyStandardKit
//
//  Created by Sohail Ahmed on 1/7/16.
//  Copyright © 2016 Appstronomy, LLC. All rights reserved.
//

#import "APPSFilePersistedDictionary.h"
#import "APPSImports+Macros.h"
#import "APPSLumberjack.h"
#import "APPSImports+Macros.h"

#pragma mark - Constants

/**
 The file extension we use. Note how we don't include the ".". Callers will prefix with that in any path
 construction operations they need to perform.
 */
static NSString *const kAPPSFilePersistedDictionary_FileExtension = @"plist";

/**
 The default directory we'll use for storage, if a location type is not explicitly given during initialization.
 */
static const APPSFilePersistedDictionaryLocationType kAPPSFilePersistedDictionary_DefaultLocationType = APPSFilePersistedDictionaryLocationType_ApplicationSupportDirectory;



@implementation APPSFilePersistedDictionary

#pragma mark - Initialization

- (instancetype)initWithResourceName:(NSString *)resourceName;
{
    self = [super init];
    
    if (self) {
        self.locationType = kAPPSFilePersistedDictionary_DefaultLocationType;
        self.resourceName = resourceName;
    }
    
    return self;
}


- (instancetype)initWithResourceName:(NSString *)resourceName inLocationType:(APPSFilePersistedDictionaryLocationType)locationType;
{
    self = [super init];
    
    if (self) {
        self.locationType = locationType;
        self.resourceName = resourceName;
    }
    
    return self;
}


- (instancetype)initWithResourceName:(NSString *)resourceName inCustomDirectory:(NSString *)customDirectory;
{
    self = [super init];
    
    if (self) {
        self.locationType = APPSFilePersistedDictionaryLocationType_Custom;
        self.resourceName = resourceName;
        self.customDirectory = customDirectory;
    }
    
    return self;
}



#pragma mark - Property Overrides

- (void)setCustomDirectory:(NSString *)customDirectory;
{
    if (_customDirectory != customDirectory) {
        _customDirectory = customDirectory;
    }
    
    [self ensureCustomDirectoryExists];
}


#pragma mark - Value Storage and Retrieval

- (id)persistedValueForKey:(NSString *)key
{
    id valueRetrieved = nil;
    valueRetrieved = [self contents][key];
    
    return valueRetrieved;
}


- (void)persistValue:(id)value forKey:(NSString *)key
{
    NSMutableDictionary *persistedDictionary = [self contents];
    persistedDictionary[key] = value;
    [persistedDictionary writeToFile:[self resolvedFilePath] atomically:YES];
}


- (void)removePersistedValueForKey:(NSString *)key
{
    NSMutableDictionary *persistedDictionary = [self contents];
    [persistedDictionary removeObjectForKey:key];
    [persistedDictionary writeToFile:[self resolvedFilePath] atomically:YES];
}


- (NSMutableDictionary *)contents
{
    NSString *resolvedFilePath = [self resolvedFilePath];
    APPSAssert(resolvedFilePath, @"Without a persisted file path, we can't load the contents of this file.");
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    NSMutableDictionary *persistedMutableDictionary;
    
    // Are we missing the persisted file?
    if (![fileManager fileExistsAtPath: resolvedFilePath]) {
        // YES. It's missing, so we'll create one to start things off.
        logInfo(@"Persisted file does not yet exist at path: %@", resolvedFilePath);
        persistedMutableDictionary = [NSMutableDictionary dictionary]; // Seed with an empty dictionary.
        [persistedMutableDictionary writeToFile:resolvedFilePath atomically:YES];
    }
    
    // Now retrieve the file:
    persistedMutableDictionary = [[NSMutableDictionary alloc] initWithContentsOfFile:resolvedFilePath];
    
    return persistedMutableDictionary;
}


- (NSDictionary *)snapshot;
{
    return [NSDictionary dictionaryWithDictionary:[self contents]];
}



#pragma mark - Inquiries

- (BOOL)hasContent;
{
    return ([[[self snapshot] allKeys] count] > 0);
}


// CREDIT: http://stackoverflow.com/a/6907432/535054
+ (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = ([paths count] > 0) ? paths[0] : nil;
    
    return directoryPath;
}


// CREDIT: http://stackoverflow.com/a/6907432/535054
+ (NSString *)libraryDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = ([paths count] > 0) ? paths[0] : nil;
    
    return directoryPath;
}


+ (NSString *)applicationSupportDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = ([paths count] > 0) ? paths[0] : nil;
    
    return directoryPath;
}


+ (NSString *)cachesDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *directoryPath = ([paths count] > 0) ? paths[0] : nil;
    
    return directoryPath;
}



// CREDIT: http://nshipster.com/nstemporarydirectory/
+ (NSString *)temporaryDirectory
{
    NSURL *directoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    NSString *directoryPath = [directoryURL path];
    
    return directoryPath;
}


- (NSString *)resolvedFilePath
{
    APPSAssert(self.resourceName, @"Cannot determine a 'resolvedFilepath' when the 'resourceName' has not yet been set.");
    
    NSString *directoryPath = nil;
    
    switch (self.locationType) {
        case APPSFilePersistedDictionaryLocationType_None: {
            APPSAssert(NO, @"Property 'locationType' has not been set for resource with name '%@'", self.resourceName);
            break;
        }
        case APPSFilePersistedDictionaryLocationType_Custom: {
            directoryPath = self.customDirectory;
            break;
        }
        case APPSFilePersistedDictionaryLocationType_DocumentsDirectory: {
            directoryPath = [[self class] documentsDirectory];
            break;
        }
        case APPSFilePersistedDictionaryLocationType_LibraryDirectory: {
            directoryPath = [[self class] libraryDirectory];
            break;
        }
        case APPSFilePersistedDictionaryLocationType_CachesDirectory: {
            directoryPath = [[self class] cachesDirectory];
            break;
        }
        case APPSFilePersistedDictionaryLocationType_ApplicationSupportDirectory: {
            directoryPath = [[self class] applicationSupportDirectory];
            break;
        }
        case APPSFilePersistedDictionaryLocationType_TemporaryDirectory: {
            directoryPath = [[self class] temporaryDirectory];
            break;
        }
    }

    APPSAssert(directoryPath, @"Without a valid directory path indicated, we can't construct the path "
        "to our persisted dictionary plist file for resource '%@'.", self.resourceName);

    NSString *resolvedPath = [directoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",
                                                                                     self.resourceName,
                                                                                     kAPPSFilePersistedDictionary_FileExtension]];

    return resolvedPath;
}


- (NSDate *)lastModifiedDate;
{
    NSString *resolvedFilePath = [self resolvedFilePath];
    APPSAssert(resolvedFilePath, @"Cannot retrieve a last modified date for a resource whose path does not exist. ");

    NSDate *modificationDate = nil;
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:resolvedFilePath]) {
        modificationDate = [APPSFilePersistedDictionary lastModifiedDateOfFileAtResourcePath:resolvedFilePath];
    }
    
    return modificationDate;
}


+ (NSDate *)lastModifiedDateOfFileAtResourcePath:(NSString *)resourceFilePath;
{
    // Ensure the file exists at the given path:
    APPSAssert([[NSFileManager defaultManager] fileExistsAtPath:resourceFilePath],
               @"There was no file to inspect a timestamp for resource at path: '%@'. ",
               resourceFilePath);
    
    // Do the actual file attributes inspection to get at the modification date:
    NSError *error = nil;
    NSDate *fileModificationDate = [[[NSFileManager defaultManager] attributesOfItemAtPath:resourceFilePath error:&error] fileModificationDate];
    
    // Ensure no errors in getting file attribute information:
    APPSAssert(!error, @"Error in trying to get file info on resource with path: '%@'. Error: %@", resourceFilePath, [error localizedDescription]);
    
    // Report what was found:
    logDebug(@"resourceFilePath: '%@' | File Modification Date: %@", resourceFilePath, fileModificationDate);
    
    return fileModificationDate;
}


#pragma mark - File Operations

- (BOOL)remove;
{
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    BOOL deletionSuccess = YES;
    
    // Is the file currently present?
    if ([defaultManager fileExistsAtPath:[self resolvedFilePath]]) {
        NSError *deletionError = nil;
        BOOL deletionSuccess = [defaultManager removeItemAtPath:[self resolvedFilePath] error:&deletionError];
        
        if (deletionSuccess) {
            logInfo(@"Deleted persisted dictionary '%@' at path '%@'", self.resourceName, [self resolvedFilePath]);
        }
        else {
            NSString *failureMessage = [NSString stringWithFormat:@"Attempted to delete dictionary file at path: '%@', but failed with error: %@",
                                        [self resolvedFilePath], [deletionError localizedDescription]];
            APPSAssert(deletionSuccess, @"%@", failureMessage);
        }
    }

    return deletionSuccess;
}


#pragma Private Utilities

- (void)ensureCustomDirectoryExists;
{
    // Create the directory if it was specified and doesn't already exist.
    if (self.customDirectory) {
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        
        // Is the directory currently missing?
        if (![defaultManager fileExistsAtPath:self.customDirectory]) {
            // YES: So create it.
            NSError *createDirectoryError = nil;
            BOOL creationSuccess = [defaultManager createDirectoryAtPath:self.customDirectory
                                             withIntermediateDirectories:YES
                                                              attributes:nil
                                                                   error:&createDirectoryError];
            
            if (creationSuccess) {
                logInfo(@"Created directory '%@' to support storing persisted dictionary with resource name '%@'", _customDirectory, self.resourceName);
            }
            else {
                NSString *failureMessage = [NSString stringWithFormat:@"Attempted to create custom directory at path: '%@', but failed with error: %@",
                                            self.customDirectory, [createDirectoryError localizedDescription]];
                APPSAssert(creationSuccess, @"%@", failureMessage);
            }
        }
    }
}


@end

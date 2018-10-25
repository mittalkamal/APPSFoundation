//
//  NSFileManager+Appstronomy.m
//  AppstronomyStandardKit
//
//  Created by Sohail Ahmed on 2/19/16.
//  Copyright © 2016 Appstronomy, LLC. All rights reserved.
//

#import "NSFileManager+Appstronomy.h"
#import "APPSLumberjack.h"


@implementation NSFileManager (Appstronomy)

#pragma mark - Backup Attribute

+ (BOOL)applyExcludeFromBackupAttributeToItemAtPath:(NSString *)filePath;
{
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    return [self applyExcludeBackupAttributeValue:YES toItemAtURL:fileURL];
}

+ (BOOL)applyExcludeFromBackupAttributeToItemAtURL:(NSURL *)fileURL;
{
    return [self applyExcludeBackupAttributeValue:YES toItemAtURL:fileURL];
}


+ (BOOL)applyIncludeForBackupAttributeToItemAtPath:(NSString *)filePath;
{
    NSURL *fileURL = [NSURL fileURLWithPath:filePath];

    return [self applyExcludeBackupAttributeValue:NO toItemAtURL:fileURL];
}


+ (BOOL)applyIncludeForBackupAttributeToItemAtURL:(NSURL *)fileURL;
{
    return [self applyExcludeBackupAttributeValue:NO toItemAtURL:fileURL];
}


#pragma mark * Helpers

+ (BOOL)applyExcludeBackupAttributeValue:(BOOL)exclude toItemAtURL:(NSURL *)fileURL;
{
    assert([[NSFileManager defaultManager] fileExistsAtPath:[fileURL path]]);
    
    NSError *error = nil;
    
    BOOL success = [fileURL setResourceValue:[NSNumber numberWithBool: exclude]
                                  forKey:NSURLIsExcludedFromBackupKey
                                   error:&error];
    
    NSString *includeExcludeString = (exclude ? @"excluding" : @"including");

    if (success) {
        logInfo(@"Marked path: '%@' for %@ in backups.", fileURL.path, includeExcludeString);
    }
    else {
        logError(@"Error %@ %@ from backup %@", includeExcludeString, [fileURL lastPathComponent], error);
    }
    
    return success;
}




@end

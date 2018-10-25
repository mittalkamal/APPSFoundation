//
//  NSFileManager+Appstronomy.h
//  AppstronomyStandardKit
//
//  Created by Sohail Ahmed on 2/19/16.
//  Copyright © 2016 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSFileManager (Appstronomy)

#pragma mark - Backup Attribute

/**
 The file at the given path is marked with a resource value of @c YES for the key
 @c NSURLIsExcludedFromBackupKey. This means that it will not be marked for backup
 by iCloud of iTunes.
 
 Sourced from: https://developer.apple.com/library/ios/qa/qa1719/_index.html
 
 @param filePath    The full path of the resource to be excluded from backups;
                    this can be a directory or an individual file.
 
 @return YES if the setting took.
 */
+ (BOOL)applyExcludeFromBackupAttributeToItemAtPath:(NSString *)filePath;


/**
 The URL variant of @c +applyExcludeFromBackupAttributeToItemAtURL:.
 */
+ (BOOL)applyExcludeFromBackupAttributeToItemAtURL:(NSURL *)fileURL;



/**
 The file at the given path is marked with a resource value of @c NO for the key
 @c NSURLIsExcludedFromBackupKey. This means that it will be marked for backup
 by iCloud of iTunes, assuming it is in one of the app sandbox directories that 
 does get backed up.
 
 Sourced from: https://developer.apple.com/library/ios/qa/qa1719/_index.html
 
 @param filePath    The full path of the resource to be included in backups;
                    this can be a directory or an individual file.
 
 @return YES if the setting took.
 */
+ (BOOL)applyIncludeForBackupAttributeToItemAtPath:(NSString *)filePath;


/**
 The URL variant of @c +applyIncludeForBackupAttributeToItemAtPath:.
 */
+ (BOOL)applyIncludeForBackupAttributeToItemAtURL:(NSURL *)fileURL;


@end

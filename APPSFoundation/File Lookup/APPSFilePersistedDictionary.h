//
//  APPSFilePersistedDictionary.h
//  AppstronomyStandardKit
//
//  Created by Sohail Ahmed on 1/7/16.
//  Copyright © 2016 Appstronomy, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - APPS File Persisted Dictionary

// File System Location
typedef NS_ENUM(NSUInteger, APPSFilePersistedDictionaryLocationType) {
    APPSFilePersistedDictionaryLocationType_None = 0,
    APPSFilePersistedDictionaryLocationType_Custom,
    APPSFilePersistedDictionaryLocationType_DocumentsDirectory,
    APPSFilePersistedDictionaryLocationType_LibraryDirectory,
    APPSFilePersistedDictionaryLocationType_CachesDirectory,                // Lives inside the Library directory
    APPSFilePersistedDictionaryLocationType_ApplicationSupportDirectory,    // Lives inside the Library directory
    APPSFilePersistedDictionaryLocationType_TemporaryDirectory
};

/**
 This class handles primitive conveniences for loading and saving a dictionary to the app's 
 local file system.
 
 It also contains a high level interface for finding values for keys,
 so that one needn't access the underlying dictionary directly.
 
 We are meant to be subclassed, so that your subclass can provide a curated API for its 
 collaborators to use.
 
 The central goal of this class is to provide a simple interface that abstracts you from the
 mechanics of reading and writing an NSDictionary to the file system.
 
 For deciding on whether to use the Documents directory, Library Directory etc., please see Apple's guide:
 
 https://developer.apple.com/library/ios/documentation/FileManagement/Conceptual/FileSystemProgrammingGuide/FileSystemOverview/FileSystemOverview.html

 When not specified, we default to using the Application Support directory.
 */
@interface APPSFilePersistedDictionary : NSObject

#pragma mark scalar

/**
 Indicates whether a default location, such as the Documents directory is being used,
 or whether a custom location is being employed.
 */
@property (assign, nonatomic) APPSFilePersistedDictionaryLocationType locationType;


#pragma mark copy

/**
 The symbolic name of this dictionary, minus any file extension details.
 This name is what is used to store the NSDictionary to the file system.
 */
@property (copy, nonatomic) NSString *resourceName;

/**
 Optional. This is only used if the @c locationType property indicates APPSFilePersistedDictionaryLocationType_Custom.
 If this is not specified, we assume the default location of the Documents directory is being used.
 */
@property (copy, nonatomic) NSString *customDirectory;


#pragma mark - Initialization

/**
 Initializes assuming the Application Support subdirectory of the Library directory for storage. 
 Our companion file on disk may already be present. This initialization is just readying our 
 access to it, or creating the underlying file, if not already present.
 
 @param resourceName The name of the dictionary we'll read/write from.
 
 @return An initialized instance.
 */
- (instancetype)initWithResourceName:(NSString *)resourceName;


/**
 Initializes using the specified directory location type. Our companion file on disk may
 already be present. This initialization is just readying our access to it, or creating
 the underlying file, if not already present.
 
 Note that if you select a custom location type, you need to follow up with setting 
 the @c customDirectory path property.
 
 @param resourceName    The name of the dictionary we'll read/write from.
 @param locationType    Whether to store this dictionary in a predefined iOS provided directory,
                        such as the Documents directory, the Library directory; 
                        or whether to us some custom directory.
 
 @return An initialized instance.
 */
- (instancetype)initWithResourceName:(NSString *)resourceName inLocationType:(APPSFilePersistedDictionaryLocationType)locationType;


/**
 Initializes assuming a @em custom directory for storage. Our companion file on disk may
 already be present. This initialization is just readying our access to it, or creating
 the underlying file, if not already present.
 
 @param resourceName The name of the dictionary we'll read/write from.
 @param customDirectory The directory (fully qualified) in which our dictionary is written to/read from.
 
 @return An initialized instance.
 */
- (instancetype)initWithResourceName:(NSString *)resourceName inCustomDirectory:(NSString *)customDirectory;



#pragma mark - Inquiries

/**
 Advises if we have any content.
 
 @return YES if we have at least one entry stored.
 */
- (BOOL)hasContent;


/**
 Returns the application's Documents directory using Apple's API, in case the path changes.
 Recall, the @c Documents directory is where user files are stored.
 */
+ (NSString *)documentsDirectory;


/**
 Returns the application's Library directory using Apple's API, in case the path changes.
 Recall, the @c Library directory is for non-user facing files.
*/
+ (NSString *)libraryDirectory;


/**
 Return the caches sub-folder of the Library directory.
 */
+ (NSString *)cachesDirectory;


/**
 Return the application support sub-folder of the Library directory. This is where metadata
 the user should never need to know exists, would get placed. This is also the default location 
 for persistence.
 */
+ (NSString *)applicationSupportDirectory;


/**
 Returns a temporary directory you can use, but which is not guaranteed to be long lived or
 even present between invocations. You generally don't want to use this directory when
 your goal is to @em persist a dictionary.
 */
+ (NSString *)temporaryDirectory;


/**
 The fully resolved path of our persisted dictionary. We take whichever directory is being used
 (the Documents directory or a custom directory) and append the dictionary's resource name and
 extension, to return the full path.
 
 @return A file path expressed as a string that fully resolves to where we are stored.
 */
- (NSString *)resolvedFilePath;


/**
 The date we were last modified.
 
 @return A date value.
 */
- (NSDate *)lastModifiedDate;



#pragma mark - File Operations

/**
 Removes our persistent property list (dictionary) from the file system.
 You should discard this object afterwards, as interacting with it may be unpredictable,
 and may even recreate a new dictionary file in the same place if you try to read or write
 values thereafter.
 
 @return YES if we successfully removed the file.
 */
- (BOOL)remove;


#pragma mark - Value Storage and Retrieval

/**
 A look up for the value associated with the provided key.
 
 @param key The unique lookup token.
 
 @return The associated value, from our underlying, persisted dictionary.
 */
- (id)persistedValueForKey:(NSString *)key;


/**
 Sets the provided value for the given key, and persists us 
 to the file system.
 
 @param value The value to be stored.
 @param key   The key to be used for retrieval.
 */
- (void)persistValue:(id)value forKey:(NSString *)key;


/**
 Removes our entry for the given key.
 
 @param key The unique way to identify the entry to be removed.
 */
- (void)removePersistedValueForKey:(NSString *)key;


/**
 Read Only. A snapshot of our full contents.
 
 @return A non-editable dictionary representing our contents.
 */
- (NSDictionary *)snapshot;


@end

//
//  APPSFileSetLookup.h
//  Appstronomy Standard Kit
//
//  Created by Ken Grigsby on 6/20/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Given a directory path or bundle and an ordered set of file paths to search, 
 we can advise on what the first of these file paths was found.
 
 We don't build filenames (save for tacking on the file extensions). 
 
 For logic to build filenames from user and system information, 
 see our subclass @c APPSResourceLookupUtility.
*/

@interface APPSFileSetLookup : NSObject

#pragma mark copy

/**
 The ordered list of base filenames that we will use in our search.
 */
@property (nullable, nonatomic, copy) NSArray *filenames;

/**
 The file extension we were initialized with.
 */
@property (nullable, nonatomic, copy) NSString *fileExtension;

/**
 The directory path in which we'll search for files. If not provided,
 then @c bundle should be set instead.
 */
@property (nullable, nonatomic, copy) NSString *directoryPath;



#pragma mark strong

/**
 The bundle in which we'll search for files. If not provided,
 then @c directoryPath should be set instead.
 */
@property (nonatomic, strong) NSBundle *bundle;



#pragma mark - Initialization

/**
 This initializer still requires you to set an array of @c filenames, a
 @c fileExtension and one of @c directoryPath or @c bundle.
 
 @return An instance that you still need to configure to use.
 */
- (instancetype)init NS_DESIGNATED_INITIALIZER;


/**
 Use this when you wish to scope your search to a specific directory.
 
 @param filenames     The base filenames (without their extensions) in the order you wish to search for them.
 @param fileExtension The file extension to be added to each of the provided filenames.
 @param directoryPath The directory in which to limit the search.
 
 @return A configured instance you can then ask for its first matching file path.
 */
- (instancetype)initWithFilenames:(NSArray *)filenames
                    fileExtension:(nullable NSString *)fileExtension
                    directoryPath:(NSString *)directoryPath NS_DESIGNATED_INITIALIZER;


/**
 Use this when you wish to scope your search to a specific bundle.
 
 @param filenames     The base filenames (without their extensions) in the order you wish to search for them.
 @param fileExtension The file extension to be added to each of the provided filenames.
 @param bundle        The bundle in which to limit the search.
 
 @return A configured instance you can then ask for its first matching file path.
 */
- (instancetype)initWithFilenames:(NSArray *)filenames
                    fileExtension:(nullable NSString *)fileExtension
                           bundle:(nullable NSBundle *)bundle NS_DESIGNATED_INITIALIZER;



#pragma mark - Inquiries

/**
 Advises what the full path is for the first match that we found.
 You can only read from this if properties @c filenames and @c fileExtension
 have been set, along with one of {@c directoryPath, @c bundle}.
 */
- (nullable NSString *)firstMatchingFilePath;




@end

NS_ASSUME_NONNULL_END


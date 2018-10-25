//
//  APPSConfigurationLookup.h
//  Appstronomy Standard Kit
//
//  Created by Ken Grigsby on 3/26/15.
//

#import "APPSFileSetLookup.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Constants

static NSString * const kAPPSResourceLookupUtility_DefaultFileExtension     = @"json";
static BOOL const kAPPSResourceLookupUtility_DefaultSearchWith_BuildToken   = YES;
static BOOL const kAPPSResourceLookupUtility_DefaultSearchWith_TargetToken  = YES;
static BOOL const kAPPSResourceLookupUtility_DefaultSearchWith_Username     = YES;
static BOOL const kAPPSResourceLookupUtility_DefaultSearchWith_Hostname     = YES;


/**
 Given one of {directory path, bundle} and a base file name, this utility returns
 the first config file path that exists given a hierarchy of priorities. 
 
 We use the provided base name, the current hostname and the current username to 
 determine the names of files to look for. We assume a file extension of "json",
 though you can change these by setting our inherited property @c fileExtension.
 
 Our search priority uses the following naming construction:
 
 * <basename>.<build token>.<target token>.<username>.<hostname>.json
 * <basename>.<build token>.<target token>.<username>.json
 * <basename>.<build token>.<target token>.json
 * <basename>.<build token>.json
 * <basename>.json

 However, you can turn off one or more of these components for the search. Those
 components that you leave on will be searched using the ordering implied above.
 
 We stop with the first match we're able to find, going from the more specific to the more 
 general.
 
 Here's how you might use this class:
 
     NSString *baseFilename; // Assume this was already set
     NSBundle *someBundle;   // Assume this was already set
     
     // Instantiate the Lookup class:
     APPSResourceLookupUtility *lookup = [[APPSResourceLookupUtility alloc] initWithBaseName:baseFilename bundle:someBundle];
     
     // Retrieve the first matching file:
     NSString *filePath = [lookup firstMatchingFilePath];
*/


@interface APPSResourceLookupUtility : APPSFileSetLookup

#pragma mark scalar

@property (assign, nonatomic) BOOL searchWithBuildToken;
@property (assign, nonatomic) BOOL searchWithTargetToken;
@property (assign, nonatomic) BOOL searchWithUsername;
@property (assign, nonatomic) BOOL searchWithHostname;

#pragma mark copy

@property (nullable, copy, nonatomic) NSString *baseName;

@property (nullable, copy, nonatomic) NSString *buildToken;

@property (nullable, copy, nonatomic) NSString *targetToken;


#pragma mark - Initialization

/**
 Use this simple initializer if you plan to set needed properties afterwards,
 but before requesting a first match or file contents from a first match.
 
 @return A not yet configured lookup instance.
 */
- (instancetype)init;


/**
 Create a lookup using the provided base filename, scoped to the provided directory path.
 
 @param baseName      The basename that we'll add information to to build prioritized variations for.
 @param directoryPath The directory in which to scope the search.
 
 @return A configured lookup instance you can then ask for the @c firstMatchingFilePath.
 */
- (instancetype)initWithBaseName:(nullable NSString *)baseName directoryPath:(NSString *)directoryPath;


/**
 Create a lookup using the provided base filename, scoped to the provided bundle.
 
 @param baseName The basename that we'll add information to to build prioritized variations for.
 @param bundle   The bundle in which to scope the search.
 
 @return A configured lookup instance you can then ask for the @c firstMatchingFilePath.
 */
- (instancetype)initWithBaseName:(nullable NSString *)baseName bundle:(nullable NSBundle *)bundle;



#pragma mark - Utilities

- (NSArray *)arrayFromJSONFile;

- (NSDictionary *)dictionaryFromJSONFile;


@end

NS_ASSUME_NONNULL_END

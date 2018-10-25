//
//  APPSFileSetLookup.m
//  Appstronomy Standard Kit
//
//  Created by Ken Grigsby on 6/20/15.
//

#import "APPSFileSetLookup.h"

@interface APPSFileSetLookup ()
@end


@implementation APPSFileSetLookup {
    NSString *_firstMatchingFilePath;
}

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    if (self) {}
    
    return self;
}


- (instancetype)initWithFilenames:(NSArray *)filenames
                    fileExtension:(NSString *)fileExtension
                    directoryPath:(NSString *)directoryPath
{
    NSParameterAssert(filenames != nil);
    NSParameterAssert(directoryPath != nil);
    
    self = [super init];
    
    if (self) {
        self.filenames = filenames;
        self.fileExtension = fileExtension;
        self.directoryPath = directoryPath;
    }
    
    return self;
}


- (instancetype)initWithFilenames:(NSArray *)filenames
                    fileExtension:(NSString *)fileExtension
                           bundle:(NSBundle *)bundle
{
    NSParameterAssert(filenames != nil);

    self = [super init];
    if (self) {
        
        if (!bundle) {
            bundle = [NSBundle mainBundle];
        }
        
        self.filenames = filenames;
        self.fileExtension = fileExtension;
    }
    
    return self;
}


#pragma mark - Property Overrides

- (void)setFileExtension:(NSString *)fileExtension
{
    _fileExtension = [fileExtension mutableCopy];
    _filenames = nil; // Clear out cached filenames; they are no longer necessarily correct.

}

- (void)setDirectoryPath:(NSString *)directoryPath
{
    _directoryPath = [directoryPath mutableCopy];
    _filenames = nil; // Clear out cached filenames; they are no longer necessarily correct.
}

- (void)setBundle:(NSBundle *)bundle
{
    _bundle = bundle;
    _filenames = nil; // Clear out cached filenames; they are no longer necessarily correct.
}


#pragma mark - Inquiries

- (NSString *)firstMatchingFilePath;
{
    if (!_firstMatchingFilePath) {
        [self performSearch];
    }
    
    return _firstMatchingFilePath;
}



#pragma mark - Helpers

- (void)performSearch;
{
    // Do we have enough info to perform a search?
    if (self.filenames && self.fileExtension) {
        if (self.directoryPath) {
            _firstMatchingFilePath = [self lookupFilePathInDirectory:self.directoryPath];
        }
        else {
            // We'll look in the bundle. If it is nil, we'll effectively be looking
            // in the main app bundle:
            _firstMatchingFilePath = [self lookupFilePathInBundle:self.bundle];
        }
    }
}


/**
 Returns the first file path that exists in given directory
 */
- (NSString *)lookupFilePathInDirectory:(NSString *)directory
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for (NSString *fileName in self.filenames) {
        NSString *path = [directory stringByAppendingPathComponent:[fileName stringByAppendingPathExtension:self.fileExtension]];
        if ([fm fileExistsAtPath:path]) {
            return path;
        }
    }
    
    return nil;
}


/**
 Returns the first file path that exists in given bundle
 */
- (NSString *)lookupFilePathInBundle:(NSBundle *)bundle
{
    NSFileManager *fm = [NSFileManager defaultManager];
    
    for (NSString *fileName in self.filenames) {
        NSString *path = [bundle pathForResource:fileName ofType:self.fileExtension];
        if ([fm fileExistsAtPath:path]) {
            return path;
        }
    }
    
    return nil;
}




@end

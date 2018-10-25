//
//  APPSIBDesignableLogger.m
//
//  Created by Sohail Ahmed on 2/13/16.
//

#import "APPSIBDesignableLogger.h"
#import "TargetConditionals.h" 
#import "APPSBuildConfiguration.h"


@implementation APPSIBDesignableLogger

#pragma mark - Initialization

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.logFilePath = kAPPSIBDesignableLogger_DefaultLogFilePath;
    }
    
    return self;
}


/**
 DO NOT USE THIS IN SHIPPING CODE. IT ONLY WORKS IF YOU ARE NOT RUNNING ON DEVICE. IT WILL LOG
 TO YOUR MAC'S TMP DIRECTORY, A FILE THAT YOU CAN TAIL.
 
 Courtesy of:
 1. http://justabeech.com/2014/08/05/debugging-xcode-live-rendering/
 2. http://stackoverflow.com/questions/11106584/appending-to-the-end-of-a-file-with-nsmutablestring
 3. http://stackoverflow.com/questions/1058736/how-to-create-a-nsstring-from-a-format-string-like-xxx-yyy-and-a-nsarr
 
 @param format The message to be logged. Optionally, pass in a variable list of arguments thereafter.
*/
- (void)log:(NSString *)format, ...
{
     // NOTE: We will only live log to the computer's file system if we're dealing with a debug build.
     if (![APPSBuildConfiguration isDevelopmentBuild]) { return; }
     
     // #if !(TARGET_OS_IPHONE)
     NSFileManager *defaultManager = [NSFileManager defaultManager];
     
     if (![defaultManager fileExistsAtPath:self.logFilePath]) {
         [defaultManager createFileAtPath:self.logFilePath contents:[[NSData alloc] init] attributes:nil];
     }
     
     NSString *message;
     
     va_list args;
     va_start(args, format);
     message = [[NSString alloc] initWithFormat:format arguments:args];
     va_end(args);
     
     NSDate *date = [NSDate date];
     if (!self.componentName) { self.componentName = @"Unspecified"; }
     NSString *logMessage = [NSString stringWithFormat:@"%@ [%@]: %@\n", date, self.componentName, message];
     
     NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:self.logFilePath];
     [fileHandle seekToEndOfFile];
     [fileHandle writeData:[logMessage dataUsingEncoding:NSUTF8StringEncoding]];
     [fileHandle closeFile];
     // #endif
}


@end

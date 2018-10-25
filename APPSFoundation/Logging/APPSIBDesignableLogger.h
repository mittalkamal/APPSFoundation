//
//  APPSIBDesignableLogger.h
//
//  Created by Sohail Ahmed on 2/13/16.
//

#import <Foundation/Foundation.h>

#pragma mark - Content

/**
 This is the default (path and filename) that we'll append to when logging. You can use a different
 path by setting the property @c logFilePath.
 */
static NSString * const kAPPSIBDesignableLogger_DefaultLogFilePath = @"/tmp/XcodeLiveRendering.log";


/**
 Provides logging facilities for @c IBDesignable components that won't trigger normal @c NSLog()
 or similar logging statements to the console from Interface Builder live preview execution.
 
 Instantiate and cache an instance of this logger, giving it the name of your component, so we can
 prepend that to the log statements generated.
 */
@interface APPSIBDesignableLogger : NSObject

#pragma mark copy

/**
 Optional. If not set, we'll use the default path set in the constant @c.
 */
@property (copy, nonatomic) NSString *logFilePath;


/**
 Optional. The name of the component that we are logging on behalf of. It is recommended
 that you use the name of the class, by setting this from your component to 
 [[self class] description].
 */
@property (copy, nonatomic) NSString *componentName;


#pragma mark - Logging

- (void)log:(NSString *)format, ...;


@end

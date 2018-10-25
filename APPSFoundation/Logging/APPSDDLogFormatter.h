//
//  APPSDDLogFormatter.h
//
//  Created by Sohail Ahmed on 5/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

@import Foundation;
@import CocoaLumberjack;

/**
 Inspired by custom log formatter by Peter Steinberger at http://petersteinberger.com/2010/09/custom-formatter-for-the-cocoalumberjack-logging-framework/
 For use with the Cocoa Lumberjack logging framework project.
 
 NOTE:
 This is for *DEVELOPMENT USE* ONLY b/c we do the very expensive thing of creating a date formatter everytime we log.
 This is to get around the issue (bug?) whereby at runtime, repeated use of a date formatter instance leads to the occasional mis-formatted date string.
 */
@interface APPSDDLogFormatter : NSObject <DDLogFormatter>

#pragma mark - Protocol: DDLogFormatter
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage;

@end

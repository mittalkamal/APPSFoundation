//
//  APPSDDLogFormatter.m
//
//  Created by Sohail Ahmed on 5/8/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import "APPSDDLogFormatter.h"

@implementation APPSDDLogFormatter

/**
 Since NSDateFormatter is not thread safe, prior to retrieving it this way, we'd get the occasional formatting issue
 in the date. Now, we always get consistent results.
 
 CREDIT: Jesse G writing in the context of the Dropbox API: http://forums.dropbox.com/topic.php?id=23784
 */
+ (NSDateFormatter*)dateFormatter {
    NSMutableDictionary *dictionary = [[NSThread currentThread] threadDictionary];
    NSDateFormatter *dateFormatter = [dictionary objectForKey:@"APPSDDDevelopmentOnlyLogFormatter"];
    
    // Do we not have a date formatter on this thread?
    if (!dateFormatter) {
        // Affirmative. We need to create one for this thread.
        dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"EEE, dd MMM yyyy HH:mm:ss Z";
        [dictionary setObject:dateFormatter forKey:@"APPSDDDevelopmentOnlyLogFormatter"];
    }
    
    return dateFormatter;
}


/**
 This is the heart of this formatter class, where we specify the message format we'd like.
 */
- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {
    NSString *logLevel;
    switch (logMessage.flag) {
        case DDLogFlagError:
            logLevel = @"ERROR:";
            break;
        case DDLogFlagWarning:
            logLevel = @" WARN:";
            break;
        case DDLogFlagInfo:
            logLevel = @" INFO:";
            break;
        default:
            logLevel = @"DEBUG:";
            break;
    }
    
    if (!logMessage || !logMessage.threadID || !logLevel || !logMessage.fileName || !logMessage.function || !logMessage.message) {
        return @"Logging framework had unexpected nil value in log message component. Skipping this log message";
    }
    
    NSString *dateAndTime = [[APPSDDLogFormatter dateFormatter] stringFromDate:(logMessage.timestamp)];

    
    NSString *actualLoggedMessage = [NSString stringWithFormat:@"%@(%@) %@ [%@ (%lu)] %@",
                                     dateAndTime,
                                     [logMessage threadID],
                                     logLevel,
                                     [logMessage function],
                                     (unsigned long)logMessage.line, logMessage.message];
    
    return actualLoggedMessage;
}


@end

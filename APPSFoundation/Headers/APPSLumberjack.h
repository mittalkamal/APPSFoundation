//
//  APPSLumberjack.h
//
//  Created by Sohail Ahmed on 5/7/14.
//  Copyright (c) 2014 Appstronomy, LLC. All rights reserved.
//

#import <CocoaLumberjack/CocoaLumberjack.h>
#import "APPSDDLogLevel.h"

/**
 This is the Appstronomy specific Lumberjack import and configuration file.
 */

// ========================= OVERRIDES ========================================
// --> per https://github.com/robbiehanson/CocoaLumberjack/wiki/CustomLogLevels
// ----------------------------------------------------------------------------

// Are we in an optimized (i.e. Release) build?
#ifdef __OPTIMIZE__
// YES: Nothing to do from the default. (You could simplify this by using #ifndef above instead)
#else
// NO: We're in a Debug build. As such, let's configure logging to flush right away.
// Undefine the asynchronous defaults:
#undef LOG_ASYNC_VERBOSE
#undef LOG_ASYNC_INFO
#undef LOG_ASYNC_WARN

// Now define the logs levels to be synchronous:
#define LOG_ASYNC_VERBOSE   (NO && LOG_ASYNC_ENABLED)   // Debug logging will be synchronous
#define LOG_ASYNC_INFO      (NO && LOG_ASYNC_ENABLED)   // Info logging will be synchronous
#define LOG_ASYNC_WARN      (NO && LOG_ASYNC_ENABLED)   // Warn logging will be synchronous
#endif


// ================================ MACROS ====================================

// Logging Functions
#define logDebug   DDLogVerbose    // This is so verbose as to always be local
#define logInfo    DDLogInfo
#define logWarn    DDLogWarn
#define logError   DDLogError


// ================================ DEFAULT ====================================

// static int ddLogLevel = LOG_LEVEL_DEBUG;

// Allows us to remove the necessity for the static int 'ddLogLevel' in each
// class that wanted to use the logging.
#undef  LOG_LEVEL_DEF
#define LOG_LEVEL_DEF [APPSDDLogLevel ddLogLevel]


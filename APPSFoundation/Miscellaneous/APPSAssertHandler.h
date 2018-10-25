//
//  APPSAssertHandler.h
//
//  Created by Sohail Ahmed on 7/14/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Protocols

@protocol APPSAssertionAnalytics <NSObject>

@optional
- (void)trackAssertionFailureWithExpression:(NSString *)expression
                                   function:(NSString *)function
                                       file:(NSString *)file
                                       line:(NSInteger)line
                                description:(NSString *)format
                                  willCrash:(BOOL)willCrash;

- (NSString *)assertionProfileIdentifier;

@end



#pragma mark - Typedefs

typedef void(^APPSAssertReturnBlock)(NSError *);



#pragma mark - Constants

extern NSString *const APPSAssertErrorDomain;
extern NSString *const APPSAssertExceptionName;



#pragma mark - Assertion Macros

/**
 This variation of an assertion WILL ABORT (i.e. CRASH) regardless of whether being run in production or not.
 Use this when you'd rather crash in production (App Store build) than continue with a failed assertion.
 */
#define APPSAssertHardFail(condition, desc, ...) \
    do { \
        if (!(condition)) { \
            [[APPSAssertHandler handler] assertFailureWithExpression:[NSString stringWithUTF8String:#condition] \
            function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
            file:[NSString stringWithUTF8String:__FILE__] \
            line:__LINE__ \
            description:(desc), ##__VA_ARGS__]; \
        } \
    } while(0)


/**
 This variation of an assertion will not abort in production (App Store) use.
 Use this when you'd rather silently fail (log the error) in production for a failed assertion.
 This will still crash in development (APPSBuildConfigurationType_Development) 
 and beta (APPSBuildConfigurationType_AdHoc) builds.
 */
#define APPSAssertSoftFail(condition, desc, ...) \
    do { \
        if (!(condition)) { \
            [[APPSAssertHandler handler] assertFailureOrReturnWithExpression:[NSString stringWithUTF8String:#condition] \
            function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
            file:[NSString stringWithUTF8String:__FILE__] \
            line:__LINE__ \
            description:(desc), ##__VA_ARGS__]; \
        } \
    } while(0)


/**
 Effectively, this is an alias for @c APPSAssertHardFail.
 
 This variation of an assertion WILL ABORT (i.e. CRASH) regardless of whether being run in 
 production or not.
 
 Use this when you'd rather crash in production (App Store build) than continue with a 
 failed assertion.
 */
#define APPSAssert(condition, desc, ...) \
    do { \
        if (!(condition)) { \
            [[APPSAssertHandler handler] assertFailureWithExpression:[NSString stringWithUTF8String:#condition] \
            function:[NSString stringWithUTF8String:__PRETTY_FUNCTION__] \
            file:[NSString stringWithUTF8String:__FILE__] \
            line:__LINE__ \
            description:(desc), ##__VA_ARGS__]; \
        } \
    } while(0)



/**
 This assertion handler code was seeded by the popular FCYAsserts project: https://github.com/fcy/FCYAsserts
 by Felipe Cypriano.
 
 We have begun to modify it to tightly integrate with our analytics tracking class @c APPSAnalytics, 
 for when assertions fail, as well as with our build configuration class @c APPSBuildConfiguration, 
 to know @em when to actually raise an exception (i.e. crash).
 
 Over time, we will remove pieces we tend not to use, and modify the class to more closely suit the Appstronomy style.
 
 For release builds where you do NOT want to crash upon a failed assertion, use the method with variant
 @c -assertFailureOrReturnWithExpression:... instead of the method with variant @c -assertFailureWithExpression:...
 
 @see APPSImports+Macros.h where we define simple macros to use, like @c APPSAssertHardFail and @c APPSAssert.
 
 === Whether to Crash ===
 
 We no longer tie into NS_BLOCK_ASSERTIONS nor the formal Xcode 7+ build setting, 'Enable Foundation Assertions'. 
 Instead, we consult the @c APPSBuildConfiguration, and if it tells that we are @em not running in an App Store
 configuration, we allow a crash (i.e. raise an exception which causes the app to abort).
 
 This is why it is imperative for your host application to properly initialize the shared instance of 
 @c APPSBuildConfiguration on app launch. That said, you can always obtain the shared instance of this class 
 and manually set the property @c shouldRaiseWhenConditionFail so that you either do or do not cause a crash
 on assertion failure; explicitly taking over the logic and responsibility of whether or not to abort.
 
 Generally, you want assertions to fail everywhere but in production (the App Store).
 
 Of course, there are times where even in production, crashing the app on a failed assertion is the right thing to do.
 Perhaps a critical data integrity issue would be introduced if you @em didn't crash the app. In such cases, the assertion
 code you write should use the macro @c APPSAssertHardFail() in order to force a crash, regardless of configuration.
 
 Generally speaking however, you'll want to use the macro @c APPSAssert() which will @em not crash when using a Release
 configuration (i.e. a build for the App Store).
 */
@interface APPSAssertHandler : NSObject

#pragma mark scalar

/**
 When consulted, this property will tell us not to crash when an assertion fails.
 Normally, this is consulted on every type of assertion failure, except those
 from an explicit call to @c APPSAssertHardFail().
 */
@property (nonatomic) BOOL shouldRaiseWhenConditionFail;


/**
 Specify an object to be notified when an assertion is fired.
 */
@property (nonatomic, nullable) id <APPSAssertionAnalytics> analytics;



#pragma mark - Shared Instance

/**
 Retrieves our shared instance.
 
 @return A shared instance.
 */
@property (class, readonly, strong) APPSAssertHandler *handler;



#pragma mark - Assertion Methods

/**
 Makes an assertion, but @em ignores the value of NS_BLOCK_ASSERTIONS, via the host project's 'Enable Foundation Assertions'
 build setting. That is, if this assertion fails, your app will crash, even in Release configurations sent to the App Store.
 
 @param expression      The expression to evaluate for true (assertion passes) or false (assertion fails).
 @param function        The name of the function in which the assertion is taking place.
 @param file            The name of the file (in code) in which the assertion is taking place.
 @param line            The line number in the file (in code) in which the assertion is taking place.
 @param format          The optional description (with formatting arguments) put in by the assertion writer,
                        describing a failure, when that occures. This will be part of the log generated too.
 */
- (void)assertFailureWithExpression:(NSString *)expression
                           function:(NSString *)function
                               file:(NSString *)file
                               line:(NSInteger)line
                        description:(NSString *)format, ... NS_FORMAT_FUNCTION(5, 6) __attribute__((analyzer_noreturn));

/**
 Same as above but with va_list for Swift compatibility.
 http://stackoverflow.com/questions/31442873/swift-doesnt-see-objective-c-methods-with-variable-arguments
 */
- (void)assertFailureWithExpression:(NSString *)expression
                           function:(NSString *)function
                               file:(NSString *)file
                               line:(NSInteger)line
                        description:(NSString *)format
                          arguments:(va_list)args __attribute__((analyzer_noreturn));


/**
 Makes an assertion, but respects the value of NS_BLOCK_ASSERTIONS, via the host project's 'Enable Foundation Assertions'
 build setting.
 
 @param expression      The expression to evaluate for true (assertion passes) or false (assertion fails).
 @param function        The name of the function in which the assertion is taking place.
 @param file            The name of the file (in code) in which the assertion is taking place.
 @param line            The line number in the file (in code) in which the assertion is taking place.
 @param format          The optional description (with formatting arguments) put in by the assertion writer,
                        describing a failure, when that occures. This will be part of the log generated too.
 */
- (void)assertFailureOrReturnWithExpression:(NSString *)expression
                                   function:(NSString *)function
                                       file:(NSString *)file
                                       line:(NSInteger)line
                                description:(NSString *)format, ... NS_FORMAT_FUNCTION(5, 6);

/**
 Same as above but with va_list for Swift compatibility.
 http://stackoverflow.com/questions/31442873/swift-doesnt-see-objective-c-methods-with-variable-arguments
 */
- (void)assertFailureOrReturnWithExpression:(NSString *)expression
                                   function:(NSString *)function
                                       file:(NSString *)file
                                       line:(NSInteger)line
                                description:(NSString *)format
                                  arguments:(va_list)args;


/**
 Makes an assertion, but respects the value of NS_BLOCK_ASSERTIONS, via the host project's 'Enable Foundation Assertions'
 build setting. Notably, we take a callback block for when errors occur, but this is ONLY invoked if we're configured
 to @em not hard crash on failure.
 
 @param returnBlock     A block that takes an error. A failed assertion will call this block in the case of a failure.
                        You can use that as a callback to handle bad conditions, perform additional logging etc.
                        The failure gets put into the @c NSError that is passed to your block.
 @param expression      The expression to evaluate for true (assertion passes) or false (assertion fails).
 @param function        The name of the function in which the assertion is taking place.
 @param file            The name of the file (in code) in which the assertion is taking place.
 @param line            The line number in the file (in code) in which the assertion is taking place.
 @param description     The optional description, without any formatting arguments.
 */
- (void)assertFailureOrReturnBlock:(APPSAssertReturnBlock)returnBlock
                    withExpression:(NSString *)expression
                          function:(NSString *)function
                              file:(NSString *)file
                              line:(NSInteger)line
                       description:(NSString *)description;


@end

NS_ASSUME_NONNULL_END

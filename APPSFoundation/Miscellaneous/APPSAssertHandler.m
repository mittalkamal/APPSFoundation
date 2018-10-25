//
//  APPSAssertHandler.m
//
//  Created by Sohail Ahmed on 7/14/15.
//

#import "APPSAssertHandler.h"
#import "NSObject+Appstronomy.h"
#import "APPSLumberjack.h"
#import "APPSBuildConfiguration.h"


// This assertion library should use Cocoa Lumberjack based logging, at the 'Error' level:
#ifndef APPSAssertLog
#define APPSAssertLog DDLogError
#endif

NSString *const APPSAssertErrorDomain = @"APPSAssert";
NSString *const APPSAssertExceptionName = @"APPSAssertException";

@interface APPSAssertHandler ()
@end


@implementation APPSAssertHandler

#pragma mark - Shared Instance

+ (APPSAssertHandler *)handler
{
    static APPSAssertHandler *sharedHandler;
    static dispatch_once_t token;
    
    dispatch_once(&token, ^{
        sharedHandler = [[APPSAssertHandler alloc] init];
    });
    
    return sharedHandler;
}



#pragma mark - Initialization

- (id)init
{
    self = [super init];
    
    if (self) {
        self.shouldRaiseWhenConditionFail = ![APPSBuildConfiguration isAppStoreBuild];
    }
    
    return self;
}



#pragma mark - Assertion Methods

- (void)assertFailureWithExpression:(NSString *)expression
                           function:(NSString *)function
                               file:(NSString *)file
                               line:(NSInteger)line
                        description:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    
    [self assertFailureWithExpression:expression
                             function:function
                                 file:file
                                 line:line
                          description:format
                            arguments:args];
    va_end(args);
}


- (void)assertFailureWithExpression:(NSString *)expression
                           function:(NSString *)function
                               file:(NSString *)file
                               line:(NSInteger)line
                        description:(NSString *)format
                               arguments:(va_list)args
{
    [self _assertFailureShouldAbort:YES
                     withExpression:expression
                           function:function
                               file:file
                               line:line
                        description:format
                          arguments:args];
}


- (void)assertFailureOrReturnWithExpression:(NSString *)expression
                                   function:(NSString *)function
                                       file:(NSString *)file
                                       line:(NSInteger)line
                                description:(NSString *)format, ... {
    va_list args;
    va_start(args, format);
    
    [self assertFailureOrReturnWithExpression:expression
                                     function:function
                                         file:file
                                         line:line
                                  description:format
                                    arguments:args];
    va_end(args);
}


- (void)assertFailureOrReturnWithExpression:(NSString *)expression
                                   function:(NSString *)function
                                       file:(NSString *)file
                                       line:(NSInteger)line
                                description:(NSString *)format
                                  arguments:(va_list)args;
{
    [self _assertFailureShouldAbort:self.shouldRaiseWhenConditionFail
                     withExpression:expression
                           function:function
                               file:file
                               line:line
                        description:format
                          arguments:args];
}

- (void)assertFailureOrReturnBlock:(APPSAssertReturnBlock)returnBlock
                    withExpression:(NSString *)expression
                          function:(NSString *)function
                              file:(NSString *)file
                              line:(NSInteger)line
                       description:(NSString *)description
{
    [self _assertFailureShouldAbort:self.shouldRaiseWhenConditionFail withExpression:expression function:function file:file line:line description:description arguments:NULL];
    
    NSError *error = [NSError errorWithDomain:APPSAssertErrorDomain
                                         code:0
                                     userInfo:@{ NSLocalizedDescriptionKey : description }];
    returnBlock(error);
}



#pragma mark - Private Methods

- (NSString *)_assertFailureShouldAbort:(BOOL)shouldAbort
                         withExpression:(NSString *)expression
                               function:(NSString *)function
                                   file:(NSString *)file
                                   line:(NSInteger)line
                            description:(NSString *)format
                              arguments:(va_list)args
{
    NSString *description = @"";
    
    if (format) {
        description = [[NSString alloc] initWithFormat:format arguments:args];
    }
    
    APPSAssertLog(@"%@: Assertion '%@' failed on line %@:%ld. %@", function, expression, file, (long) line, description);

    // Send the failed assertion event to our analytics service for tracking:
    if ([self.analytics respondsToSelector:@selector(trackAssertionFailureWithExpression:function:file:line:description:willCrash:)]) {
        [self.analytics trackAssertionFailureWithExpression:expression
                                                   function:function
                                                       file:file
                                                       line:line
                                                description:description
                                                  willCrash:shouldAbort];
    }

    // Should we abort by raising an exception?
    if (shouldAbort) {
        // YES: We will raise an exception in order to abort.
        NSString *reason = [NSString stringWithFormat:@"Assertion '%@' failed. %@", expression, description];

        // Add analytics id to assertion if available
        NSDictionary *userInfo = nil;
        if ([self.analytics respondsToSelector:@selector(assertionProfileIdentifier)]) {
            userInfo = @{ @"assertion_profile_id" : self.analytics.assertionProfileIdentifier };
        }

        [[NSException exceptionWithName:APPSAssertExceptionName reason:reason userInfo:userInfo] raise];
    }
    
    return [NSString stringWithFormat:@"%@: Assertion '%@' failed on line %@:%ld. %@",
            function, expression, file, (long) line, description];
}

@end


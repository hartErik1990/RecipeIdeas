//
//  CFMobile.h
//  CFMobile SDK
//
//  Copyright (c) 2017 Cloudflare, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CFLogLevel) {
    CFLogLevelDetail  = 0x1,
    CFLogLevelWarning = 0x3,
    CFLogLevelError   = 0x4,
    CFLogLevelNone    = 0xF
};

@interface CFMobile : NSObject

/**
 Initialization is the process of modifying your application in order to communicate with Cloudflare network.
 Initialize CFMobile SDK on the main thread at beginning of your application delegate callback.
 ```
 [CFMobile initialize:clientKey];
 ```
 @param clientKey - application client key
 */
+ (void)initialize:(NSString *)clientKey;

/**
 Initialization is the process of modifying your application in order to communicate with Cloudflare network.
 Initialize CFMobile SDK on the main thread at beginning of your application delegate callback.
 ```
 [CFMobile initialize:clientKey completionHandler:^{
    if ([CFMobile initialized]) {
        //CFMobile SDK is ON.
        BOOL accelerated = [CFMobile accelerated];
        ...
    } else {
        //CFMobile SDK is OFF. Change log settings for more details.
        ...
    }
 }];
 ```
 @param clientKey - application client key
 @param completionHandler - a block is run after CFMobile SDK is asynchronously initialized.
                            The callback is executed on a background thread.
 */
+ (void)initialize:(NSString *)clientKey completionHandler:(void (^)(void))completionHandler;

+ (BOOL)authenticated;

/**
 Returns a boolean indicating CF Mobile SDK is enabled and ready to accelerate your network requests.
 
 @return boolean - true if enabled
*/
+ (BOOL)initialized;

/**
 Returns a boolean indicating whether CFMobile SDK is currently accelerating your requests. You may
 configure whether or not CFMobile SDK is accelerated by adjusting the % accelerated slider through
 the portal (click the settings button for the app version on your app details page). If you plan
 to A / B test accelerated vs unaccelerated users, we recommend using the `accelerated` API in the
 callback function. Please note that `accelerated` is sticky meaning a user who is accelerated will
 remain accelerated until the % accelerated slider value is changed.
 
 @return boolean - true if accelerated
*/
+ (BOOL)accelerated;

/**
    Restarts routing requests to custom protocol handler if routing was explicitly stopped earlier.
 
    Note: Routing is automatically enabled when CFMobile SDK is initialized and this function should
    only be used if routing was explicitly disabled by calling `stopRouting` function.
 */
+ (void)restartRouting;

/**
    Stops routing requests to custom protocol handler.
 */
+ (void)stopRouting;

/**
 Set whether requests are accelerated through CFMobile SDK. If SDK is not initialized, acceleration
 will be off. This method should ONLY be called ONCE and should take place before SDK is initialized.
 Please note that setAcceleration will override portal acceleration settings. If SDK is not
 initialized, then setAcceleration will not take effect.
 ```
 BOOL shouldAccelerate = // Determine whether this device should be accelerated
 [CFMobile setAcceleration: shouldAccelerate];
 [CFMobile initialize:clientKey completionHandler:^ { ... }];
 ```
 @param shouldAccelerate - whether the session should be accelerated
 */
+ (void)setAcceleration:(BOOL)shouldAccelerate;

/**
 Return the current log level used by the SDK.
 
 @return NMLogLevel - logLevel
 */
+ (CFLogLevel)logLevel;

/**
    Sends the Key Performance Index (KPI) attributes to metrics endpoint.
 
    @param key
        NSString object representing KPI key.
    @param value
        NSString object representing KPI value.
 */
+ (void)reportKPIMetricWithKey:(NSString *)key andValue:(NSString *)value;

/**
 Set the log level used by the CF Mobile SDK.
 */
+ (void)setLogLevel:(CFLogLevel)logLevel;

#if DEBUG

// Stop routing requests requests to the client proxy.
+ (void)_stopRouting;

// Disable SSL acceleration.
+ (void)_disableSSLAcceleration;

// Whenever CProxy collects any metrics, this callback will be executed.
// Caveat is that this thread is not the UI thread.
+ (void)_setReportMetricsCallback:(void (^)(int, NSString *, int, NSString *, int, int, long long *, long long *, long long *))block;

/**
     Retrieves results of recent test run.
 
     @return NSDictionary - dictionary containing test results such as method count etc.
 */
+ (NSDictionary *)getTestResultsDictionary;

/**
     Retrieves API configuration currently used by SDK.
 
     @return NSDictionary - dictionary containing current API config.
 */
+ (NSDictionary *)getAPIConfigDictionary;
#endif

@end

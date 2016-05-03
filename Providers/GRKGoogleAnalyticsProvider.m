//
//  GRKGoogleAnalyticsProvider.m
//  GRKAnalytics
//
//  Created by Levi Brown on April, 25 2016.
//  Copyright (c) 2016 Levi Brown <mailto:levigroker@gmail.com>
//  This work is licensed under the Creative Commons Attribution 3.0
//  Unported License. To view a copy of this license, visit
//  http://creativecommons.org/licenses/by/3.0/ or send a letter to Creative
//  Commons, 444 Castro Street, Suite 900, Mountain View, California, 94041,
//  USA.
//
//  The above attribution and the included license must accompany any version
//  of the source code. Visible attribution in any binary distributable
//  including this work (or derivatives) is not required, but would be
//  appreciated.
//

#import "GRKGoogleAnalyticsProvider.h"

//#ifdef GRK_GOOGLEANALYTICS_EXISTS

static CGFloat const kGRKPurchaseAppleTax = 0.3f;

NSString * const kGRKUserEventCategory = @"User";
NSString * const kGRKEventUserAccountCreated = @"UserAccountCreated";
NSString * const kGRKEventUserLogin = @"UserLogin";
NSString * const kGRKUserEventLabelSuccess = @"Success";

NSString * const kGRKEventPurchaseFailure = @"PurchaseFailure";
NSString * const kGRKPurchaseEventDefaultCategory = @"In-App Store";

NSString * const kGRKGoogleAnalyticsProviderPropertyKeyDefaultCategory = @"default";

extern NSString *const kGAIScreenName;
extern NSString *const kGAIUserId;
extern NSString *const kGAIEventLabel;

NSUInteger const kGAIDispatchGood;

//Weak link to these mock classes so we can compile without the real thing, but the linker will prefer the real thing when available.
//See http://stackoverflow.com/a/32151697/397210

@protocol GAITracker<NSObject>
- (void)set:(NSString *)parameterName value:(NSString *)value;
- (void)send:(NSDictionary *)parameters;
@end

__attribute__((weak_import)) @interface GAIFields : NSObject
+ (NSString *)customDimensionForIndex:(NSUInteger)index;
+ (NSString *)customMetricForIndex:(NSUInteger)index;
@end

__attribute__((weak_import)) @interface GAIDictionaryBuilder : NSObject
- (GAIDictionaryBuilder *)setAll:(NSDictionary *)params;
- (NSMutableDictionary *)build;
+ (GAIDictionaryBuilder *)createScreenView;
+ (GAIDictionaryBuilder *)createEventWithCategory:(NSString *)category action:(NSString *)action label:(NSString *)label value:(NSNumber *)value;
+ (GAIDictionaryBuilder *)createExceptionWithDescription:(NSString *)description withFatal:(NSNumber *)fatal;
+ (GAIDictionaryBuilder *)createItemWithTransactionId:(NSString *)transactionId name:(NSString *)name sku:(NSString *)sku category:(NSString *)category price:(NSNumber *)price quantity:(NSNumber *)quantity currencyCode:(NSString *)currencyCode;
+ (GAIDictionaryBuilder *)createTimingWithCategory:(NSString *)category interval:(NSNumber *)intervalMillis name:(NSString *)name label:(NSString *)label;
+ (GAIDictionaryBuilder *)createTransactionWithId:(NSString *)transactionId affiliation:(NSString *)affiliation revenue:(NSNumber *)revenue tax:(NSNumber *)tax shipping:(NSNumber *)shipping currencyCode:(NSString *)currencyCode;
@end

__attribute__((weak_import)) @interface GAI : NSObject
@property(nonatomic, assign) id<GAITracker> defaultTracker;
@property(nonatomic, assign) BOOL optOut;
@property(nonatomic, assign) NSTimeInterval dispatchInterval;
@property(nonatomic, assign) BOOL trackUncaughtExceptions;
+ (GAI *)sharedInstance;
- (id<GAITracker>)trackerWithTrackingId:(NSString *)trackingId;
- (void)dispatch;
- (void)dispatchWithCompletionHandler:(void (^)(NSUInteger result))completionHandler;
@end

//#endif //GRK_GOOGLEANALYTICS_EXISTS

@interface GRKGoogleAnalyticsProvider ()

@property (nonatomic, strong) id <GAITracker>tracker;
@property(nonatomic, copy) void (^dispatchHandler)(NSUInteger result);

@end

@implementation GRKGoogleAnalyticsProvider

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    return [self initWithTrackingID:nil];
}

- (instancetype)initWithTrackingID:(nullable NSString *)trackingID
{
//#ifdef GRK_GOOGLEANALYTICS_EXISTS
    NSAssert([GAI class], @"Google Analytics SDK is not included");
    NSAssert([[GAI class] respondsToSelector:@selector(sharedInstance)], @"Google Analytics is not installed correctly.");
    
    if ((self = [super init]))
    {
        if (trackingID.length > 0)
        {
            _tracker = [[GAI sharedInstance] trackerWithTrackingId:trackingID];
        }
        else
        {
            _tracker = [[GAI sharedInstance] defaultTracker];
        }
        
        [self registerNotifications];
    }

//#else //GRK_GOOGLEANALYTICS_EXISTS
    self = [super init];
//#endif
    
    return self;
}

#pragma mark - Meta

- (void)setEnabled:(BOOL)enabled
{
    [[GAI sharedInstance] setOptOut:!enabled];
}

- (BOOL)enabled
{
    return [[GAI sharedInstance] optOut];
}

#pragma mark - Accessors

- (void)setDispatchInterval:(NSTimeInterval)dispatchInterval
{
    _dispatchInterval = dispatchInterval;
    [[GAI sharedInstance] setDispatchInterval:dispatchInterval];
}

//#ifdef GRK_GOOGLEANALYTICS_EXISTS

#pragma mark - User

#pragma mark User Identity

- (void)identifyUserWithID:(nullable NSString *)userID andEmailAddress:(nullable NSString *)email
{
    // The Google Analytics Terms of Service prohibit sending of any personally identifiable information (PII) to Google Analytics servers. For more information, please consult the Terms of Service.
    // https://developers.google.com/analytics/devguides/collection/ios/v3/customdimsmets#pii

    // However setting of a User ID is allowed as per https://developers.google.com/analytics/devguides/collection/ios/v3/user-id
    [self setUserProperty:kGAIUserId toValue:userID];
}

#pragma mark User Properties

- (void)setUserProperty:(NSString *)property toValue:(nullable id)value
{
    [self.tracker set:property value:value];
}

#pragma mark - Events

- (void)trackEvent:(NSString *)event
          category:(nullable NSString *)category
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    if (event.length > 0)
    {
        category = category.length > 0 ? category : kGRKGoogleAnalyticsProviderPropertyKeyDefaultCategory;
        
        NSString *label = nil;
        NSNumber *value = nil;
        [self extractLabel:&label andValue:&value fromProperties:properties];
        GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:category action:event label:label value:value];
        properties = [self eventPropertiesWithBuilder:builder properties:properties];

        [self queue:properties];
    }
}

#pragma mark Event Specific Cases

- (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                              success:(nullable NSNumber *)success
                           properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:kGRKUserEventCategory action:kGRKEventUserAccountCreated label:kGRKUserEventLabelSuccess value:success ? @YES : @NO];
    properties = [self eventPropertiesWithBuilder:builder properties:properties];
    
    [self queue:properties];
}

- (void)trackLoginWithMethod:(nullable NSString *)method
                     success:(nullable NSNumber *)success
                  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:kGRKUserEventCategory action:kGRKEventUserLogin label:kGRKUserEventLabelSuccess value:success ? @YES : @NO];
    properties = [self eventPropertiesWithBuilder:builder properties:properties];
    
    [self queue:properties];
}

- (void)trackPurchaseInCategory:(nullable NSString *)category
                          price:(nullable NSDecimalNumber *)price
                       currency:(nullable NSString *)currency
                        success:(nullable NSNumber *)success
                       itemName:(nullable NSString *)itemName
                       itemType:(nullable NSString *)itemType
                         itemID:(nullable NSString *)identifier
                     properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    NSString *affiliation = category ?: kGRKPurchaseEventDefaultCategory;
    NSNumber *value = nil;
    [self extractLabel:nil andValue:&value fromProperties:properties];
    NSNumber *quantity = value ?: @1;

    if (success)
    {
        NSString *transactionID = [[NSUUID UUID] UUIDString];

        double itemPrice = price ? [price doubleValue] : 0;
        NSNumber *shipping = @0;
        NSNumber *revenue = @(quantity.doubleValue * itemPrice);
        NSNumber *tax = @(revenue.doubleValue * kGRKPurchaseAppleTax);

        GAIDictionaryBuilder *transactionBuilder = [GAIDictionaryBuilder createTransactionWithId:transactionID
                                                                                     affiliation:affiliation
                                                                                         revenue:revenue
                                                                                             tax:tax
                                                                                        shipping:shipping
                                                                                    currencyCode:currency];
        NSDictionary *transactionPoperties = [self eventPropertiesWithBuilder:transactionBuilder properties:properties];
        [self queue:transactionPoperties];
        
        
        GAIDictionaryBuilder *itemBuilder = [GAIDictionaryBuilder createItemWithTransactionId:transactionID
                                                                                         name:itemName ?: @""
                                                                                          sku:identifier ?: @""
                                                                                     category:itemType ?: @""
                                                                                        price:@(itemPrice)
                                                                                     quantity:quantity
                                                                                 currencyCode:currency];
        NSDictionary *itemPoperties = [self eventPropertiesWithBuilder:itemBuilder properties:properties];
        [self queue:itemPoperties];
    }
    else
    {
        GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createEventWithCategory:affiliation action:kGRKEventPurchaseFailure label:identifier value:quantity];
        properties = [self eventPropertiesWithBuilder:builder properties:properties];
        
        [self queue:properties];
    }
}

- (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                      properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    if (name)
    {
        [self.tracker set:kGAIScreenName value:name];

        NSString *label = nil;
        if (identifier)
        {
            label = identifier;
        }
        else
        {
            [self extractLabel:&label andValue:nil fromProperties:properties];
        }

        GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createScreenView];
        if (label) {
            [builder setValue:label forKey:kGAIEventLabel];
        }
    
        properties = [self eventPropertiesWithBuilder:builder properties:properties];
        
        [self queue:properties];

    }
}

#pragma mark - Timing

- (void)trackTimingEvent:(NSString *)event
                category:(nullable NSString *)category
            timeInterval:(NSTimeInterval)timeInterval
              properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;
{
    if (event.length > 0)
    {
        category = category.length > 0 ? category : kGRKGoogleAnalyticsProviderPropertyKeyDefaultCategory;
        
        NSString *label = nil;
        [self extractLabel:&label andValue:nil fromProperties:properties];
        GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createTimingWithCategory:category interval:@((int)(timeInterval * 1000)) name:event label:label];
        properties = [self eventPropertiesWithBuilder:builder properties:properties];
        
        [self queue:properties];
    }
}

#pragma mark - Errors

- (void)trackError:(NSError *)error properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    if (error)
    {
        GAIDictionaryBuilder *builder = [GAIDictionaryBuilder createExceptionWithDescription:[error description] withFatal:@NO];
        properties = [self eventPropertiesWithBuilder:builder properties:properties];
        
        [self queue:properties];
    }
}

//#endif //GRK_GOOGLEANALYTICS_EXISTS

#pragma mark - Helpers

- (void)queue:(NSDictionary *)properies
{
    if (self.enabled && properies.count > 0)
    {
        [self.tracker send:properies];
    }
}

- (NSDictionary *)eventPropertiesWithBuilder:(GAIDictionaryBuilder *)builder properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    NSDictionary *customDimensions = [self extractCustomDimensionsFromProperties:properties];
    [builder setAll:customDimensions];

    NSDictionary *customMetrics = [self extractCustomMetricsFromProperties:properties];
    [builder setAll:customMetrics];
    
    NSMutableDictionary *retVal = [builder build];
    
    return  retVal;
}

- (NSDictionary *)extractCustomDimensionsFromProperties:(GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    NSMutableDictionary *retVal = [NSMutableDictionary dictionary];
    
    for (NSString *key in [properties allKeys])
    {
        NSUInteger index = [self.customDimensionKeys indexOfObject:key];
        if (index != NSNotFound)
        {
            NSString *propertyKey = [GAIFields customDimensionForIndex:index + 1];
            id value = properties[key];
            retVal[propertyKey] = value;
        }
    }
    
    return retVal;
}

- (NSDictionary *)extractCustomMetricsFromProperties:(GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    NSMutableDictionary *retVal = [NSMutableDictionary dictionary];
    
    for (NSString *key in [properties allKeys])
    {
        NSUInteger index = [self.customMetricKeys indexOfObject:key];
        if (index != NSNotFound)
        {
            NSString *propertyKey = [GAIFields customMetricForIndex:index + 1];
            id value = properties[key];
            retVal[propertyKey] = value;
        }
    }
    
    return retVal;
}

//Looks for a key:value pair whose value is an NSNumber and returns the key and value, if there's such a pair.
//In the existence of more than one such pair the results are undefined.
- (void)extractLabel:(NSString **)label andValue:(NSNumber **)value fromProperties:(GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    for (NSString *key in [properties allKeys])
    {
        id valueObj = properties[key];
        if ([valueObj isKindOfClass:NSNumber.class])
        {
            if (label) {
                *label = key;
            }
            
            if (value) {
                *value = (NSNumber *)valueObj;
            }
            return;
        }
    }
}

#pragma mark Notifications

- (void)registerNotifications
{
#if TARGET_OS_IPHONE
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidEnterBackgroundNotification:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillEnterForegroundNotification:) name:UIApplicationWillEnterForegroundNotification object:nil];
#else
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillTerminateNotification:) name:NSApplicationWillTerminateNotification object:nil];
#endif
}


#if TARGET_OS_IPHONE

- (void)appDidEnterBackgroundNotification:(NSNotification *)notification
{
    if (self.enabled)
    {
        [self sendHitsInBackground];
    }
}

// This method sends any queued hits when the app enters the background.
- (void)sendHitsInBackground
{
    __block BOOL taskExpired = NO;
    
    __block UIBackgroundTaskIdentifier taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        taskExpired = YES;
    }];
    
    if (taskId == UIBackgroundTaskInvalid)
    {
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    self.dispatchHandler = ^(NSUInteger result) {
        //Send hits until no hits are left, a dispatch error occurs, or the background task expires.
        if (result == kGAIDispatchGood && !taskExpired)
        {
            [[GAI sharedInstance] dispatchWithCompletionHandler:weakSelf.dispatchHandler];
        }
        else
        {
            [[UIApplication sharedApplication] endBackgroundTask:taskId];
        }
    };
    
    [[GAI sharedInstance] dispatchWithCompletionHandler:self.dispatchHandler];
}

- (void)appWillEnterForegroundNotification:(NSNotification *)notification
{
    //Restores the dispatch interval because dispatchWithCompletionHandler
    //has disabled automatic dispatching.
    [[GAI sharedInstance] setDispatchInterval:self.dispatchInterval];
}

#else
//Mac

- (void)appWillTerminateNotification:(NSNotification *)notification
{
    if (self.enabled)
    {
        //Flush events before the app quits
        [[GAI sharedInstance] dispatch];
    }
}

#endif

@end

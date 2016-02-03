//
//  GRKAnalytics.m
//  GRKAnalytics
//
//  Created by Levi Brown on January, 27 2016.
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

#import "GRKAnalytics.h"

@interface GRKAnalytics ()

@property (nonatomic,strong) NSMutableSet *providers;
@property (nonatomic,strong) NSMutableDictionary *superProperties;
@property (nonatomic,strong) NSMutableDictionary *eventsDictionary;
@property (nonatomic,assign) BOOL enabled;

@end

@implementation GRKAnalytics

#pragma mark - Lifecycle

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceQueue;
    static GRKAnalytics *gRKAnalytics = nil;
    
    dispatch_once(&onceQueue, ^{ gRKAnalytics = [[self alloc] init]; });
    return gRKAnalytics;
}

- (instancetype)init
{
    if ((self = [super init]))
    {
        _providers = [NSMutableSet set];
        _enabled = YES;
    }
    
    return self;
}

#pragma mark - Configuration

+ (void)setEnabled:(BOOL)enabled
{
    [[self sharedInstance] setEnabled:enabled];
}

+ (BOOL)enabled
{
    return [[self sharedInstance] enabled];
}

#pragma mark - Providers

+ (void)addProvider:(GRKAnalyticsProvider *)analyticsProvider
{
    [[self sharedInstance] addProvider:analyticsProvider];
}

+ (void)removeProvider:(GRKAnalyticsProvider *)analyticsProvider
{
    [[self sharedInstance] removeProvider:analyticsProvider];
}

+ (NSSet *)providers
{
    return [[self sharedInstance] providers];
}

#pragma mark - User

#pragma mark User Identity

+ (void)identifyUserWithID:(nullable NSString *)userID andEmailAddress:(nullable NSString *)email
{
    [[self sharedInstance] identifyUserWithID:userID andEmailAddress:email];
}

#pragma mark User Properties

+ (void)setUserProperty:(NSString *)property toValue:(nullable id)value
{
    [[self sharedInstance] setUserProperty:property toValue:value];
}

#pragma mark - Events

+ (void)trackEvent:(NSString *)event
{
    [self trackEvent:event customProperties:nil];
}

+ (void)trackEvent:(NSString *)event customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    [[self sharedInstance] trackEvent:event customProperties:customProperties];
}

#pragma mark Event Properties

+ (void)addEventSuperProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[self sharedInstance] addEventSuperProperties:properties];
}

+ (void)removeEventSuperProperty:(NSString *)key
{
    if (key)
    {
        [self removeEventSuperProperties:@[key]];
    }
}

+ (void)removeEventSuperProperties:(NSArray *)keys
{
    [[self sharedInstance] removeEventSuperProperties:keys];
}

#pragma mark Event Specific Cases

+ (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                              success:(nullable NSNumber *)success
                     customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    [[self sharedInstance] trackUserAccountCreatedMethod:method success:success customProperties:customProperties];
}

+ (void)trackLoginWithMethod:(nullable NSString *)method
                     success:(nullable NSNumber *)success
            customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    [[self sharedInstance] trackLoginWithMethod:method success:success customProperties:customProperties];
}

+ (void)trackPurchaseWithPrice:(nullable NSDecimalNumber *)price
                      currency:(nullable NSString *)currency
                       success:(nullable NSNumber *)success
                      itemName:(nullable NSString *)itemName
                      itemType:(nullable NSString *)itemType
                        itemID:(nullable NSString *)identifier
              customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    [[self sharedInstance] trackPurchaseWithPrice:price currency:currency success:success itemName:itemName itemType:itemType itemID:identifier customProperties:customProperties];
}

+ (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    [[self sharedInstance] trackContentViewWithName:name contentType:type contentID:identifier customProperties:customProperties];
}

#pragma mark - Timing

+ (void)trackTimeStart:(NSString *)event
{
    [[self sharedInstance] trackTimeStart:event];
}

+ (void)trackTimeEnd:(NSString *)event
{
    [self trackTimeEnd:event customProperties:nil];
}

+ (void)trackTimeEnd:(NSString *)event customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    [[self sharedInstance] trackTimeEnd:event customProperties:customProperties];
}

#pragma mark - Errors

+ (void)trackError:(NSError *)error
{
    [self trackError:error customProperties:nil];
}

+ (void)trackError:(NSError *)error customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    [[self sharedInstance] trackError:error customProperties:customProperties];
}

///////////////////////////////////////////////////////

#pragma mark - Implementation

#pragma mark - Providers

- (void)addProvider:(GRKAnalyticsProvider *)analyticsProvider
{
    if (analyticsProvider)
    {
        [self.providers addObject:analyticsProvider];
    }
}

- (void)removeProvider:(GRKAnalyticsProvider *)analyticsProvider
{
    if (analyticsProvider)
    {
        [self.providers removeObject:analyticsProvider];
    }
}

#pragma mark - User

#pragma mark User Identity

- (void)identifyUserWithID:(nullable NSString *)userID andEmailAddress:(nullable NSString *)email
{
    [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
        [provider identifyUserWithID:userID andEmailAddress:email];
    }];
}

#pragma mark User Properties

- (void)setUserProperty:(NSString *)property toValue:(nullable id)value
{
    if (property)
    {
        [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
            [provider setUserProperty:property toValue:value];
        }];
    }
}

#pragma mark - Events

- (void)trackEvent:(NSString *)event customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    if (event)
    {
        NSDictionary *properties = [self allPropertiesWithProperties:customProperties];
        [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
            [provider trackEvent:event properties:properties];
        }];
    }
}

#pragma mark Event Properties

- (void)addEventSuperProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    if (properties)
    {
        if (!self.superProperties)
        {
            self.superProperties = [NSMutableDictionary dictionary];
        }
        [self.superProperties addEntriesFromDictionary:properties];
    }
}

- (void)removeEventSuperProperties:(NSArray *)keys
{
    if (keys)
    {
        [self.superProperties removeObjectsForKeys:keys];
    }
}

#pragma mark Event Specific Cases

- (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                              success:(nullable NSNumber *)success
                     customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    NSDictionary *properties = [self allPropertiesWithProperties:customProperties];
    [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
        [provider trackUserAccountCreatedMethod:method success:success properties:properties];
    }];
}

- (void)trackLoginWithMethod:(nullable NSString *)method
                     success:(nullable NSNumber *)success
            customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    NSDictionary *properties = [self allPropertiesWithProperties:customProperties];
    [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
        [provider trackLoginWithMethod:method success:success properties:properties];
    }];
}

- (void)trackPurchaseWithPrice:(nullable NSDecimalNumber *)price
                      currency:(nullable NSString *)currency
                       success:(nullable NSNumber *)success
                      itemName:(nullable NSString *)itemName
                      itemType:(nullable NSString *)itemType
                        itemID:(nullable NSString *)identifier
              customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    NSDictionary *properties = [self allPropertiesWithProperties:customProperties];
    [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
        [provider trackPurchaseWithPrice:price currency:currency success:success itemName:itemName itemType:itemType itemID:identifier properties:properties];
    }];
}

- (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    NSDictionary *properties = [self allPropertiesWithProperties:customProperties];
    [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
        [provider trackContentViewWithName:name contentType:type contentID:identifier properties:properties];
    }];
}

#pragma mark - Timing

- (void)trackTimeStart:(NSString *)event
{
    if (event)
    {
        if (!self.eventsDictionary)
        {
            self.eventsDictionary = [NSMutableDictionary dictionary];
        }
        self.eventsDictionary[event] = [NSDate date];
    }
}

- (void)trackTimeEnd:(NSString *)event customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    NSDate *startDate = self.eventsDictionary[event];
    NSAssert(startDate, @"End timing event '%@' called without a corrosponding start timing event", event);

    if (startDate)
    {
        NSTimeInterval eventInterval = [[NSDate date] timeIntervalSinceDate:startDate];
        [self.eventsDictionary removeObjectForKey:event];
        
        NSDictionary *properties = [self allPropertiesWithProperties:customProperties];
        [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
            [provider trackTimingEvent:event timeInterval:eventInterval properties:properties];
        }];
    }
}

#pragma mark - Errors

- (void)trackError:(NSError *)error customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties
{
    if (error)
    {
        NSDictionary *properties = [self allPropertiesWithProperties:customProperties];
        [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
            [provider trackError:error properties:properties];
        }];
    }
}

#pragma mark - Helpers

- (void)doForEachProvider:(void(^)(GRKAnalyticsProvider *provider))providerBlock
{
    if (self.enabled && providerBlock)
    {
        for (GRKAnalyticsProvider *provider in self.providers) {
            providerBlock(provider);
        }
    }
}

- (NSDictionary *)allPropertiesWithProperties:(NSDictionary *)properties
{
    NSMutableDictionary *retVal = [NSMutableDictionary dictionaryWithDictionary:self.superProperties];
    if (properties)
    {
        [retVal addEntriesFromDictionary:properties];
    }
    
    return retVal;
}

@end

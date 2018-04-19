//
//  GRKAnalytics.m
//  GRKAnalytics
//
//  Created by Levi Brown on January, 27 2016.
//  Copyright (c) 2016-2017 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import "GRKAnalytics.h"

@interface GRKAnalytics ()

@property (nonatomic,strong) NSMutableSet *providers;
@property (nonatomic,strong) NSMutableDictionary *superProperties;
@property (nonatomic,strong) NSMutableDictionary *eventsDictionary;
@property (nonatomic,assign) BOOL enabled;
@property (nonatomic,assign) BOOL userIdentityEnabled;

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
		_userIdentityEnabled = NO;
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

+ (void)setUserIdentityEnabled:(BOOL)enabled;
{
	[[self sharedInstance] setUserIdentityEnabled:enabled];
}

+ (BOOL)userIdentityEnabled;
{
	return [[self sharedInstance] userIdentityEnabled];
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
    [self trackEvent:event category:nil properties:nil];
}

+ (void)trackEvent:(NSString *)event
          category:(nullable NSString *)category
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[self sharedInstance] trackEvent:event category:category properties:properties];
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

+ (void)trackAppBecameActive
{
	[self trackAppBecameActiveWithCategory:nil properties:nil];
}

+ (void)trackAppBecameActiveWithCategory:(nullable NSString *)category
							  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	[[self sharedInstance] trackAppBecameActiveWithCategory:category properties:properties];
}

+ (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                              success:(nullable NSNumber *)success
                           properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[self sharedInstance] trackUserAccountCreatedMethod:method success:success properties:properties];
}

+ (void)trackLoginWithMethod:(nullable NSString *)method
                     success:(nullable NSNumber *)success
                  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[self sharedInstance] trackLoginWithMethod:method success:success properties:properties];
}

+ (void)trackPurchaseInCategory:(nullable NSString *)category
                          price:(nullable NSDecimalNumber *)price
                       currency:(nullable NSString *)currency
                        success:(nullable NSNumber *)success
                       itemName:(nullable NSString *)itemName
                       itemType:(nullable NSString *)itemType
                         itemID:(nullable NSString *)itemID
                     properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[self sharedInstance] trackPurchaseInCategory:category price:price currency:currency success:success itemName:itemName itemType:itemType itemID:itemID properties:properties];
}

+ (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                      properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[self sharedInstance] trackContentViewWithName:name contentType:type contentID:identifier properties:properties];
}

#pragma mark - Timing

+ (void)trackTimeStart:(NSString *)event
{
    [[self sharedInstance] trackTimeStart:event];
}

+ (void)trackTimeEnd:(NSString *)event
{
    [self trackTimeEnd:event category:nil properties:nil];
}

+ (void)trackTimeEnd:(NSString *)event
            category:(nullable NSString *)category
          properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[self sharedInstance] trackTimeEnd:event category:category properties:properties];
}

#pragma mark - Errors

+ (void)trackError:(NSError *)error
{
    [self trackError:error properties:nil];
}

+ (void)trackError:(NSError *)error
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[self sharedInstance] trackError:error properties:properties];
}

///////////////////////////////////////////////////////

#pragma mark - Accessors

- (void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    for (GRKAnalyticsProvider *provider in self.providers) {
        provider.enabled = enabled;
    }
}

- (void)setUserIdentityEnabled:(BOOL)userIdentityEnabled
{
	if (!userIdentityEnabled) {
		[self identifyUserWithID:nil andEmailAddress:nil];
	}
	_userIdentityEnabled = userIdentityEnabled;
}

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
	if (self.userIdentityEnabled || (userID.length == 0 && email.length == 0)) {
		[self doForEachProvider:^(GRKAnalyticsProvider *provider) {
			[provider identifyUserWithID:userID andEmailAddress:email];
		}];
	}
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

- (void)trackEvent:(NSString *)event
          category:(nullable NSString *)category
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    if (event)
    {
        NSDictionary *allProperties = [self allPropertiesWithProperties:properties];
        [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
            [provider trackEvent:event category:category properties:allProperties];
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

- (void)trackAppBecameActiveWithCategory:(nullable NSString *)category
							  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	NSDictionary *allProperties = [self allPropertiesWithProperties:properties];
	[self doForEachProvider:^(GRKAnalyticsProvider *provider) {
		[provider trackAppBecameActiveWithCategory:category properties:allProperties];
	}];
}

- (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                              success:(nullable NSNumber *)success
                           properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    NSDictionary *allProperties = [self allPropertiesWithProperties:properties];
    [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
        [provider trackUserAccountCreatedMethod:method success:success properties:allProperties];
    }];
}

- (void)trackLoginWithMethod:(nullable NSString *)method
                     success:(nullable NSNumber *)success
                  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;
{
    NSDictionary *allProperties = [self allPropertiesWithProperties:properties];
    [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
        [provider trackLoginWithMethod:method success:success properties:allProperties];
    }];
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
    NSDictionary *allProperties = [self allPropertiesWithProperties:properties];
    [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
        [provider trackPurchaseInCategory:category price:price currency:currency success:success itemName:itemName itemType:itemType itemID:identifier properties:allProperties];
    }];
}

- (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                      properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    NSDictionary *allProperties = [self allPropertiesWithProperties:properties];
    [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
        [provider trackContentViewWithName:name contentType:type contentID:identifier properties:allProperties];
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

- (void)trackTimeEnd:(NSString *)event
            category:(nullable NSString *)category
          properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    NSDate *startDate = self.eventsDictionary[event];
    NSAssert(startDate, @"End timing event '%@' called without a corrosponding start timing event", event);

    if (startDate)
    {
        NSTimeInterval eventInterval = [[NSDate date] timeIntervalSinceDate:startDate];
        [self.eventsDictionary removeObjectForKey:event];
        
        NSDictionary *allProperties = [self allPropertiesWithProperties:properties];
        [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
            [provider trackTimingEvent:event category:category timeInterval:eventInterval properties:allProperties];
        }];
    }
}

#pragma mark - Errors

- (void)trackError:(NSError *)error
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    if (error)
    {
        NSDictionary *allProperties = [self allPropertiesWithProperties:properties];
        [self doForEachProvider:^(GRKAnalyticsProvider *provider) {
            [provider trackError:error properties:allProperties];
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

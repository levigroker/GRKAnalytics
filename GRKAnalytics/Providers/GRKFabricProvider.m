//
//  GRKFabricProvider.m
//  GRKAnalytics
//
//  Created by Levi Brown on January, 29 2016.
//  Copyright (c) 2016-2018 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import "GRKFabricProvider.h"

#ifdef GRK_ANALYTICS_ENABLED

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Crashlytics/Answers.h>

#endif //GRK_ANALYTICS_ENABLED

NS_ASSUME_NONNULL_BEGIN

@implementation GRKFabricProvider

- (instancetype)init
{
    return [self initWithKits:@[]];
}

- (instancetype)initWithKits:(GRK_GENERIC_NSARRAY(Class) *)kits
{
#ifdef GRK_ANALYTICS_ENABLED

    NSAssert([Fabric class], @"Fabric is not included");
    NSAssert([[Fabric class] respondsToSelector:@selector(sharedSDK)], @"Fabric not installed correctly.");
    
    NSAssert(kits.count, @"No kits were specified.");
    
    [Fabric with:kits];
    
#endif //GRK_ANALYTICS_ENABLED
    
    return [super init];
}

#ifdef GRK_ANALYTICS_ENABLED

#pragma mark - User

#pragma mark User Identity

- (void)identifyUserWithID:(nullable NSString *)userID andEmailAddress:(nullable NSString *)email
{
    if (userID)
    {
        [[Crashlytics sharedInstance] setUserIdentifier:userID];
    }
    
    if (email)
    {
        [[Crashlytics sharedInstance] setUserEmail:email];
    }
}

#pragma mark User Properties

- (void)setUserProperty:(NSString *)property toValue:(nullable id)value
{
    [[Crashlytics sharedInstance] setObjectValue:value forKey:property];
}

#pragma mark - Events

- (void)trackEvent:(NSString *)event
          category:(nullable NSString *)category
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    if (event.length > 0)
    {
        properties = properties ?: @{};
        
		if (category.length > 0 && !properties[self.categoryPropertyName])
        {
            GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
			mutableProperties[self.categoryPropertyName] = category;
            properties = mutableProperties;
        }
        
        [Answers logCustomEventWithName:event customAttributes:properties];
    }
}

#pragma mark Event Specific Cases

- (void)trackAppBecameActiveWithCategory:(nullable NSString *)category
							  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	[self trackEvent:kGRKAnalyticsProviderDefaultEventKeyAppBecameActive category:category properties:properties];
}

- (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                              success:(nullable NSNumber *)success
                           properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [Answers logSignUpWithMethod:method success:success customAttributes:properties];
}

- (void)trackLoginWithMethod:(nullable NSString *)method
                     success:(nullable NSNumber *)success
                  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [Answers logLoginWithMethod:method success:success customAttributes:properties];
}

- (void)trackPurchaseInCategory:(nullable NSString *)category
                          price:(nullable NSDecimalNumber *)price
                       currency:(nullable NSString *)currency
                        success:(nullable NSNumber *)success
                       itemName:(nullable NSString *)itemName
                       itemType:(nullable NSString *)itemType
                         itemID:(nullable NSString *)identifier
                     properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;
{
    properties = properties ?: @{};
    
    if (category.length > 0)
    {
        GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
		mutableProperties[self.categoryPropertyName] = category;
        properties = mutableProperties;
    }
    
    [Answers logPurchaseWithPrice:price currency:currency success:success itemName:itemName itemType:itemType itemId:identifier customAttributes:properties];
}

- (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                      properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [Answers logContentViewWithName:name contentType:type contentId:identifier customAttributes:properties];
}

#pragma mark - Errors

- (void)trackError:(NSError *)error properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[Crashlytics sharedInstance] recordError:error withAdditionalUserInfo:properties];
}

#endif //GRK_ANALYTICS_ENABLED

@end

NS_ASSUME_NONNULL_END

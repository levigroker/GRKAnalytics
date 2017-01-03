//
//  GRKFabricProvider.m
//  GRKAnalytics
//
//  Created by Levi Brown on January, 29 2016.
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

#import "GRKFabricProvider.h"

#ifdef GRK_ANALYTICS_ENABLED

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Crashlytics/Answers.h>

static NSString * const kGRKFabricProviderPropertyKeyCategory = @"Category";

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
        
        if (category.length > 0)
        {
            GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
            mutableProperties[kGRKFabricProviderPropertyKeyCategory] = category;
            properties = mutableProperties;
        }
        
        [Answers logCustomEventWithName:event customAttributes:properties];
    }
}

#pragma mark Event Specific Cases

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
        mutableProperties[kGRKFabricProviderPropertyKeyCategory] = category;
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

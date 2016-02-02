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

#ifdef GRK_FABRIC_EXISTS

#ifndef FABRIC_GENERIC
#define FABRIC_GENERIC

#if !__has_feature(nullability)
#define nonnull
#define nullable
#define _Nullable
#define _Nonnull
#endif

#ifndef NS_ASSUME_NONNULL_BEGIN
#define NS_ASSUME_NONNULL_BEGIN
#endif

#ifndef NS_ASSUME_NONNULL_END
#define NS_ASSUME_NONNULL_END
#endif

#if __has_feature(objc_generics)
#define CLS_GENERIC_NSARRAY(type) NSArray<type>
#define CLS_GENERIC_NSDICTIONARY(key_type,object_key) NSDictionary<key_type, object_key>
#else
#define CLS_GENERIC_NSARRAY(type) NSArray
#define CLS_GENERIC_NSDICTIONARY(key_type,object_key) NSDictionary
#endif

#if __has_feature(objc_generics)
#define ANS_GENERIC_NSARRAY(type) NSArray<type>
#define ANS_GENERIC_NSDICTIONARY(key_type,object_key) NSDictionary<key_type, object_key>
#else
#define ANS_GENERIC_NSARRAY(type) NSArray
#define ANS_GENERIC_NSDICTIONARY(key_type,object_key) NSDictionary
#endif

#endif

@interface Fabric : NSObject
+ (instancetype)with:(NSArray *)kits;
+ (instancetype)sharedSDK;
@end

@interface Crashlytics : NSObject
+ (Crashlytics *)sharedInstance;
- (void)setUserIdentifier:(NSString *)identifier;
- (void)setUserName:(NSString *)name;
- (void)setUserEmail:(NSString *)email;
- (void)setObjectValue:(id)value forKey:(NSString *)key;
- (void)recordError:(NSError *)error withAdditionalUserInfo:(nullable CLS_GENERIC_NSDICTIONARY(NSString *, id) *)userInfo;
@end

NS_ASSUME_NONNULL_BEGIN
@interface Answers : NSObject

+ (void)logSignUpWithMethod:(nullable NSString *)signUpMethodOrNil
                    success:(nullable NSNumber *)signUpSucceededOrNil
           customAttributes:(nullable ANS_GENERIC_NSDICTIONARY(NSString *, id) *)customAttributesOrNil;

+ (void)logLoginWithMethod:(nullable NSString *)loginMethodOrNil
                   success:(nullable NSNumber *)loginSucceededOrNil
          customAttributes:(nullable ANS_GENERIC_NSDICTIONARY(NSString *, id) *)customAttributesOrNil;

+ (void)logPurchaseWithPrice:(nullable NSDecimalNumber *)itemPriceOrNil
                    currency:(nullable NSString *)currencyOrNil
                     success:(nullable NSNumber *)purchaseSucceededOrNil
                    itemName:(nullable NSString *)itemNameOrNil
                    itemType:(nullable NSString *)itemTypeOrNil
                      itemId:(nullable NSString *)itemIdOrNil
            customAttributes:(nullable ANS_GENERIC_NSDICTIONARY(NSString *, id) *)customAttributesOrNil;

+ (void)logContentViewWithName:(nullable NSString *)contentNameOrNil
                   contentType:(nullable NSString *)contentTypeOrNil
                     contentId:(nullable NSString *)contentIdOrNil
              customAttributes:(nullable ANS_GENERIC_NSDICTIONARY(NSString *, id) *)customAttributesOrNil;

+ (void)logCustomEventWithName:(NSString *)eventName
              customAttributes:(nullable ANS_GENERIC_NSDICTIONARY(NSString *, id) *)customAttributesOrNil;

@end
NS_ASSUME_NONNULL_END

#endif //GRK_FABRIC_EXISTS

@implementation GRKFabricProvider

- (instancetype)init
{
    return [self initWithKits:@[]];
}

- (instancetype)initWithKits:(GRK_GENERIC_NSARRAY(Class) *)kits
{
#ifdef GRK_FABRIC_EXISTS
    NSAssert([Fabric class], @"Fabric is not included");
    NSAssert([[Fabric class] respondsToSelector:@selector(sharedSDK)], @"Fabric not installed correctly.");
    
    NSAssert(kits.count, @"No kits were specified.");
    
    [Fabric with:kits];
#endif //GRK_FABRIC_EXISTS
    
    return [super init];
}

#ifdef GRK_FABRIC_EXISTS

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

- (void)trackEvent:(NSString *)event properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    if (event.length > 0)
    {
        properties = properties ?: @{};
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

- (void)trackPurchaseWithPrice:(nullable NSDecimalNumber *)price
                      currency:(nullable NSString *)currency
                       success:(nullable NSNumber *)success
                      itemName:(nullable NSString *)itemName
                      itemType:(nullable NSString *)itemType
                        itemID:(nullable NSString *)identifier
                    properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [Answers logPurchaseWithPrice:price currency:currency success:success itemName:itemName itemType:itemType itemId:identifier customAttributes:properties];
}

- (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                      properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [Answers logContentViewWithName:name contentType:type contentId:identifier customAttributes:properties];
}

#pragma mark - Timing

- (void)trackTimingEvent:(NSString *)event timeInterval:(NSTimeInterval)timeInterval properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    NSAssert(properties[GRKAnalyticsEventKeyTimingLength], @"Timing event '%@' contains custom property which conflicts with internal key '%@'", event, GRKAnalyticsEventKeyTimingLength);
    
    NSMutableDictionary *mutableProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    mutableProperties[GRKAnalyticsEventKeyTimingLength] = @(timeInterval);
    
    [self trackEvent:event properties:mutableProperties];
}

#pragma mark - Errors

- (void)trackError:(NSError *)error properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    [[Crashlytics sharedInstance] recordError:error withAdditionalUserInfo:properties];
}

#endif //GRK_FABRIC_EXISTS

@end

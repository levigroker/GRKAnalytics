//
//  GRKAppCenterProvider.h
//  GRKAnalytics
//
//  Created by Levi Brown on March, 15 2019.
//  Copyright (c) 2019 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import <GRKAnalytics/GRKAnalyticsProvider.h>

NS_ASSUME_NONNULL_BEGIN

// App Open event
static NSString *const kGRKAppCenterAnalyticsEventAppOpen NS_SWIFT_NAME(AnalyticsEventAppOpen) = @"app_open";

// Login event
static NSString *const kGRKAppCenterAnalyticsEventLogin NS_SWIFT_NAME(AnalyticsEventLogin) = @"user_login";
// SignUp event
static NSString *const kGRKAppCenterAnalyticsEventSignUp NS_SWIFT_NAME(AnalyticsEventSignUp) = @"user_sign_up";
// Login/SignUp method property
static NSString *const kGRKAppCenterAnalyticsPropertySignUpMethod NS_SWIFT_NAME(AnalyticsPropertySignUpMethod) = @"sign_up_method";

// Purcahse event
static NSString *const kGRKAppCenterAnalyticsEventPurchase NS_SWIFT_NAME(AnalyticsEventPurchase) = @"purchase";
// Purchase properties
static NSString *const kGRKAppCenterAnalyticsPropertyPrice NS_SWIFT_NAME(AnalyticsPropertyPrice) = @"purchase_price";
static NSString *const kGRKAppCenterAnalyticsPropertyCurrency NS_SWIFT_NAME(AnalyticsPropertyCurrency) = @"purchase_currency";
static NSString *const kGRKAppCenterAnalyticsPropertyItemName NS_SWIFT_NAME(AnalyticsPropertyItemName) = @"purchase_item_name";
static NSString *const kGRKAppCenterAnalyticsPropertyItemType NS_SWIFT_NAME(AnalyticsPropertyItemType) = @"purchase_item_type";
static NSString *const kGRKAppCenterAnalyticsPropertyItemID NS_SWIFT_NAME(AnalyticsPropertyItemID) = @"purchase_item_id";

// Content View event
static NSString *const kGRKAppCenterAnalyticsEventContentView NS_SWIFT_NAME(AnalyticsEventContentView) = @"content_view";
// Content View properties
static NSString *const kGRKAppCenterAnalyticsPropertyContentName NS_SWIFT_NAME(AnalyticsPropertyItemID) = @"content_name";
static NSString *const kGRKAppCenterAnalyticsPropertyContentType NS_SWIFT_NAME(AnalyticsPropertyItemID) = @"content_type";
static NSString *const kGRKAppCenterAnalyticsPropertyContentID NS_SWIFT_NAME(AnalyticsPropertyItemID) = @"content_id";

@interface GRKAppCenterProvider : GRKAnalyticsProvider

@end

NS_ASSUME_NONNULL_END

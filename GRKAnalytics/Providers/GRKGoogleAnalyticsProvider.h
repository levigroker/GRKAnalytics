//
//  GRKGoogleAnalyticsProvider.h
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

#import "GRKAnalyticsProvider.h"
#import "GRKLanguageFeatures.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kGRKUserEventCategory;
extern NSString * const kGRKEventUserAccountCreated;
extern NSString * const kGRKEventUserLogin;
extern NSString * const kGRKUserEventLabelSuccess;

extern NSString * const kGRKEventPurchaseFailure;
extern NSString * const kGRKPurchaseEventDefaultCategory;

@interface GRKGoogleAnalyticsProvider : GRKAnalyticsProvider

/**
 * If this value is positive, tracking information will be automatically
 * dispatched every dispatchInterval seconds.
 *
 * By default, this is set to `120`, which indicates tracking information should
 * be dispatched automatically every 120 seconds.
 */
@property (nonatomic, assign) NSTimeInterval dispatchInterval;

/**
 * Initialize a provider for use with the Google Analytics system.
 * Typical usage would be something like `[GRKGoogleAnalyticsProvider alloc] initWithTrackingID:@"UA-xxxxx-y"]`
 * @see https://developers.google.com/analytics/devguides/collection/ios
 *
 * @param trackingID The tracking ID provided by Google Analytics which identifies this property. If `nil` the `[[GAI sharedInstance] defaultTracker]` will be used, and should be initialized prior to creating this provider.
 *
 * @return An initialized instance of the provider which can be passed to `GRKAnalytics addProvider:` class method. 
 */
- (instancetype)initWithTrackingID:(nullable NSString *)trackingID NS_DESIGNATED_INITIALIZER;

/**
 * This is overridden from `GRKAnalyticsProvider`.
 * Google Analytic events have four parameters, typically: Category, Action, Label, Value.
 * @param event The "Action" of the Google Event.
 * @param category The "Category" of the Google Event. If `nil` the default `kGRKGoogleAnalyticsProviderPropertyKeyDefaultCategory` category will be assumed.
 * @param properties Additional properties to associate with the event. This will find the first key:value pair in the given `properties` dictionary whose value is an NSNumber object, using the key as the "Label" and the value as the "Value". Additionally, properties whose keys match keys in `customDimensionKeys` or `customMetricKeys` will be associated appropriately. NOTE: Google Analytics does not provide a mechanism for associating arbitrary properties, so any unbound properties will be ignored.
 */
- (void)trackEvent:(NSString *)event
          category:(nullable NSString *)category
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * This is overridden from `GRKAnalyticsProvider`.
 * @param success If `YES` a Transaction and Item will be created and sent. If `NO` a generic `kGRKEventPurchaseFailure` event will be sent. 
 * @param properties Additional properties to associate with the event. This will find the first key:value pair in the given `properties` dictionary whose value is an NSNumber object, ignoring the key, the value will be used for the quantity of items in the purchase. The given price should be the individual item price. Additionally, properties whose keys match keys in `customDimensionKeys` or `customMetricKeys` will be associated appropriately. NOTE: Google Analytics does not provide a mechanism for associating arbitrary properties, so any unbound properties will be ignored.
 */
- (void)trackPurchaseInCategory:(nullable NSString *)category
                          price:(nullable NSDecimalNumber *)price
                       currency:(nullable NSString *)currency
                        success:(nullable NSNumber *)success
                       itemName:(nullable NSString *)itemName
                       itemType:(nullable NSString *)itemType
                         itemID:(nullable NSString *)identifier
                     properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * This is overridden from `GRKAnalyticsProvider`.
 * Creates a "Screen View"
 * @param name Used as the kGAIScreenName
 * @param properties Additional properties to associate with the event. This will find the first key:value pair in the given `properties` dictionary whose value is an NSNumber object, using the key as the "kGAIEventLabel", the value will be ignored. The given price should be the individual item price. Additionally, properties whose keys match keys in `customDimensionKeys` or `customMetricKeys` will be associated appropriately. NOTE: Google Analytics does not provide a mechanism for associating arbitrary properties, so any unbound properties will be ignored.
 */
- (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                      properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * Predefined custom dimension keys.
 * Configure this ordered set with keys to be used with event `properties` which are to be mapped to your custom dimensions.
 * For example, if this ordered set was configured as `@[@"my_dimension_c", @"my_dimension_a", @"my_dimension_b"]` and then within the `properties` dictionary of an tracking call you included one or more of these keys, as in `@{@"my_dimension_b" : @"Some String Value"}`, the event would be sent to Google with the custom dimension `[GAIFields customDimensionForIndex:3]` (NOTE: 1-based) with value `Some String Value`.
 * @see https://developers.google.com/analytics/devguides/collection/ios/v3/customdimsmets
 * @see https://support.google.com/analytics/answer/2709829?hl=en&ref_topic=2709827
 */
@property (nonatomic, strong) NSOrderedSet *customDimensionKeys;

/**
 * Predefined custom metrics keys.
 * Configure this ordered set with keys to be used with event `properties` which are to be mapped to your custom metrics.
 * For example, if this ordered set was configured as `@[@"my_metric_c", @"my_metric_a", @"my_metric_b"]` and then within the `properties` dictionary of an tracking call you included one or more of these keys, as in `@{@"my_metric_b" : @"Some String Value"}`, the event would be sent to Google with the custom metric `[GAIFields customMetricForIndex:3]` (NOTE: 1-based) with value `Some String Value`.
 * @see https://developers.google.com/analytics/devguides/collection/ios/v3/customdimsmets
 * @see https://support.google.com/analytics/answer/2709829?hl=en&ref_topic=2709827
 */
@property (nonatomic, strong) NSOrderedSet *customMetricKeys;

@end

NS_ASSUME_NONNULL_END

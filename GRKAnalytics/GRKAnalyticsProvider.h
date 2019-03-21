//
//  GRKAnalyticsProvider.h
//  GRKAnalytics
//
//  Created by Levi Brown on January, 29 2016.
//  Copyright (c) 2016-2018 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import <Foundation/Foundation.h>
#import "GRKLanguageFeatures.h"
@class GRKAnalyticsProvider;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kGRKAnalyticsProviderDefaultEventKeyAppBecameActive;
extern NSString * const kGRKAnalyticsProviderDefaultEventKeyError;

extern NSString * const kGRKAnalyticsProviderDefaultPropertyKeyCategory;
extern NSString * const kGRKAnalyticsProviderDefaultPropertyKeySuccess;
extern NSString * const kGRKAnalyticsProviderDefaultPropertyKeyUserEmail;

extern NSString * const GRKAnalyticsEventKeyEventDuration;

@protocol GRKAnalyticsProviderDelegate <NSObject>

@optional

- (NSString *)provider:(GRKAnalyticsProvider *)provider eventForEvent:(NSString *)key;
- (NSString *)provider:(GRKAnalyticsProvider *)provider propertyForProperty:(NSString *)key;

@end

@interface GRKAnalyticsProvider : NSObject

#pragma mark - Meta

/**
 Delegate which will be called to translate event names, parameter keys, etc.
 */
@property (nonatomic, weak) id<GRKAnalyticsProviderDelegate> delegate;

/**
 * Set the state of this provider's tracking.
 * While the `GRKAnalitics` implementation will adhere to its `enabled` setting by not delivering
events to the providers if disabled, this method allows the provider to take additional steps as needed to conform to the enabled/disabled state.
 * @param enabled If `YES`, the tracker should consider itself able to track and report analytics. If `NO` the tracker should immediately prevent all recording and reporting of every kind of event.
 */
- (void)setEnabled:(BOOL)enabled;

/**
 * @returns the enabled state of this tracker.
 */
- (BOOL)enabled;

/**
 The event name for errors tracked by `trackError:properties:`
 Defaults to `kGRKAnalyticsProviderDefaultEventKeyError`
 */
@property (nonatomic, nonnull, copy) NSString *errorEventName;

/**
 The property key to use for `category` information tracked by various API methods.
 Defaults to `kGRKAnalyticsProviderDefaultPropertyKeyCategory`
 */
@property (nonatomic, nonnull, copy) NSString *categoryPropertyName;

/**
 The property key to use for `success` information tracked by various API methods.
 Defaults to `kGRKAnalyticsProviderDefaultPropertyKeySuccess`
 */
@property (nonatomic, nonnull, copy) NSString *successPropertyName;

#pragma mark - User

#pragma mark User Identity

/**
 * Identify the user which will be associated with events.
 *
 * @param userID The identifier to associate with the user.
 * @param email  the email to associate with the user.
 */
- (void)identifyUserWithID:(nullable NSString *)userID andEmailAddress:(nullable NSString *)email;

#pragma mark User Properties

/**
 * Sets a user property to the given value.
 *
 * @param property The name of the user property.
 * @param value    The value to set to the user property.
 */
- (void)setUserProperty:(NSString *)property toValue:(nullable id)value;

#pragma mark - Events

/**
 * Track the given event, with custom properties.
 *
 * @param event      The unique event name to track.
 * @param category   The category of the event.
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackEvent:(NSString *)event
          category:(nullable NSString *)category
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

#pragma mark Event Specific Cases

/**
 * Track application becoming active.
 *
 * @param category   The category of the event.
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackAppBecameActiveWithCategory:(nullable NSString *)category
							  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * Track user account creation.
 *
 * @param method     The method by which a user logged in, e.g. Twitter or Digits.
 * @param success    Successful account creation?
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                              success:(nullable NSNumber *)success
                           properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * Track a user login.
 *
 * @param method     The method by which a user logged in, e.g. email, Twitter, Facebook, etc.
 * @param success    Successful login?
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackLoginWithMethod:(nullable NSString *)method
                     success:(nullable NSNumber *)success
                  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * Track a purchse.
 *
 * @param category   The category of the event.
 * @param price      The purchased item's price.
 * @param currency   The ISO4217 currency code. Example: USD
 * @param success    Successful purchse?
 * @param itemName   The human-readable form of the item's name.
 * @param itemType   The type, or genre of the item. Example: Song
 * @param itemID     The machine-readable, unique item identifier Example: SKU
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackPurchaseInCategory:(nullable NSString *)category
                          price:(nullable NSDecimalNumber *)price
                       currency:(nullable NSString *)currency
                        success:(nullable NSNumber *)success
                       itemName:(nullable NSString *)itemName
                       itemType:(nullable NSString *)itemType
                         itemID:(nullable NSString *)itemID
                     properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * Track a content view.
 *
 * @param name       The human-readable name for this piece of content.
 * @param type       The type of content viewed.
 * @param identifier The unique identifier for this piece of content.
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                      properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

#pragma mark - Timing

/**
 * Track a timing event.
 *
 * @param event        The name of the event.
 * @param category     The category of the event.
 * @param timeInterval The amount of time elapsed.
 * @param properties   A dictionary of all additional properties to associate with this event.
 */
- (void)trackTimingEvent:(NSString *)event
                category:(nullable NSString *)category
            timeInterval:(NSTimeInterval)timeInterval
              properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

#pragma mark - Errors

/**
 * Track a given error.
 *
 * @param error The error to track.
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackError:(NSError *)error
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

#pragma mark - Subclassing

/**
 * Queries the delegate, if any, to offer an alternative property key for the given property key.
 *
 * @param property The property key to check with the delegate about.
 * @return If a non-nil answer is available from the delegate, that answer will be returned, otherwise this returns the given property.
 */
- (nullable NSString *)delegatePropertyForProperty:(nullable NSString *)property;

/**
 * Queries the delegate, if any, to offer alternative property keys for the keys of the given property dictionary.
 *
 * @param properties The property dictionary whose keys are to be inspected (and possibly augmented) by the delegate.
 * @return A new dictionary, which, for each key in the given dictionary, if a non-nil answer is available from the delegate, that answer will be replace the original key, otherwise this the original property key is left intact.
 */
- (NSDictionary *)delegatePropertiesForProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * Queries the delegate, if any, to offer an alternative event key for the given event key.
 *
 * @param event The event key to check with the delegate about.
 * @return If a non-nil answer is available from the delegate, that answer will be returned, otherwise this returns the given event.
 */
- (nullable NSString *)delegateEventForEvent:(nullable NSString *)event;

#pragma mark - Helpers


/**
 <#Description#>

 @param string <#string description#>
 @param maxLength <#maxLength description#>
 @return <#return value description#>
 */
- (nullable NSString *)cropString:(nullable NSString *)string maxLength:(NSUInteger)maxLength;

@end

NS_ASSUME_NONNULL_END

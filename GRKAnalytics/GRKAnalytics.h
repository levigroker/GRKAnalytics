//
//  GRKAnalytics.h
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

#import <Foundation/Foundation.h>
#import "GRKAnalyticsProvider.h"
#import "GRKLanguageFeatures.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRKAnalytics : NSObject

#pragma mark - Configuration

/**
 * Enables or disables the collection of analytic information.
 *
 * @param enabled `YES` to enable collection of analytic information, `NO` to disable collection.
 */
+ (void)setEnabled:(BOOL)enabled;

/**
 * Is the collection of analytic information enabled?
 *
 * @return `YES` if collection of analytic information is enabled, `NO` if it is disabled.
 */
+ (BOOL)enabled;

/**
 * Enables or disables user identification.
 *
 * If enabled, calls to `identifyUserWithID:andEmailAddress:` will be passed to individual providers.
 * If disabled, `identifyUserWithID:andEmailAddress:` will not pass any information to providers, and the providers will be updated with `nil` values.
 *
 * The default value is `NO`
 *
 * NOTE: This has no impact on the usage of `setUserProperty:toValue:` or the properties sent along with other methods, so personally identifiable information may still be provided to providers and should be closely audited to ensure anonymity, as desired.
 *
 * @param enabled `YES` to enable user identification, `NO` to disable user identification.
 * @see `identifyUserWithID:andEmailAddress:`
 */
+ (void)setUserIdentityEnabled:(BOOL)enabled;

/**
 * Is user identification enabled?
 *
 * If enabled, calls to `identifyUserWithID:andEmailAddress:` will be passed to individual providers.
 * If disabled, `identifyUserWithID:andEmailAddress:` will not pass any information to providers.
 * NOTE: This has no impact on the usage of `setUserProperty:toValue:` or the properties sent along with other methods, so personally identifiable information may still be provided to providers and should be closely audited to ensure anonymity, as desired.
 *
 * @return `YES` if user identification is enabled, `NO` if it is disabled.
 * @see `identifyUserWithID:andEmailAddress:`
 */
+ (BOOL)userIdentityEnabled;

#pragma mark - Providers

+ (void)addProvider:(GRKAnalyticsProvider *)analyticsProvider;
+ (void)removeProvider:(GRKAnalyticsProvider *)analyticsProvider;
+ (NSSet *)providers;

#pragma mark - User

#pragma mark User Identity

/**
* Identify the user which will be associated with events.
*
* @param userID The identifier to associate with the user.
* @param email  the email to associate with the user.
*/
+ (void)identifyUserWithID:(nullable NSString *)userID andEmailAddress:(nullable NSString *)email;

#pragma mark User Properties

/**
 * Sets a user property to the given value.
 *
 * @param property The name of the user property.
 * @param value    The value to set to the user property.
 */
+ (void)setUserProperty:(NSString *)property toValue:(nullable id)value;

#pragma mark - Events

/**
 * Track the given event
 *
 * @param event The unique event name to track.
 */
+ (void)trackEvent:(NSString *)event;

/**
 * Track the given event, with custom properties.
 *
 * @param event      The unique event name to track.
 * @param category   The category of the event.
 * @param properties A dictionary of all additional properties to associate with this event.
 */
+ (void)trackEvent:(NSString *)event
          category:(nullable NSString *)category
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

#pragma mark Event Properties

/**
 * Adds super properties.
 * These are properties that are sent in addition to the event properties.
 *
 * @param properties The properties to add.
 */
+ (void)addEventSuperProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * Removes a super property from the super properties.
 *
 * @param key The key of the property to remove.
 */
+ (void)removeEventSuperProperty:(NSString *)key;

/**
 * Removes super properties from the super properties.
 *
 * @param keys The keys of the properties to remove.
 */
+ (void)removeEventSuperProperties:(NSArray *)keys;

#pragma mark Event Specific Cases

/**
 * Track application becoming active.
 * This is the same as calling `trackAppBecameActiveWithCategory:properties:` with `nil` parameters.
 * @see trackAppBecameActiveWithCategory:properties:
 */
+ (void)trackAppBecameActive;

/**
 * Track application becoming active.
 *
 * @param category   The category of the event.
 * @param properties A dictionary of all additional properties to associate with this event.
 */
+ (void)trackAppBecameActiveWithCategory:(nullable NSString *)category
							  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * Track user account creation.
 *
 * @param method     The method by which a user logged in, e.g. Twitter or Digits.
 * @param success    Successful account creation?
 * @param properties A dictionary of all additional properties to associate with this event.
 */
+ (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                              success:(nullable NSNumber *)success
                           properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

/**
 * Track a user login.
 *
 * @param method     The method by which a user logged in, e.g. email, Twitter, Facebook, etc.
 * @param success    Successful login?
 * @param properties A dictionary of all additional properties to associate with this event.
 */
+ (void)trackLoginWithMethod:(nullable NSString *)method
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
+ (void)trackPurchaseInCategory:(nullable NSString *)category
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
+ (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                      properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

#pragma mark - Timing

/**
 * Start tracking time elapsed for an event.
 *
 * @param event The unique event name.
 * @see trackTimeEnd:
 */
+ (void)trackTimeStart:(NSString *)event;

/**
 * Finish tracking time elapsed for the given event.
 *
 * @param event The unique event name of an event currently being tracked for time.
 */
+ (void)trackTimeEnd:(NSString *)event;

/**
 * Finish tracking time elapsed for the given event.
 *
 * @param event        The name of the event.
 * @param category     The category of the event.
 * @param properties   A dictionary of all additional properties to associate with this event.
 * @warning customProperties must not contain the key `length`.
 */
+ (void)trackTimeEnd:(NSString *)event
            category:(nullable NSString *)category
          properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

#pragma mark - Errors

/**
 * Track a given error.
 *
 * @param error The error to track.
 */
+ (void)trackError:(NSError *)error;

/**
 * Track a given error.
 *
 * @param error The error to track.
 * @param properties A dictionary of all additional properties to associate with this event.
 */
+ (void)trackError:(NSError *)error
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

@end

NS_ASSUME_NONNULL_END


//
//  GRKAnalytics.h
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
 * @param event            The unique event name to track.
 * @param customProperties A dictionary of custom properties to associate with this event.
 */
+ (void)trackEvent:(NSString *)event customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties;

#pragma mark Event Properties

/**
 * Adds super properties.
 * These are properties that are sent in addition to the event properties.
 *
 * @param superProperties The properties to add.
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
 * Track user account creation.
 *
 * @param method           The method by which a user logged in, e.g. Twitter or Digits.
 * @param success          Successful account creation?
 * @param customProperties A dictionary of custom properties to associate with this event.
 */
+ (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                    success:(nullable NSNumber *)success
           customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties;

/**
 * Track a user login.
 *
 * @param method           The method by which a user logged in, e.g. email, Twitter, Facebook, etc.
 * @param success          Successful login?
 * @param customProperties A dictionary of custom properties to associate with this login.
 */
+ (void)trackLoginWithMethod:(nullable NSString *)method
                   success:(nullable NSNumber *)success
          customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties;

/**
 * Track a purchse.
 *
 * @param price            The purchased item's price.
 * @param currency         The ISO4217 currency code. Example: USD
 * @param success          Successful purchse?
 * @param itemName         The human-readable form of the item's name.
 * @param itemType         The type, or genre of the item. Example: Song
 * @param itemId           The machine-readable, unique item identifier Example: SKU
 * @param customProperties A dictionary of custom properties to associate with this purchase.
 */
+ (void)trackPurchaseWithPrice:(nullable NSDecimalNumber *)price
                      currency:(nullable NSString *)currency
                       success:(nullable NSNumber *)success
                      itemName:(nullable NSString *)itemName
                      itemType:(nullable NSString *)itemType
                        itemID:(nullable NSString *)identifier
              customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties;

/**
 * Track a content view.
 *
 * @param name             The human-readable name for this piece of content.
 * @param type             The type of content viewed.
 * @param identifier       The unique identifier for this piece of content.
 * @param customProperties A dictionary of custom properties to associate with this content view.
 */
+ (void)trackContentViewWithName:(nullable NSString *)name
                   contentType:(nullable NSString *)type
                     contentID:(nullable NSString *)identifier
              customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties;

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
 * @param event            The unique event name.
 * @param customProperties A dictionary of custom properties to associate with this event.
 * @warning customProperties must not contain the key `length`.
 */
+ (void)trackTimeEnd:(NSString *)event customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties;

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
 * @param customProperties A dictionary of custom properties to associate with this error.
 */
+ (void)trackError:(NSError *)error customProperties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)customProperties;

@end

NS_ASSUME_NONNULL_END


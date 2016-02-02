//
//  GRKAnalyticsProvider.h
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

#import <Foundation/Foundation.h>
#import "GRKLanguageFeatures.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString *const GRKAnalyticsEventKeyTimingLength;

@interface GRKAnalyticsProvider : NSObject

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
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackEvent:(NSString *)event properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

#pragma mark Event Specific Cases

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
 * @param price      The purchased item's price.
 * @param currency   The ISO4217 currency code. Example: USD
 * @param success    Successful purchse?
 * @param itemName   The human-readable form of the item's name.
 * @param itemType   The type, or genre of the item. Example: Song
 * @param itemId     The machine-readable, unique item identifier Example: SKU
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackPurchaseWithPrice:(nullable NSDecimalNumber *)price
                      currency:(nullable NSString *)currency
                       success:(nullable NSNumber *)success
                      itemName:(nullable NSString *)itemName
                      itemType:(nullable NSString *)itemType
                        itemID:(nullable NSString *)identifier
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
 * @param timeInterval The amount of time elapsed.
 * @param properties   A dictionary of all additional properties to associate with this event.
 */
- (void)trackTimingEvent:(NSString *)event timeInterval:(NSTimeInterval)timeInterval properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

#pragma mark - Errors

/**
 * Track a given error.
 *
 * @param error The error to track.
 * @param properties A dictionary of all additional properties to associate with this event.
 */
- (void)trackError:(NSError *)error properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties;

@end

NS_ASSUME_NONNULL_END

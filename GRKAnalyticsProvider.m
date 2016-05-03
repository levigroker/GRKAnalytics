//
//  GRKAnalyticsProvider.m
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

#import "GRKAnalyticsProvider.h"

NSString *const GRKAnalyticsEventKeyTimingLength = @"length";

@interface GRKAnalyticsProvider ()

@property (nonatomic,assign) BOOL enabled;

@end

@implementation GRKAnalyticsProvider

#pragma mark - User

#pragma mark User Identity

- (void)identifyUserWithID:(nullable NSString *)userID andEmailAddress:(nullable NSString *)email
{
    //Not implemented at this level
}

#pragma mark User Properties

- (void)setUserProperty:(NSString *)property toValue:(nullable id)value
{
    //Not implemented at this level
}

- (void)incrementUserProperty:(NSString *)property byInteger:(NSInteger)amount
{
    //Not implemented at this level
}

#pragma mark - Events

- (void)trackEvent:(NSString *)event
          category:(nullable NSString *)category
        properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    //Not implemented at this level
}

#pragma mark Event Specific Cases

- (void)trackUserAccountCreatedMethod:(nullable NSString *)method
                              success:(nullable NSNumber *)success
                           properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    //Not implemented at this level
}

- (void)trackLoginWithMethod:(nullable NSString *)method
                     success:(nullable NSNumber *)success
                  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    //Not implemented at this level
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
    //Not implemented at this level
}

- (void)trackContentViewWithName:(nullable NSString *)name
                     contentType:(nullable NSString *)type
                       contentID:(nullable NSString *)identifier
                      properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    //Not implemented at this level
}

#pragma mark - Timing

- (void)trackTimingEvent:(NSString *)event
                category:(nullable NSString *)category
            timeInterval:(NSTimeInterval)timeInterval
              properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    NSAssert(!properties[GRKAnalyticsEventKeyTimingLength], @"Timing event '%@' contains custom property which conflicts with internal key '%@'", event, GRKAnalyticsEventKeyTimingLength);
    
    NSMutableDictionary *mutableProperties = [NSMutableDictionary dictionaryWithDictionary:properties];
    mutableProperties[GRKAnalyticsEventKeyTimingLength] = @(timeInterval);
    
    [self trackEvent:event category:category properties:mutableProperties];
}

#pragma mark - Errors

- (void)trackError:(NSError *)error properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
    //Not implemented at this level
}

@end

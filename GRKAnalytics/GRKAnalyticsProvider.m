//
//  GRKAnalyticsProvider.m
//  GRKAnalytics
//
//  Created by Levi Brown on January, 29 2016.
//  Copyright (c) 2016-2017 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import "GRKAnalyticsProvider.h"

NSString * const kGRKAnalyticsProviderDefaultEventKeyAppBecameActive = @"App Became Active";
NSString * const kGRKAnalyticsProviderDefaultEventKeyError = @"Error";

NSString * const kGRKAnalyticsProviderDefaultPropertyKeyCategory = @"Category";
NSString * const kGRKAnalyticsProviderDefaultPropertyKeySuccess = @"Success";


NSString *const GRKAnalyticsEventKeyTimingLength = @"length";

@interface GRKAnalyticsProvider ()

@property (nonatomic,assign) BOOL enabled;

@end

@implementation GRKAnalyticsProvider

#pragma mark - Accessors

- (NSString *)errorEventName
{
	if (!_errorEventName) {
		return kGRKAnalyticsProviderDefaultEventKeyError;
	}
	
	return _errorEventName;
}

- (NSString *)categoryPropertyName
{
	if (!_categoryPropertyName) {
		return kGRKAnalyticsProviderDefaultPropertyKeyCategory;
	}
	
	return _categoryPropertyName;
}

- (NSString *)successPropertyName
{
	if (!_successPropertyName) {
		return kGRKAnalyticsProviderDefaultPropertyKeySuccess;
	}
	
	return _successPropertyName;
}

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

- (void)trackAppBecameActiveWithCategory:(nullable NSString *)category
							  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	//Not implemented at this level
}

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
                         itemID:(nullable NSString *)itemID
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

#pragma mark - Subclassing

- (NSString *)delegatePropertyForProperty:(nullable NSString *)property
{
	NSString *retVal = property;
	
	if ([self.delegate respondsToSelector:@selector(provider:propertyForProperty:)]) {
		NSString *key = [self.delegate provider:self propertyForProperty:property];
		if (key) {
			retVal = key;
		}
	}
	
	return retVal;
}

- (NSDictionary *)delegatePropertiesForProperties:(nullable NSDictionary *)properties
{
	NSMutableDictionary *retVal = [NSMutableDictionary dictionaryWithDictionary:properties ?: @{}];
	
	if ([self.delegate respondsToSelector:@selector(provider:propertyForProperty:)]) {
		NSArray *keys = [retVal allKeys];
		for (NSString *key in keys) {
			NSString *delegateKey = [self.delegate provider:self propertyForProperty:key];
			if (delegateKey && ![delegateKey isEqualToString:key]) {
				retVal[delegateKey] = retVal[key];
				retVal[key] = nil;
			}
		}
	}
	
	return retVal;
}

- (NSString *)delegateEventForEvent:(NSString *)event
{
	NSString *retVal = event;
	
	if ([self.delegate respondsToSelector:@selector(provider:eventForEvent:)]) {
		NSString *key = [self.delegate provider:self eventForEvent:event];
		if (key) {
			retVal = key;
		}
	}
	
	return retVal;
}

@end

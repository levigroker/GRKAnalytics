//
//  GRKAppCenterProvider.m
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

#import "GRKAppCenterProvider.h"
#import <GRKAnalytics/GRKLanguageFeatures.h>

#ifdef GRK_ANALYTICS_ENABLED

#import <AppCenter/AppCenter.h>
#import <AppCenterAnalytics/AppCenterAnalytics.h>

#endif //GRK_ANALYTICS_ENABLED

NS_ASSUME_NONNULL_BEGIN

@implementation GRKAppCenterProvider

#ifdef GRK_ANALYTICS_ENABLED

- (void)setEnabled:(BOOL)enabled
{
	[super setEnabled:enabled];
	[MSAnalytics setEnabled:enabled];
	[MSCrashes setEnabled:enabled];
	// Disable *all* AppCenter services
	if (!enabled) {
		[MSAppCenter setEnabled:NO];
	}
}

- (BOOL)enabled
{
	BOOL enabled = 	MSAnalytics.isEnabled || MSCrashes.isEnabled;
	return enabled;
}

#pragma mark - User

#pragma mark User Identity

- (void)identifyUserWithID:(nullable NSString *)userID andEmailAddress:(nullable NSString *)email
{
	[MSAppCenter setUserId:userID];
}

#pragma mark User Properties

- (void)setUserProperty:(NSString *)property toValue:(nullable id)value
{
	property = [self delegatePropertyForProperty:property];
	property = [self sanitizeUserPropertyKey:property];
	
	if (property.length > 0) {
		
		// "A custom property's value may be one of the following types: NSString, NSNumber, BOOL and NSDate."
		// We only accept objects, so `BOOL` is not an option (use `NSNumber`).
		// If the object is not one of these types we treat it as a String.
		MSCustomProperties *msProperties = [[MSCustomProperties alloc] init];
		if (value) {
			if ([value isKindOfClass:NSNumber.class]) {
				[msProperties setNumber:value forKey:property];
			}
			else if ([value isKindOfClass:NSDate.class]) {
				[msProperties setDate:value forKey:property];
			}
			else {
				NSString *stringValue = nil;
				if ([value isKindOfClass:NSString.class]) {
					stringValue = value;
				}
				else {
					stringValue = [value description];
				}
				
				[msProperties setString:stringValue forKey:property];
			}
		}
		else {
			[msProperties clearPropertyForKey:property];
		}
	}
}

#pragma mark - Events

- (void)trackEvent:(NSString *)event
		  category:(nullable NSString *)category
		properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	event = [self delegateEventForEvent:event];

	// "There is a maximum limit of 256 characters per event name..."
	NSString *sanitizedEvent = [self sanitizeString:event maxLength:256];
	if (sanitizedEvent.length > 0) {
		properties = [self delegatePropertiesForProperties:properties];
		
		if (category.length > 0 && !properties[self.categoryPropertyName]) {
			GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
			mutableProperties[self.categoryPropertyName] = category;
			properties = mutableProperties;
		}

		MSEventProperties *sanitizedProperties = [self sanitizeProperties:properties];
		[MSAnalytics trackEvent:sanitizedEvent withTypedProperties:sanitizedProperties];
	}
}

#pragma mark Event Specific Cases

- (void)trackAppBecameActiveWithCategory:(nullable NSString *)category
							  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	[self trackEvent:kGRKAppCenterAnalyticsEventAppOpen category:category properties:properties];
}

- (void)trackUserAccountCreatedMethod:(nullable NSString *)method
							  success:(nullable NSNumber *)success
						   properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	properties = [self delegatePropertiesForProperties:properties];
	
	GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
	mutableProperties[kGRKAppCenterAnalyticsPropertySignUpMethod] = method;
	mutableProperties[self.successPropertyName] = success;

	[self trackEvent:kGRKAppCenterAnalyticsEventSignUp category:nil properties:mutableProperties];
}

- (void)trackLoginWithMethod:(nullable NSString *)method
					 success:(nullable NSNumber *)success
				  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	properties = [self delegatePropertiesForProperties:properties];
	
	GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
	mutableProperties[kGRKAppCenterAnalyticsPropertySignUpMethod] = method;
	mutableProperties[self.successPropertyName] = success;
	
	[self trackEvent:kGRKAppCenterAnalyticsEventLogin category:nil properties:mutableProperties];
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
	properties = [self delegatePropertiesForProperties:properties];
	
	GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
	mutableProperties[kGRKAppCenterAnalyticsPropertyPrice] = price;
	mutableProperties[kGRKAppCenterAnalyticsPropertyCurrency] = currency;
	mutableProperties[self.successPropertyName] = success;
	mutableProperties[kGRKAppCenterAnalyticsPropertyItemName] = itemName;
	mutableProperties[kGRKAppCenterAnalyticsPropertyItemType] = itemType;
	mutableProperties[kGRKAppCenterAnalyticsPropertyItemID] = identifier;

	[self trackEvent:kGRKAppCenterAnalyticsEventPurchase category:category properties:mutableProperties];
}

- (void)trackContentViewWithName:(nullable NSString *)name
					 contentType:(nullable NSString *)type
					   contentID:(nullable NSString *)identifier
					  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	properties = [self delegatePropertiesForProperties:properties];
	
	GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
	mutableProperties[kGRKAppCenterAnalyticsPropertyContentName] = name;
	mutableProperties[kGRKAppCenterAnalyticsPropertyContentType] = type;
	mutableProperties[kGRKAppCenterAnalyticsPropertyContentID] = identifier;
	
	[self trackEvent:kGRKAppCenterAnalyticsEventContentView category:nil properties:mutableProperties];
}

#pragma mark - Errors

- (void)trackError:(NSError *)error properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	[self trackEvent:self.errorEventName category:nil properties:properties];
}

#pragma mark - Helpers

- (NSString *)sanitizeUserPropertyKey:(NSString *)propertyKey
{
	propertyKey = [propertyKey stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	NSString *retVal = @"";
	
	// "A valid key for custom property should match regular expression pattern ^[a-zA-Z][a-zA-Z0-9]*$."
	// If we have a string to work with, we will ensure the leading character is a character from `letterCharacterSet` (prepending one if needed),
	// then we will strip any characters not in the `alphanumericCharacterSet`
	if (propertyKey.length > 0) {
		NSUInteger length = propertyKey.length;
		unichar resultBuffer[length + 1]; // +1 in case we need to prepend a character from `letterCharacterSet`
		unichar inputBuffer[length];
		[propertyKey getCharacters:inputBuffer range:NSMakeRange(0, length)];
		
		NSUInteger resultIndex = 0;
		NSUInteger inputIndex = 0;
		unichar firstChar = inputBuffer[inputIndex++];
		resultBuffer[resultIndex++] = [[NSCharacterSet letterCharacterSet] characterIsMember:firstChar] ? firstChar : 'a';
		
		for (; inputIndex < length; ++inputIndex) {
			unichar nextChar = inputBuffer[inputIndex];
			if ([[NSCharacterSet alphanumericCharacterSet] characterIsMember:nextChar]) {
				resultBuffer[resultIndex++] = nextChar;
			}
		}
		
		retVal = [[NSString alloc] initWithCharacters:resultBuffer length:resultIndex];
	}
	
	return retVal;
}

- (NSString *)sanitizeString:(nullable NSString *)key maxLength:(NSUInteger)maxLength
{
	NSString *retVal = [self cropString:key maxLength:maxLength] ?: @"";
	return retVal;
}

- (nullable MSEventProperties *)sanitizeProperties:(nullable NSDictionary<NSString *, id> *)properties
{
	// "The property names and values are limited to 125 characters each (truncated)."
	// "The number of properties per event is limited to 20 (truncated)."
	// We are not going to truncate anything here... let the MS framework handle it if they must.
	
	MSEventProperties *msProperties = nil;
	
	if (properties) {
		MSEventProperties *msProperties = [[MSEventProperties alloc] init];
		
		// "An event property's value may be one of the following types: NSString, double, int64_t, BOOL and NSDate."
		// We only accept objects, so `BOOL` is not an option (use `NSNumber`).
		// Since we are accepting objects, we treat NSNumber objects as doubles.
		// If the object is not one of these types we treat it as a String.
		for (NSString *key in [properties allKeys]) {
			id value = properties[key];
			if ([value isKindOfClass:NSNumber.class]) {
				[msProperties setDouble:[value doubleValue] forKey:key];
			}
			else if ([value isKindOfClass:NSDate.class]) {
				[msProperties setDate:value forKey:key];
			}
			else {
				NSString *stringValue = nil;
				if ([value isKindOfClass:NSString.class]) {
					stringValue = value;
				}
				else {
					stringValue = [value description];
				}
				
				[msProperties setString:stringValue forKey:key];
			}
		}
	}
	
	return msProperties;
}

#endif //GRK_ANALYTICS_ENABLED

@end

NS_ASSUME_NONNULL_END

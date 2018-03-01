//
//  GRKFirebaseProvider.m
//  GRKAnalytics
//
//  Created by Levi Brown on October, 10 2017.
//  Copyright (c) 2016-2017 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import "GRKFirebaseProvider.h"

#ifdef GRK_ANALYTICS_ENABLED

#import <FirebaseAnalytics/FirebaseAnalytics.h>

#endif //GRK_ANALYTICS_ENABLED

NS_ASSUME_NONNULL_BEGIN

@implementation GRKFirebaseProvider

#pragma mark - Lifecycle

- (instancetype)init
{
	return [self initWithConfiguration:nil];
}

- (nullable instancetype)initWithConfiguration:(nullable NSDictionary *)config
{
	if ((self = [super init])) {
#ifdef GRK_ANALYTICS_ENABLED
	
		BOOL success = NO;
		if (config) {
			// Write out the configuration to a temporary file, so we can use `FIROptions -initWithContentsOfFile:` to be more future-proof.
			NSURL *directoryURL = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent:[[NSProcessInfo processInfo] globallyUniqueString]] isDirectory:YES];
			__autoreleasing NSError *error = nil;
			if ([[NSFileManager defaultManager] createDirectoryAtURL:directoryURL withIntermediateDirectories:YES attributes:nil error:&error])
			{
				NSURL *fileURL = [directoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", [[NSProcessInfo processInfo] globallyUniqueString]]];
				error = nil;
				NSData *configData = [NSPropertyListSerialization dataWithPropertyList:config format:NSPropertyListXMLFormat_v1_0 options:NSPropertyListImmutable error:&error];
				if (configData) {
					error = nil;
					if ([configData writeToURL:fileURL options:NSDataWritingAtomic | NSDataWritingFileProtectionComplete error:&error]) {
						FIROptions *firOptions = [[FIROptions alloc] initWithContentsOfFile:fileURL.path];
						if (firOptions) {
							[FIRApp configureWithOptions:firOptions];
							success = YES;
						}
					}
				}
			}
		}
		else {
			success = YES;
		}
		
		if (!success) {
			self = nil;
		}
#endif //GRK_ANALYTICS_ENABLED
	}

	return self;
}

#ifdef GRK_ANALYTICS_ENABLED

- (void)setEnabled:(BOOL)enabled
{
	[super setEnabled:enabled];
	[[[FIRConfiguration sharedInstance] analyticsConfiguration] setAnalyticsCollectionEnabled:enabled];
}

#pragma mark - User

#pragma mark User Identity

- (void)identifyUserWithID:(nullable NSString *)userID andEmailAddress:(nullable NSString *)email
{
	// `userID` can be nil, but can not be empty.
	if (userID == nil || userID.length > 0)
	{
		[FIRAnalytics setUserID:userID];
	}
}

#pragma mark User Properties

- (void)setUserProperty:(NSString *)property toValue:(nullable id)value
{
	property = [self delegatePropertyForProperty:property];

	// The name of the user property to set. Should contain 1 to 24 alphanumeric characters
	// or underscores and must start with an alphabetic character. The "firebase_", "google_", and
	// "ga_" prefixes are reserved and should not be used for user property names.
	NSString *sanitizedName = [self sanitizeString:property maxLength:24];
	if (sanitizedName.length > 0) {
		// Values can be up to 36 characters long. Setting the value to nil removes the user property.
		NSString *sanitizedValue = [self cropString:[value description] maxLength:36];

		[FIRAnalytics setUserPropertyString:sanitizedValue forName:sanitizedName];
	}
}

#pragma mark - Events

- (void)trackEvent:(NSString *)event
		  category:(nullable NSString *)category
		properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	event = [self delegateEventForEvent:event];

	// The name of the event. Should contain 1 to 40 alphanumeric characters or
	// underscores. The name must start with an alphabetic character. Some event names are
	// reserved. See FIREventNames.h for the list of reserved event names. The "firebase_",
	// "google_", and "ga_" prefixes are reserved and should not be used. Note that event names are
	// case-sensitive and that logging two events whose names differ only in case will result in
	// two distinct events.
	NSString *sanitizedEvent = [self sanitizeString:event maxLength:40];
	if (sanitizedEvent.length > 0)
	{
		properties = [self delegatePropertiesForProperties:properties];
		
		if (category.length > 0 && !properties[self.categoryPropertyName])
		{
			GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
			mutableProperties[self.categoryPropertyName] = category;
			properties = mutableProperties;
		}

		NSDictionary<NSString *, id> *sanitizedProperties = [self sanitizeProperties:properties];
		[FIRAnalytics logEventWithName:sanitizedEvent parameters:sanitizedProperties];
	}
}

#pragma mark Event Specific Cases

- (void)trackAppBecameActiveWithCategory:(nullable NSString *)category
							  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	[self trackEvent:kFIREventAppOpen category:category properties:properties];
}

- (void)trackUserAccountCreatedMethod:(nullable NSString *)method
							  success:(nullable NSNumber *)success
						   properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	[self setUserProperty:kFIRUserPropertySignUpMethod toValue:method];

	properties = [self delegatePropertiesForProperties:properties];

	if (success != nil)
	{
		GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
		mutableProperties[self.successPropertyName] = success;
		properties = mutableProperties;
	}

	NSDictionary<NSString *, id> *sanitizedProperties = [self sanitizeProperties:properties];
	[FIRAnalytics logEventWithName:kFIREventSignUp parameters:sanitizedProperties];
}

- (void)trackLoginWithMethod:(nullable NSString *)method
					 success:(nullable NSNumber *)success
				  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	[self setUserProperty:kFIRUserPropertySignUpMethod toValue:method];
	
	properties = [self delegatePropertiesForProperties:properties];

	if (success != nil)
	{
		GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *mutableProperties = [properties mutableCopy];
		mutableProperties[self.successPropertyName] = success;
		properties = mutableProperties;
	}

	NSDictionary<NSString *, id> *sanitizedProperties = [self sanitizeProperties:properties];
	[FIRAnalytics logEventWithName:kFIREventLogin parameters:sanitizedProperties];
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
	/// Note:  in-app purchase events are reported by Firebase automatically for App Store-based apps.
}

- (void)trackContentViewWithName:(nullable NSString *)name
					 contentType:(nullable NSString *)type
					   contentID:(nullable NSString *)identifier
					  properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	[FIRAnalytics setScreenName:name screenClass:identifier];
}

#pragma mark - Errors

- (void)trackError:(NSError *)error properties:(nullable GRK_GENERIC_NSDICTIONARY(NSString *, id) *)properties
{
	[self trackEvent:self.errorEventName category:nil properties:properties];
}

#pragma mark - Helpers

- (nullable NSString *)sanitizeString:(nullable NSString *)key maxLength:(NSUInteger)maxLength
{
	NSString *retVal = nil;
	
	if (key) {
		NSMutableArray *components = [NSMutableArray arrayWithArray:[key componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
		[components removeObjectsInArray:@[@""]];
		retVal = [components componentsJoinedByString:@"_"];
		retVal = [self cropString:retVal maxLength:maxLength];
	}
	return retVal;
}

- (nullable NSString *)cropString:(nullable NSString *)string maxLength:(NSUInteger)maxLength
{
	NSString *retVal = string;
	
	if (retVal.length > 0) {
		retVal = [retVal substringToIndex:MIN(retVal.length, maxLength) - 1];
	}
	
	return retVal;
}

// The dictionary of event parameters. Passing nil indicates that the event has
// no parameters. Parameter names can be up to 40 characters long and must start with an
// alphabetic character and contain only alphanumeric characters and underscores. Only NSString
// and NSNumber (signed 64-bit integer and 64-bit floating-point number) parameter types are
// supported. NSString parameter values can be up to 100 characters long. The "firebase_",
// "google_", and "ga_" prefixes are reserved and should not be used for parameter names.
- (nullable NSDictionary<NSString *, id> *)sanitizeProperties:(nullable NSDictionary<NSString *, id> *)properties
{
	GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) *retVal = nil;
	
	if (properties) {
		retVal = [GRK_GENERIC_NSMUTABLEDICTIONARY(NSString *, id) dictionary];
		
		for (NSString *key in [properties allKeys]) {
			id sanitizedValue = nil;
			
			id value = properties[key];
			if ([value isKindOfClass:NSNumber.class]) {
				sanitizedValue = value;
			}
			else {
				sanitizedValue = [self sanitizeString:[value description] maxLength:100];
			}
			
			if (sanitizedValue) {
				NSString *sanitizedKey = [self sanitizeString:key maxLength:40];
				if (sanitizedKey) {
					retVal[sanitizedKey] = sanitizedValue;
				}
			}
		}
	}
	
	return retVal;
}

#endif //GRK_ANALYTICS_ENABLED

@end

NS_ASSUME_NONNULL_END

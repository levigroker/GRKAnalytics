//
//  GRKFirebaseProvider.h
//  GRKAnalytics
//
//  Created by Levi Brown on October, 5 2017.
//  Copyright (c) 2016-2017 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#import "GRKAnalyticsProvider.h"
#import "GRKLanguageFeatures.h"

NS_ASSUME_NONNULL_BEGIN

extern NSString * const kGRKFirebaseProviderDefaultErrorEventName;

extern NSString * const kGRKFirebaseProviderDefaultPropertyKeyCategory;
extern NSString * const kGRKFirebaseProviderDefaultPropertyKeySuccess;

@interface GRKFirebaseProvider : GRKAnalyticsProvider

/**
 The configuration used for initialization.
 */
@property (nonatomic, readonly) NSDictionary *firebaseConfiguration;

/**
 The event name for errors tracked by `trackError:properties:`
 Defaults to `kGRKFirebaseProviderDefaultErrorEventName`
 */
@property (nonatomic, nonnull, copy) NSString *errorEventName;

/**
 The property key to use for `category` information tracked by various API methods.
 Defaults to `kGRKFirebaseProviderDefaultPropertyKeyCategory`
 */
@property (nonatomic, nonnull, copy) NSString *categoryProperyName;

/**
 The property key to use for `success` information tracked by various API methods.
 Defaults to `kGRKFirebaseProviderDefaultPropertyKeySuccess`
 */
@property (nonatomic, nonnull, copy) NSString *successProperyName;


/**
 Configure a new instance with the given Firebase configuration.

 @param config A Dictionary containing all the keys and values used by Firebase for its configuration.
 This should be the entire content of the `GoogleService-Info.plist` file.
 If `nil`, Firebase will not be configured, and it is assumed to have been configured directly.
 @return A new instance, with Firebase configured as specified. This can return `nil` if a non-nill configuration was given but initialization failed.
 */
- (nullable instancetype)initWithConfiguration:(nullable NSDictionary *)config NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

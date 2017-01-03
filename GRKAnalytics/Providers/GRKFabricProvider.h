//
//  GRKFabricProvider.h
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
#import "GRKLanguageFeatures.h"

NS_ASSUME_NONNULL_BEGIN

@interface GRKFabricProvider : GRKAnalyticsProvider

/**
 * Initialize a provider for use with the Fabric/Crashlytics/Answers system.
 * Typical usage would be something like `[GRKFabricProvider alloc] initWithKits:@[Crashlytics.class]]`
 * @see https://docs.fabric.io/ios/fabric/getting-started.html
 *
 * @param kits An array of Class objects representing the Fabric kits to use.
 *
 * @return An initialized instance of the provider which can be passed to `GRKAnalytics addProvider:` class method. 
 */
- (instancetype)initWithKits:(GRK_GENERIC_NSARRAY(Class) *)kits NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END

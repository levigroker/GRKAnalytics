#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "GRKAnalytics.h"
#import "GRKAnalyticsProvider.h"
#import "GRKLanguageFeatures.h"

FOUNDATION_EXPORT double GRKAnalyticsVersionNumber;
FOUNDATION_EXPORT const unsigned char GRKAnalyticsVersionString[];


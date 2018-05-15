//
//  GRKLanguageFeatures.h
//  GRKAnalytics
//
//  Created by Levi Brown on January, 29 2016.
//  Copyright (c) 2016-2018 Levi Brown <mailto:levigroker@gmail.com> This work is
//  licensed under the Creative Commons Attribution 4.0 International License. To
//  view a copy of this license, visit https://creativecommons.org/licenses/by/4.0/
//  or send a letter to Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
//
//  The above attribution and the included license must accompany any version of
//  the source code, binary distributable, or derivatives.
//

#pragma once

#if !__has_feature(nullability)
    #define nonnull
    #define nullable
    #define _Nullable
    #define _Nonnull
#endif

#ifndef NS_ASSUME_NONNULL_BEGIN
    #define NS_ASSUME_NONNULL_BEGIN
#endif

#ifndef NS_ASSUME_NONNULL_END
    #define NS_ASSUME_NONNULL_END
#endif

#if __has_feature(objc_generics)
    #define GRK_GENERIC_NSARRAY(type) NSArray<type>
    #define GRK_GENERIC_NSDICTIONARY(key_type,object_key) NSDictionary<key_type, object_key>
    #define GRK_GENERIC_NSMUTABLEDICTIONARY(key_type,object_key) NSMutableDictionary<key_type, object_key>
#else
    #define GRK_GENERIC_NSARRAY(type) NSArray
    #define GRK_GENERIC_NSDICTIONARY(key_type,object_key) NSDictionary
    #define GRK_GENERIC_NSMUTABLEDICTIONARY(key_type,object_key) NSMutableDictionary
#endif

GRKAnalytics
===========
[![Build Status](https://travis-ci.org/levigroker/GRKAnalytics.svg)](https://travis-ci.org/levigroker/GRKAnalytics)
[![Version](http://img.shields.io/cocoapods/v/GRKAnalytics.svg)](http://cocoapods.org/?q=GRKAnalytics)
[![Platform](http://img.shields.io/cocoapods/p/GRKAnalytics.svg)]()
[![License](http://img.shields.io/cocoapods/l/GRKAnalytics.svg)](https://github.com/levigroker/GRKAnalytics/blob/master/LICENSE.txt)

A lightweight abstraction for underlying analytics providers.

### Installing

If you're using [CocoPods](http://cocopods.org) you add the pod and desired provider
subspec, to your `Podfile`. Ex:

	pod 'GRKAnalytics', :subspecs => ['Fabric']

or, if you are writing a module which wants to report analytics, but will be consumed by
a larger system which will setup the analytics sytem, you can just directly include only
the API with no providers:

	pod 'GRKAnalytics/Core'

If you are not using CocoaPods, simply add the top level *.m and *.h files, and the
provider(s) you wish from the `Providers` directory to your project.

NOTE: You will be responsible for adding the dependent provider library/libraries
yourself, as a dependency in your podfile or manually, as the GRKAnalytics podspec does
not bother with third party dependencies. This gives you the freedom to choose the version
and mechanism of import for these dependencies.

### Documentation

Configure `GRKAnalytics` with the providers of your choice and call the `GRKAnalytics`
class level methods to identify users, set user properties, track events, time events,
track errors, etc.

	GRKFabricProvider *fabricProvider = [GRKFabricProvider alloc] initWithKits:@[Crashlytics.class]];
	[GRKAnalytics addProvider:fabricProvider];
	//...
	[GRKAnalytics trackEvent:"Hello World"];

### Contributing

There are many, many, analytic providers and as such an adaptor to your provider of choice
may not be available in this pod, yet. Writing a provider adaptor is as easy as
subclassing `GRKAnalyticsProvider` and overriding the provider methods you need to make
the appropriate API calls to the underlying provider. Take a look at the
`GRKFabricProvider` implementation as an example.

GRKAnalytics does not depend on, nor include, the underlying provider APIs so the "trick" 
is "stub" out the API of the underlying provider you need to use and weak link the stubs
so when the actual underlying provider library is linked it will get called. This can be
done by specifying a compiler attribute `__attribute__((weak_import))` for the
`@interface` representing the stub. Again, please refer to the `GRKFabricProvider`
implementation as an example.

As an additional step the provider makes use of preprocessor defines to activate or
deactivate code at compile time. Please refer to the use of the preprocessor flag
`GRK_FABRIC_EXISTS` in the `GRKFabricProvider` implementation as an example of how this
define can be used. These preprocessor defines are are generated automatically by the
`podspec` as `GRK_{specname.upcase}_EXISTS`. The specname is defined in the podspec, along
with some other information which will need to be supplied so the podspec can generate the
appropriate subspec for your added provider.

Within the `GRKAnalytics.podspec` you will need to add your provider and add it to the
`all_analytics` array:

    ### Supported Providers
    fabric = { :spec_name => 'Fabric', :provider_class => 'GRKFabricProvider', :weak_classes => ['Fabric', 'Crashlytics', 'Answers'] }

    all_analytics = [fabric]
    ###
    
Let's break this down a little...

`fabric` is the ruby variable name which gets assigned the associative array with the rest
of the information. This name will need to be added to the `all_analytics` array so the
podspec can generate the appropriate subspec.

The associative array contains several pieces of data the podspec uses to build the
subspec:

`:spec_name => 'Fabric'`  
This is the name of the subspec and will be used in generating
the preprocessor variable `GRK_{specname.upcase}_EXISTS` (in this case
`GRK_FABRIC_EXISTS`). This is the name which users of this provider will need to supply in
their `Podfile`, like `pod 'GRKAnalytics', :subspecs => ['Fabric']`.

`:provider_class => 'GRKFabricProvider'`  
This is the name of the `.h` and `.m` files in the `Providers` subdirectory which
represent the class for the provider adaptor. This class should be a subclass of
`GRKAnalyticsProvider`.

`:weak_classes => ['Fabric', 'Crashlytics', 'Answers']`  
This is an array of classes which represent the stubbed out APIs defined in your provider
class and which need to be weak linked. The podspec will generate compiler flags for each
such that they are properly weak linked. See http://stackoverflow.com/a/32151697/397210

NOTE: At this time the podspec is designed such that all providers are cross-platform
(both iOS and OSX).

#### Disclaimer and Licence

* Inspiration was taken from [ARAnalytics](https://github.com/orta/ARAnalytics)
* This work is licensed under the [Creative Commons Attribution 3.0 Unported License](http://creativecommons.org/licenses/by/3.0/).
  Please see the included LICENSE.txt for complete details.

#### About
A professional iOS engineer by day, my name is Levi Brown. Authoring a blog
[grokin.gs](http://grokin.gs), I am reachable via:

Twitter [@levigroker](https://twitter.com/levigroker)  
Email [levigroker@gmail.com](mailto:levigroker@gmail.com)  

Your constructive comments and feedback are always welcome.

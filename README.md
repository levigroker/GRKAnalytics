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

	pod 'GRKAnalytics', :subspecs => ['Fabric','GoogleAnalytics']

or, if you are writing a module which wants to report analytics, but will be consumed by
a larger system which will setup the analytics sytem, you can just directly include only
the API with no providers:

	pod 'GRKAnalytics/Core'

If you are not using CocoaPods, simply add the top level *.m and *.h files, and the
provider(s) you wish from the `Providers` directory to your project.

NOTE: You will be responsible for adding the dependent provider library/libraries
yourself, as a dependency in your podfile or manually, as the GRKAnalytics podspec does
not bother with third party dependencies. This gives you the freedom to choose the version
and mechanism of import for these dependencies. For example, if you configured
GRKAnalytics with the subspecs `Fabric` and `GoogleAnalytics`, as above, you would also
need to add the related pods, like this:

    pod 'Fabric',          '~> 1.6'
    pod 'Crashlytics',     '~> 3.7'
    pod 'GoogleAnalytics', '~> 3.14'

### Documentation

Configure `GRKAnalytics` with the providers of your choice and call the `GRKAnalytics`
class level methods to identify users, set user properties, track events, time events,
track errors, etc.

	GRKFabricProvider *fabricProvider = [GRKFabricProvider alloc] initWithKits:@[Crashlytics.class]];
	[GRKAnalytics addProvider:fabricProvider];
	//...
	[GRKAnalytics trackEvent:"Hello World"];

As a convenience, when a provider subspec is specified, a preprocessor define is added to
the project configuration. These preprocessor defines are are generated automatically by
the `podspec` as `GRK_{specname.upcase}_EXISTS`.

### Contributing

There are many, many, analytic providers and as such an adaptor to your provider of choice
may not be available in this pod, yet. Writing a provider adaptor is as easy as
subclassing `GRKAnalyticsProvider` and overriding the provider methods you need to make
the appropriate API calls to the underlying provider. Take a look at the
`GRKFabricProvider` implementation as an example.

GRKAnalytics only makes use of the underlying provider APIs when the related subspecs are
specified, so you'll want to modify the test application's podfile to include the subspec
and the related pod(s) to compile against.

Additionally, for Cocoapods to be happy when validating the spec, the provider classes
must compile, and since we are not forcing the dependencies, compilation will fail (since
the underlying providers are not available). To avoid this, the provider code must compile
without the underlying provider frameworks/libraries being included. So, each provider
makes use of preprocessor defines to activate or deactivate code at compile time depending
on the inclusion of its subspec. Please refer to the use of the preprocessor flag
`GRK_FABRIC_EXISTS` in the `GRKFabricProvider` implementation as an example of how this
define can be used. These preprocessor defines are are generated automatically by the
`podspec` as `GRK_{specname.upcase}_EXISTS`. The specname is defined in the podspec, along
with some other information which will need to be supplied so the podspec can generate the
appropriate subspec for your added provider.

Within the `GRKAnalytics.podspec` you will need to add your provider and add it to the
`all_analytics` array:

    ### Supported Providers
    fabric = { :spec_name => 'Fabric', :provider_class => 'GRKFabricProvider' }

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

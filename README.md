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

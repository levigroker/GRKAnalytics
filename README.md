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

you will also need to add a `post_install` hook (or modify your existing hook), to update
the `GRKAnalytics` pod project to enable the compilation of the provider implementation:

    post_install do |installer_representation|
    
      # Grab the `project` object from the installer (cocoapods < 0.38 use `project`, cocoapods >= 0.38 use pods_project)
      # See https://github.com/CocoaPods/CocoaPods/issues/2292
      if installer_representation.respond_to?(:project)
        project = installer_representation.project
      else
        project = installer_representation.pods_project
      end
    
      # Update the GRKAnalytics pod project to enable compilation of the desired providers
      grkanalytics = (project.targets.select { |target| target.name == 'GRKAnalytics' }).first
      if grkanalytics
        grkanalytics.build_configurations.each do |config|
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= ['$(inherited)']
          config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] << 'GRK_ANALYTICS_ENABLED=1'
        end
      end
    
    end


or, if you are writing a module which wants to report analytics, but will be consumed by
a larger system which will setup the analytics sytem, you can just directly include only
the API with no providers (and no `post_install` hook is needed):

	pod 'GRKAnalytics/Core'

If you are not using CocoaPods, simply add the top level *.m and *.h files, and the
provider(s) you wish from the `Providers` directory to your project and add the
`GRK_ANALYTICS_ENABLED=1` preprocessor directive to your project.

NOTE: You will be responsible for adding the dependent provider library/framework
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

The above is the simplest case. Additional documentation is available in the source.

### Contributing

There are many, many, analytic providers and as such an adaptor to your provider of choice
may not be available in this pod, yet. Writing a provider adaptor is as easy as
subclassing `GRKAnalyticsProvider`, overriding the provider methods you need to make
the appropriate API calls to the underlying provider, and using
`#ifdef GRK_ANALYTICS_ENABLED` blocks to "hide" the provider API usage from Cocoapods.
Take a look at the included provider implementations as examples.

GRKAnalytics only makes use of the underlying provider APIs when the related subspecs are
specified and `GRK_ANALYTICS_ENABLED` is defined, so you'll want to modify the test
application's podfile to include the subspec and the related pod(s) to compile against.

Additionally, for Cocoapods to be happy when validating the spec, the provider classes
must compile without inclusion of the dependent underlying provider APIs. This is where
the provider implementation must use `#ifdef GRK_ANALYTICS_ENABLED` blocks to omit the use
of the underlying providers API from the eyes of the compiler.

The `post_install` hook, as defined above, will setup the `GRK_ANALYTICS_ENABLED`
preprocessor directive to allow the host pod project to compile the provider
implementations against the underlying providers, which the pod-user must include in the 
build process manually (by specifying dependencies in their podfile, for example).

Please refer to the included provider implementations for examples of how the
`#ifdef GRK_ANALYTICS_ENABLED` blocks are to be used.

Separately, within the `GRKAnalytics.podspec` you will need to add your provider and add
it to the `all_analytics` array:

    ### Supported Providers
    fabric = { :spec_name => 'Fabric', :provider_class => 'GRKFabricProvider' }
    googleanalytics = { :spec_name => 'GoogleAnalytics', :provider_class => 'GRKGoogleAnalyticsProvider' }

    all_analytics = [fabric, googleanalytics]
    ### 
    
Let's break this down a little...

`fabric` and `googleanalytics` are the ruby variable names which get assigned the
associative array with the rest of the information. These names will need to be added to
the `all_analytics` array so the podspec can generate the appropriate subspecs.

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

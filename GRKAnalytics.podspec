Pod::Spec.new do |s|
  s.name         = "GRKAnalytics"
  s.version      = "4.0"
  s.summary      = "A lightweight abstraction for underlying analytics providers."
  s.homepage     = "https://github.com/levigroker/GRKAnalytics"
  s.license      = 'Creative Commons Attribution 4.0 International License'
  s.author       = { "Levi Brown" => "levigroker@gmail.com" }
  s.social_media_url = 'https://twitter.com/levigroker'
  s.source       = { :git => "https://github.com/levigroker/GRKAnalytics.git", :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'
  s.osx.deployment_target = '10.12'
  s.frameworks = 'Foundation'
  s.source_files = ['GRKAnalytics/*.{h,m}']
  s.user_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => 'GRK_ANALYTICS_ENABLED=1' }
  
  ### Supported Providers
  fabric = { :spec_name => 'Fabric', :provider_class => 'GRKFabricProvider' }
  googleanalytics = { :spec_name => 'GoogleAnalytics', :provider_class => 'GRKGoogleAnalyticsProvider' }
  firebase = { :spec_name => 'Firebase', :provider_class => 'GRKFirebaseProvider' }

  all_analytics = [fabric, googleanalytics, firebase]
  ### 
  
  all_names = []

  # Dynamically generate the description
  all_analytics.each do |analytics_spec|
    specname = analytics_spec[:spec_name]
    all_names << specname
  end

  # Generate a dynamic description
  spec_names = all_names.length > 0 ? all_names[0...-1].join(", ") + " and " + all_names[-1] : ""
  s.description  =  "GRKAnalytics is a lightweight abstraction allowing for the agnostic use of multiple and varying analytics providers. Supported providers: #{ spec_names }."

end

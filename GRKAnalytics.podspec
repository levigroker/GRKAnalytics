Pod::Spec.new do |s|
  s.name         = "GRKAnalytics"
  s.version      = "1.0"
  s.summary      = "A lightweight abstraction for underlying analytics providers."
  s.homepage     = "https://github.com/levigroker/GRKAnalytics"
  s.license      = 'Creative Commons Attribution 3.0 Unported License'
  s.author       = { "Levi Brown" => "levigroker@gmail.com" }
  s.social_media_url = 'https://twitter.com/levigroker'
  s.source       = { :git => "https://github.com/levigroker/GRKAnalytics.git", :tag => s.version.to_s }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.frameworks = 'Foundation'
  
  ### Supported Providers
  fabric = { :spec_name => 'Fabric', :provider_class => 'GRKFabricProvider', :weak_classes => ['Fabric', 'Crashlytics', 'Answers'] }

  all_analytics = [fabric]
  ### 
  
  s.subspec "Core" do |ss|
    ss.source_files = ['*.{h,m}']
  end

  all_names = []

  # Dynamically make sub-specs for each provider
  all_analytics.each do |analytics_spec|
    s.subspec analytics_spec[:spec_name] do |ss|

      specname = analytics_spec[:spec_name]
      provider = analytics_spec[:provider_class]

      # Each subspec adds a compiler flag saying that the spec was included
      ss.prefix_header_contents = "#define GRK_#{specname.upcase}_EXISTS 1"
      sources = ["Providers/#{provider}.{h,m}"]
      ss.dependency 'GRKAnalytics/Core'
      ss.source_files = sources
      # We need to weakly link the stub classes
      #see http://stackoverflow.com/a/32151697/397210
      if analytics_spec[:weak_classes]
        flags = '-Wl'
        analytics_spec[:weak_classes].each do |weak_class|
          flags += ',-U,_OBJC_CLASS_$_' + weak_class
        end
        ss.pod_target_xcconfig = { 'OTHER_LDFLAGS' => "$(inherited) #{flags}" }
      end
      all_names << specname

    end
  end

  # Generate a dynamic description
  spec_names = all_names.length > 0 ? all_names[0...-1].join(", ") + " and " + all_names[-1] : ""
  s.description  =  "GRKAnalytics is a lightweight abstraction allowing for the agnostic use of multiple and varying analytics providers. Supported providers: #{ spec_names }."

end

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
  fabric_ios = { :spec_name => "Fabric", :provider_class => "GRKFabricProvider" }
  fabric_osx = { :spec_name => "Fabric", :provider_class => "GRKFabricProvider", :osx => true }

  all_analytics = [fabric_ios, fabric_osx]
  ### 
  
  s.subspec "CoreOSX" do |ss|
    ss.source_files = ['*.{h,m}']
    ss.platform = :osx
  end

  s.subspec "CoreIOS" do |ss|
    ss.source_files = ['*.{h,m}']
    ss.platform = :ios
  end

  all_ios_names = []
  all_osx_names = []

  # Dynamically make sub-specs for each provider
  all_analytics.each do |analytics_spec|
    s.subspec analytics_spec[:spec_name] do |ss|

      specname = analytics_spec[:spec_name]
      provider = analytics_spec[:provider_class]

      # Each subspec adds a compiler flag saying that the spec was included
      ss.prefix_header_contents = "#define GRK_#{specname.upcase}_EXISTS 1"
      sources = ["Providers/#{provider}.{h,m}"]

      if analytics_spec[:osx]
        ss.osx.source_files = sources
        ss.dependency 'GRKAnalytics/CoreOSX'
        ss.platform = :osx
        all_osx_names << specname
      else
        ss.ios.source_files = sources
        ss.dependency 'GRKAnalytics/CoreIOS'
        ss.platform = :ios
        all_ios_names << specname
      end

    end
  end

  # Generate a dynamic description
  ios_spec_names = all_ios_names.length > 0 ? all_ios_names[0...-1].join(", ") + " and " + all_ios_names[-1] : ""
  osx_spec_names = all_osx_names.length > 0 ? all_osx_names[0...-1].join(", ") + " and " + all_osx_names[-1] : ""
  s.description  =  "GRKAnalytics is a lightweight abstraction allowing for the agnostic use of multiple and varying analytics providers. Supported iOS providers: #{ ios_spec_names }. Supported OS X providers: #{ osx_spec_names }."

end

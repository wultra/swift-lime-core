Pod::Spec.new do |s|
  s.name = 'LimeCore'
  s.version = '1.3.1'
  # Metadata
  s.license = { :type => 'Apache License, Version 2.0', :file => 'LICENSE' }
  s.summary = 'Supporting classes developed and used by Wultra'
  s.homepage = 'https://github.com/wultra/swift-lime-core'
  s.social_media_url = 'https://twitter.com/wultra'
  s.author = { 'Wultra s.r.o.' => 'support@wultra.com' }
  s.source = { :git => 'https://github.com/wultra/swift-lime-core.git', :tag => s.version }
  # Deployment targets
  s.swift_version = '5.0'
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.osx.deployment_target = '10.15'
  # Sources
  
  # Default subspec should include all source codes provided in core except 'LimeCore/LocalizedString' pod
  # Currently 'Localization' fulfills this requirement due to its transitional dependencies. 
  s.default_subspec = 'Localization'
  
  # 'Core' subspec
  s.subspec 'Core' do |sub|
    sub.source_files = 'Source/Core/*.swift'
  end

  # 'Localization' subspec
  s.subspec 'Localization' do |sub|
    sub.source_files = 'Source/Localization/*.swift'
    sub.dependency 'LimeCore/Core'
  end

end

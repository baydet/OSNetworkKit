
Pod::Spec.new do |s|

  s.name         = "OSNetworkKit"
  s.version      = "0.1"
  s.summary      = "Helper classes for RestKit"
  s.homepage     = "https://github.com/baydet/OSNetworkKit"

  s.license      = { :type => "MIT" }
  s.author       = "baydet"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/baydet/OSNetworkKit.git", :tag => "0.1" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.exclude_files = "Classes/Exclude"
  s.requires_arc  = true
  s.dependency "RestKit", "~> 0.2"

end

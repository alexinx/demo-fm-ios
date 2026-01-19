Pod::Spec.new do |s|
  s.name             = 'DemoSDK'
  s.version          = '1.0.1'
  s.summary          = 'Demo SDK - Dummy iOS SDK for testing CocoaPods and CI/CD flow'

  s.description      = <<-DESC
DemoSDK is a dummy iOS SDK used only for testing release pipelines,
CocoaPods publishing, GitHub Actions, and tag-based distribution.
No real functionality is included.
                       DESC

  s.homepage         = 'https://github.com/your-org/demo-sdk'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Demo' => 'demo@example.com' }

  # Tag must exist like: v1.0.1
  s.source           = { 
    :git => 'https://github.com/alexinx/demo-fm-ios.git', 
    :tag => "v#{s.version}" 
  }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  # Dummy framework
  s.vendored_frameworks = 'Frameworks/DemoSDK.xcframework'
  
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
end
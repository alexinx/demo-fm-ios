#
# Be sure to run `pod lib lint DemoAlexSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'DemoAlexSDK'
  s.version          = '1.0.6'
  s.summary          = 'Demo SDK - iOS SDK'

  s.description      = <<-DESC
Demo SDK for iOS for test
DESC

  s.homepage         = 'https://github.com/alexinx/demo-fm-ios'
  s.license          = { :type => 'ISC', :file => 'LICENSE' }
  s.author           = { 'Demo' => 'demo@example.com' }
  s.source           = { :git => 'https://github.com/alexinx/demo-fm-ios.git', :tag => "v#{s.version}"}

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.vendored_frameworks = 'Frameworks/DemoAlexSDK.xcframework'
  
  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
end

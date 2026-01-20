Pod::Spec.new do |s|
  s.name             = 'DemoSDK'
  s.version          = '1.0.1'
  s.summary          = 'Cyphlens SDK for 2FA SSE - iOS SDK for Server-Sent Events integration'

  s.description      = <<-DESC
A lightweight iOS SDK designed to simplify 2FA authentication with Cyphlens' Server-Sent Events (SSE) integration.
The SDK establishes an SSE connection, listens for authentication events from the backend, and notifies the host
application about the current authentication status via callbacks.
DESC

  s.homepage         = 'https://github.com/alexinx/demo-fm-ios'
  s.license          = { :type => 'ISC', :file => 'LICENSE' }
  s.author           = { 'Cyphlens' => 'info@cyphlens.com' }
  s.source           = { :git => 'https://github.com/alexinx/demo-fm-ios.git', :tag => "v#{s.version}" }

  s.ios.deployment_target = '13.0'
  s.swift_version = '5.0'

  s.vendored_frameworks = 'Frameworks/DemoSDK.xcframework'

  s.frameworks = 'Foundation', 'UIKit'
  s.requires_arc = true
end
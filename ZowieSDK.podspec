Pod::Spec.new do |spec|

  spec.name         = "ZowieSDK"
  spec.version      = "0.0.14"
  spec.summary      = "Zowie chat SDK."

  spec.homepage     = "https://docs.getzowie.com"
  spec.license      = {
    :type => 'Copyright',
    :text => <<-LICENSE
    ZowieSDKs
    Created by Zowie on  1/01/2021
    Copyright (c) 2021 Zowie. All rights reserved.
    By downloading or using the Zowie Mobile SDK, You agree to the Zowie Master
    Service Agreement https://www.getzowie.com/master-service-agreement and
    acknowledge that such terms govern Your use of and access to the Mobile SDK.
    LICENSE
  }
  
  spec.author       = "Zowie"
  spec.platform     = :ios, "12.0"
  spec.swift_version = "5.3"
  spec.cocoapods_version = '>= 1.10.0'

  spec.source       = { :git => "https://github.com/chatbotizeteam/sdk-native-ios.git", :tag => spec.version }
  spec.vendored_frameworks = 'ZowieSDK.xcframework'

  spec.framework  = "UIKit"

  spec.pod_target_xcconfig = { 'BUILD_LIBRARY_FOR_DISTRIBUTION' => 'YES' }

  spec.dependency "Apollo", "~> 0.49.1"
  spec.dependency "Apollo/WebSocket", "~> 0.49.1"
  spec.dependency "Kingfisher", "~> 7.0"
  spec.dependency "lottie-ios", "~> 4.2.0"

end


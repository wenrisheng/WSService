#
#  Be sure to run `pod spec lint WSService.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "WSService"
  s.version      = "0.0.1"
  s.summary      = "A short description of WSService."
  s.description  = "OC Network Layer"

  s.homepage     = "https://github.com/wenrisheng/WSService"
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  s.author             = { "wrs" => "252797991@qq.com" }
  # s.platform     = :ios
  # s.platform     = :ios, "5.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/wenrisheng/WSService.git"}

  s.source_files  = "WSService/WSService/**/*.{h,m}"

  s.public_header_files = "WSService/WSService/**/*.h"

  s.dependency "AFNetworking"
  s.dependency "ASIHTTPRequest"

end

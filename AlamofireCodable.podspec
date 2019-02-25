#
#  Be sure to run `pod spec lint AlamofireCodable.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name             = "AlamofireCodable"
  s.version          = "1.0.0"
  s.summary          = "Alamofire extension for serialize Data to Codable Model"
  s.homepage         = "https://github.com/seasonZhu/AlamofireCodable"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "seasonZhu" => "zhujilong1987@163.com" }
  s.source           = { :git => "https://github.com/seasonZhu/AlamofireCodable.git", :tag => "#{s.version}" }
  s.platform     = :ios, '9.0'
  s.swift_version = '4.2'
  s.requires_arc = true
  s.source_files = 'AlamofireCodable/*.swift'
  s.dependency 'Alamofire'
  s.frameworks = 'CFNetwork'

end

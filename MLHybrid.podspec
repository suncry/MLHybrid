#
# Be sure to run `pod lib lint MLHybrid.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MLHybrid'
  s.version          = '0.1.0'
  s.summary          = 'Hybrid take U fly'

  s.homepage         = 'https://github.com/suncry/MLHybrid'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yang cai' => 'caiyang@medlinker.com' }
  s.source           = { :git => 'https://github.com/suncry/MLHybrid.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'

  s.source_files = 'MLHybrid/Classes/**/*'

end


Pod::Spec.new do |s|
  s.name             = 'MLHybrid'
  s.version          = '0.4.5'
  s.summary          = 'Hybrid take U fly'
  s.description      = <<-DESC
this is description
                       DESC

  s.homepage         = 'https://github.com/suncry/MLHybrid'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yang cai' => 'caiyang@medlinker.com' }
  s.source           = { :git => 'https://github.com/suncry/MLHybrid.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'Source/**/*'

  s.dependency 'SSZipArchive'
  s.dependency 'NJKWebViewProgress'
  s.dependency 'Kingfisher'

end

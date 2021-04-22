Pod::Spec.new do |s|
  s.name             = 'flutter_sobot'
  s.version          = '2.9.6'
  s.summary          = 'A new flutter plugin project.'
  s.description      = <<-DESC
  A new flutter plugin project.
  ZCSDK_Plugin
                       DESC
  s.homepage         = 'http://code.zhichidata.com/flutter_sobotsdk/flutter_sobot.git'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'zhichiwanglei' => 'app_dev@sobot.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'SobotKit', '2.9.6'
  s.platform = :ios, '9.0'
  
  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64' }
  s.static_framework = true
end

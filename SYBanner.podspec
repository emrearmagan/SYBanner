Pod::Spec.new do |spec|
  spec.name             = 'SYBanner'
  spec.version          = '0.0.5'
  spec.summary          = 'A minimalistic looking banner library for iOS. It supports multiple customizable kinds of Banner types'
  spec.homepage         = 'https://github.com/emrearmagan/SYBanner'
  spec.license          = { :type => 'MIT', :file => 'LICENSE' }
  spec.author           = { 'Emre Armagan' => 'emrearmagan.dev@gmail.com' }
  spec.source           = { :git => 'https://github.com/emrearmagan/SYBanner.git', :tag => spec.version }
  spec.swift_version         = '5.0'
  spec.ios.deployment_target = '13.0'
  spec.source_files          = 'SYBanner/**/*'
end

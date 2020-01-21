platform :osx, '10.9'
use_frameworks!

raise 'Please use bundle exec to run the pod command' unless defined?(Bundler)

def common_pods
  podspec :path => 'SwiftGenKit.podspec'
  pod 'SwiftLint', '~> 0.37.0'
end

target 'swiftgen' do
  common_pods
  pod 'Commander', '~> 0.8'
  pod 'StencilSwiftKit', '~> 2.7'

  target 'SwiftGen UnitTests' do
    inherit! :complete
  end

  target 'Templates UnitTests' do
    inherit! :complete
  end
end

target 'SwiftGenKit' do
  common_pods

  target 'SwiftGenKit UnitTests' do
    inherit! :complete
  end
end

post_install do | installer |
  require 'fileutils'

  # copy Info.plist files
  pods_with_info_plist = %w(Stencil StencilSwiftKit)
  pods_with_info_plist.each do |pod|
    FileUtils.cp_r("Pods/Target Support Files/#{pod}/#{pod}-Info.plist", "Resources/#{pod}-Info.plist")
  end
end

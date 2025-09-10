#
# Be sure to run `pod lib lint ABTastyOpenfeature-iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ABTastyOpenfeature-iOS'
  s.version          = '1.0.0'
  s.summary          = 'is an implementation of OpenFeature Provider protocol that integrates with ABTasty feature flag management system through the Flagship SDK.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/flagship-io/openfeature-provider-iOS#readme'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Adel' => 'adel@abtasty.com' }
  s.source           = { :git => 'https://github.com/flagship-io/openfeature-provider-iOS.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '15.0'

  s.source_files = 'ABTastyOpenfeature-iOS/Classes/**/*'
  
  # s.resource_bundles = {
  #   'ABTastyOpenfeature-iOS' => ['ABTastyOpenfeature-iOS/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
    s.dependency 'FlagShip', '~> 4.0.0'
    s.dependency 'OpenFeature', '~> 0.3.0'
end

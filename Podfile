
platform :ios, '13.0'

use_frameworks!
target 'GitSwiftUITestApp' do
  pod 'Sourcery'
  
  target 'GitSwiftUITestAppTests' do
     inherit! :search_paths
     pod 'Quick'
     pod 'Nimble'
   end
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = '$(inherited)'
    end
  end
end



# Uncomment the next line to define a global platform for your project
platform :osx, '13.0'

target 'Kollaps' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Kollaps
  pod 'WormholeWilliam', '~> 0.0.4'

  target 'KollapsTests' do
    inherit! :search_paths
    pod 'Quick'
    pod 'Nimble'
  end

  target 'KollapsUITests' do
    # Pods for testing
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings.delete 'MACOSX_DEPLOYMENT_TARGET'
      end
    end
  end
end

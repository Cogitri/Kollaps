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
    installer.pods_project.root_object.attributes['BuildIndependentTargetsInParallel'] = "YES"

    installer.pods_project.build_configurations.each do |config|
      config.build_settings['DEAD_CODE_STRIPPING'] = 'YES'
    end

    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['ARCHS'] = "$(ARCHS_STANDARD)"
        config.build_settings['ENABLE_MODULE_VERIFIER'] = "YES"
        config.build_settings['MODULE_VERIFIER_SUPPORTED_LANGUAGES'] = "objective-c objective-c++"
        config.build_settings['MODULE_VERIFIER_SUPPORTED_LANGUAGE_STANDARDS'] = "gnu11 gnu++14"
        config.build_settings.delete 'MACOSX_DEPLOYMENT_TARGET'
        config.build_settings.delete 'DEAD_CODE_STRIPPING'
      end
    end
  end
end

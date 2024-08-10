# Uncomment the next line to define a global platform for your project
platform :ios, '15.5'

target 'GulerGlobal' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_QUOTED_INCLUDE_IN_FRAMEWORK_HEADER'] = "NO"
    end
  end

  pod 'Firebase/Core'
  pod 'FirebaseAuth'
  pod 'FirebaseFirestore'

  # Pods for GulerGlobal

end

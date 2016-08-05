platform :ios, "8.0"
use_frameworks!

workspace "ICInputAccessory"
project "ICInputAccessory"
project "Example/Example"

target "Example" do
  pod "ICInputAccessory/KeyboardDismissTextField", path: "./"
  pod "ICInputAccessory/TokenField", path: "./"
end

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    # Configure Pod targets for Xcode 8 compatibility
    config.build_settings['SWIFT_VERSION'] = '2.3'
    config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = 'ABCDEFGHIJ/'
    config.build_settings['ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES'] = 'NO'
  end
end
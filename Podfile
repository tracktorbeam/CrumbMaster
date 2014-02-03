platform :ios, '7.0'

pod 'GimbalProximity', '1.10'
pod 'Underscore.m', '~> 0.2.1'
pod 'AFNetworking', '~> 2.1.0'

workspace 'Crumb'

# Post-install hook to get rid of the '-lz' flag while building Crumb because you cant
# link a static library with another static library. The '-lz' flag will be present when
# some other application links against Crumb
post_install do |installer|
  default_library = installer.libraries.detect { |i| i.target_definition.name == 'Pods' }
  config_file_path = default_library.library.xcconfig_path
  
  File.open("config.tmp", "w") do |io|
    io << File.read(config_file_path).gsub(/-lz/, '')
  end
  FileUtils.mv("config.tmp", config_file_path)
end

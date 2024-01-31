# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'BrainSpace' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  # data
  pod 'ObjectMapper'
  # network
  pod 'Alamofire'
  pod 'AlamofireObjectMapper'
  pod 'AlamofireNetworkActivityIndicator', '~> 2.4.0'
  pod 'ReachabilitySwift'
  
  target 'BrainSpaceTests' do
    inherit! :search_paths
  end

  target 'BrainSpaceUITests' do
    inherit! :search_paths
  end
  
  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings["IPHONEOS_DEPLOYMENT_TARGET"] = "14.0"
      end
    end
  end
end

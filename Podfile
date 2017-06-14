platform :ios, '9.0'
use_frameworks!

def shared_pods
    pod 'SwiftyJSON'  # parsing JSON
    pod 'RealmSwift'
    pod 'ObjectMapper+Realm'
end

target 'Riyadh' do
  shared_pods
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.1'
        end
    end
end

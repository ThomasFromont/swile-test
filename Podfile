source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '13.0'

use_frameworks!
inhibit_all_warnings!
install! 'cocoapods', :disable_input_output_paths => true

target 'Swile' do
    pod 'RxCocoa'
    pod 'RxSwift'
    pod 'RxSwiftExt'
    pod 'SnapKit'
    pod 'SwiftGen'
    pod 'SwiftLint'
    pod 'Hero'

    target 'SwileTests' do
        inherit! :search_paths
    end

    post_install do |installer|
        installer.pods_project.targets.each do |target|

            # Fix deployment target warning with iOS 8 and Xcode 12 until podspecs are updated
            # See https://github.com/CocoaPods/CocoaPods/issues/9884
            target.build_configurations.each do |config|
                if ['8.0', '8.1'].include? config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                end
            end
        end
    end
end

platform :ios, '11.0'

def use_test_pods
  pod 'Quick'
  pod 'Nimble'
end

abstract_target 'Workspace' do
  workspace 'Placer.xcworkspace'

  use_frameworks!

  # Rx
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxOptional'
  pod 'RxDataSources'

  # Logging
  pod 'SwiftyBeaver'

  target 'Common' do
    project 'Common.xcodeproj'

    target 'CommonTests' do
      use_test_pods
    end
  end

  target 'Domain' do
    project 'Domain.xcodeproj'

    target 'DomainTests' do
      use_test_pods
    end
  end

  target 'Network' do
    project 'Network.xcodeproj'

    pod 'Moya'

    target 'NetworkTests' do
      use_test_pods
    end
  end

  target 'Service' do
    project 'Service.xcodeproj'

    target 'ServiceTests' do
      use_test_pods
    end
  end

  target 'Placer' do
    project 'Placer.xcodeproj'

    # Binary
    pod 'SwiftLint'
    pod 'SwiftGen'

    # Crashlytics
    pod 'Fabric'
    pod 'Crashlytics'

    # UI
    pod 'SnapKit'

    target 'PlacerTests' do
      inherit! :search_paths

      use_test_pods
    end
  end
end

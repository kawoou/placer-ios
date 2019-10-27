platform :ios, '10.0'

use_frameworks!

workspace 'Placer.xcworkspace'

project 'Common/Common.xcodeproj'
project 'Domain/Domain.xcodeproj'
project 'Network/Network.xcodeproj'
project 'Service/Service.xcodeproj'
project 'Placer/Placer.xcodeproj'

def use_common_pods
  # Dependency
  pod 'Swinject'

  # Rx
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxRelay', '~> 5'
  pod 'RxOptional'
  pod 'RxDataSources'

  # Logging
  pod 'SwiftyBeaver'
end

def use_test_pods
  pod 'Quick'
  pod 'Nimble'
end

def use_domain_pods
end

def use_network_pods
  pod 'Moya', '~> 13.0'
end

def use_service_pods
  pod 'SPPermission/Location'
  pod 'SPPermission/Camera'
  pod 'SPPermission/PhotoLibrary'
end

target 'Common' do
  project 'Common/Common.xcodeproj'
  
  use_common_pods

  target 'CommonTests' do
    inherit! :search_paths

    use_test_pods
  end
end

target 'Domain' do
  project 'Domain/Domain.xcodeproj'
  
  use_common_pods
  use_network_pods
  use_domain_pods

  target 'DomainTests' do
    inherit! :search_paths

    use_test_pods
  end
end

target 'Network' do
  project 'Network/Network.xcodeproj'
  
  use_common_pods
  use_network_pods

  target 'NetworkTests' do
    inherit! :search_paths

    use_test_pods
  end
end

target 'Service' do
  project 'Service/Service.xcodeproj'
  
  use_common_pods
  use_network_pods
  use_domain_pods
  use_service_pods

  target 'ServiceTests' do
    inherit! :search_paths

    use_test_pods
  end
end

target 'Placer' do
  project 'Placer/Placer.xcodeproj'
  
  use_common_pods
  use_domain_pods
  use_network_pods
  use_service_pods

  # Rx
  pod 'RxKeyboard'

  # Binary
  pod 'SwiftLint'
  pod 'SwiftGen'

  # Analytics
  pod 'Firebase/Analytics'

  # Crashlytics
  pod 'Fabric'
  pod 'Crashlytics'

  # UI
  pod 'Kingfisher'
  pod 'SnapKit'

  target 'PlacerTests' do
    inherit! :search_paths

    use_test_pods
  end
end

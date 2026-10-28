# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

# Current Xcode SDKs no longer include libarclite for older deployment targets.
# Apply the app's minimum to legacy pods while preserving higher requirements.
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      minimum = config.build_settings['IPHONEOS_DEPLOYMENT_TARGET']
      if minimum && Gem::Version.new(minimum) < Gem::Version.new('12.0')
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
  # Newer SDKs expose another conditional Optional.Value through Gesture.
  # Qualify the dictionary literal types in the frozen SwiftyMocky 4 source.
  literals = installer.sandbox.root.join('SwiftyMocky/Sources/SwiftyMocky/Parameter+Literals.swift')
  if literals.file?
    source = literals.read
    old_initializer = "public init(dictionaryLiteral elements: (Key, Value)...) {\n        self = .some(Wrapped.init(elements))"
    new_initializer = "public init(dictionaryLiteral elements: (Wrapped.Key, Wrapped.Value)...) {\n        self = .some(Wrapped.init(elements))"
    unless source.include?(new_initializer)
      raise 'Unexpected SwiftyMocky literal initializer; review SDK compatibility patch' unless source.scan(old_initializer).length == 1
      literals.write(source.sub(old_initializer, new_initializer))
    end
  end

end

inhibit_all_warnings!

workspace 'Introspective.xcworkspace'

target 'Introspective' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod "Sourcery"
  pod "Presentr"
  pod 'SwiftDate', '6.0.3'
  pod 'AAInfographics', :git => 'https://github.com/AAChartModel/AAChartKit-Swift.git', :commit => '5a4cd821251442fbb24720897db0b1abf7ccef32'
  pod 'NotificationBannerSwift'
  pod 'CalendarKit'
  pod 'WSTagsField', :git => 'https://github.com/TimeDelta/WSTagsField.git', :commit => '9c629c40a11a2c7dc60f2783469eb161a6239208'
  pod 'CSV.swift', '~> 2.3.1'
  pod 'Instructions', '~> 1.2.2'

  target 'IntrospectiveTests' do
    use_frameworks!
    inherit! :search_paths
    pod "SwiftyMocky", :git => 'https://github.com/MakeAWishFoundation/SwiftyMocky.git', :commit => 'a431fa7d5d322fab57503beef97d8e429766c188'
    pod 'SwiftHamcrest', '~> 2.2.1'
  end

  target 'DiscreteMoodWidget' do
    inherit! :search_paths
    pod 'SwiftDate', '6.0.3'
  end

  target 'SiriIntents' do
    inherit! :search_paths
    pod 'SwiftDate', '6.0.3'
  end
end

# A UI runner is a separate process, not a hosted unit-test bundle.
# Keep it top-level so CocoaPods supplies its own link and embed settings.
target 'IntrospectiveUITests' do
  use_frameworks!
  pod 'SwiftDate', '6.0.3'
end

target 'AttributeRestrictions' do
  project 'AttributeRestrictions/AttributeRestrictions'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
  # Required to resolve modules imported through internal frameworks.
  pod 'Presentr'
end

target 'Attributes' do
  project 'Attributes/Attributes'
  use_frameworks!

  pod 'Sourcery'
  # Required to resolve modules imported through internal frameworks.
  pod 'CSV.swift', '~> 2.3.1'
  pod 'Presentr'
  pod 'SwiftDate', '6.0.3'
end

target 'BooleanAlgebra' do
  project 'BooleanAlgebra/BooleanAlgebra'
  use_frameworks!

  pod 'Sourcery'
  # Required to resolve modules imported through internal frameworks.
  pod 'CSV.swift', '~> 2.3.1'
  pod 'Presentr'
  pod 'SwiftDate', '6.0.3'
  pod 'NotificationBannerSwift'
end

target 'Common' do
  project 'Common/Common'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
  pod 'CSV.swift', '~> 2.3.1'
  pod 'Presentr'
end

target 'DataExport' do
  project 'DataExport/DataExport'
  use_frameworks!

  pod 'Sourcery'
  pod 'CSV.swift', '~> 2.3.1'
  # Required to resolve modules imported through internal frameworks.
  pod 'Presentr'
  pod 'SwiftDate', '6.0.3'
end

target 'DataImport' do
  project 'DataImport/DataImport'
  use_frameworks!

  pod 'Sourcery'
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
  pod 'SwiftDate', '6.0.3'
  # Required to resolve modules imported through internal frameworks.
  pod 'Presentr'
end

target 'DependencyInjection' do
  project 'DependencyInjection/DependencyInjection'
  use_frameworks!

  pod 'Sourcery'
end

target 'Notifications' do
  project 'Notifications/Notifications'
  use_frameworks!

  pod 'Sourcery'
  pod 'NotificationBannerSwift'
  # Required to resolve modules imported through internal frameworks.
  pod 'CSV.swift', '~> 2.3.1'
  pod 'Presentr'
  pod 'SwiftDate', '6.0.3'
end

target 'Persistence' do
  project 'Persistence/Persistence'
  use_frameworks!

  pod 'Sourcery'
  pod 'NotificationBannerSwift'
  # Required to resolve modules imported through internal frameworks.
  pod 'CSV.swift', '~> 2.3.1'
  pod 'Presentr'
  pod 'SwiftDate', '6.0.3'
end

target 'Queries' do
  project 'Queries/Queries'
  use_frameworks!

  pod 'Sourcery'
  # Required to resolve modules imported through internal frameworks.
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
  pod 'Presentr'
  pod 'SwiftDate', '6.0.3'
end

target 'Samples' do
  project 'Samples/Samples'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
  pod 'CSV.swift', '~> 2.3.1'
  # Required to resolve modules imported through internal frameworks.
  pod 'NotificationBannerSwift'
  pod 'Presentr'
end

target 'SampleFetchers' do
  project 'SampleFetchers/SampleFetchers'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
  pod 'MarqueeLabel'
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
  pod 'Presentr'
end

target 'SampleGroupers' do
  project 'SampleGroupers/SampleGroupers'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
  # Required to resolve modules imported through internal frameworks.
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
  pod 'Presentr'
end

target 'SampleGroupInformation' do
  project 'SampleGroupInformation/SampleGroupInformation'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
  # Required to resolve modules imported through internal frameworks.
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
  pod 'Presentr'
end

target 'UIExtensions' do
  project 'UIExtensions/UIExtensions'
  use_frameworks!

  pod 'Sourcery'
  pod 'Instructions', '~> 1.2.2'
  # Required to resolve modules imported through internal frameworks.
  pod 'CSV.swift', '~> 2.3.1'
  pod 'Presentr'
  pod 'SwiftDate', '6.0.3'
end


target 'Settings' do
  project 'Settings/Settings'
  use_frameworks!
  # Required to resolve modules imported through internal frameworks.
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
  pod 'Presentr'
  pod 'SwiftDate', '6.0.3'
end

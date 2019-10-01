# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

workspace 'Introspective.xcworkspace'

target 'Introspective' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod "Sourcery"
  pod "Presentr"
  pod 'SwiftDate', '6.0.3'
  pod 'AAInfographics'
  pod 'NotificationBannerSwift'
  pod 'CalendarKit'
  pod 'WSTagsField', '5.0.0'
  pod "SearchTextField"
  pod 'CSV.swift', '~> 2.3.1'
  pod 'Instructions', '~> 1.2.2'

  target 'IntrospectiveTests' do
    inherit! :search_paths
    pod "SwiftyMocky", '~> 3.2.0'
    pod 'SwiftHamcrest', '~> 2.1.1'
  end

  target 'IntrospectiveUITests' do
    inherit! :search_paths
    pod 'SwiftDate', '6.0.3'
  end

  target 'DiscreteMoodWidget' do
    inherit! :search_paths
    pod 'SwiftDate', '6.0.3'
  end
end

target 'AttributeRestrictions' do
  project 'AttributeRestrictions/AttributeRestrictions'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
end

target 'Attributes' do
  project 'Attributes/Attributes'
  use_frameworks!

  pod 'Sourcery'
end

target 'BooleanAlgebra' do
  project 'BooleanAlgebra/BooleanAlgebra'
  use_frameworks!

  pod 'Sourcery'
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
end

target 'DataImport' do
  project 'DataImport/DataImport'
  use_frameworks!

  pod 'Sourcery'
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
  pod 'SwiftDate', '6.0.3'
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
end

target 'Persistence' do
  project 'Persistence/Persistence'
  use_frameworks!

  pod 'Sourcery'
  pod 'NotificationBannerSwift'
end

target 'Queries' do
  project 'Queries/Queries'
  use_frameworks!

  pod 'Sourcery'
end

target 'Samples' do
  project 'Samples/Samples'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
  pod 'CSV.swift', '~> 2.3.1'
end

target 'SampleGroupers' do
  project 'SampleGroupers/SampleGroupers'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
  pod 'CSV.swift', '~> 2.3.1'
  pod 'NotificationBannerSwift'
end

target 'SampleGroupInformation' do
  project 'SampleGroupInformation/SampleGroupInformation'
  use_frameworks!

  pod 'Sourcery'
  pod 'SwiftDate', '6.0.3'
end

target 'UIExtensions' do
  project 'UIExtensions/UIExtensions'
  use_frameworks!

  pod 'Sourcery'
  pod 'Instructions', '~> 1.2.2'
end
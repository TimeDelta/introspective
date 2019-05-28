# Uncomment the next line to define a global platform for your project
platform :ios, '12.0'

target 'Introspective' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod "Sourcery"
  pod "Presentr"
  pod 'SwiftDate', '6.0.3'
  pod 'AAInfographics'
  pod 'NotificationBannerSwift'
  pod 'CalendarKit'
  pod 'WSTagsField', '4.0'
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
    pod "SwiftDate"
  end
end

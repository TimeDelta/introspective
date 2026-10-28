#!/usr/bin/env ruby
# Run after pod install. Xcodeproj is supplied by CocoaPods.
# Generate a focused test target without changing the legacy suite or Podfile.
require 'xcodeproj'

Dir.chdir(File.expand_path('..', __dir__))
project = Xcodeproj::Project.open('Introspective.xcodeproj')
app = project.targets.find { |target| target.name == 'Introspective' }
raise 'Missing Introspective target' unless app
name = 'MoodHealthTests'
target = project.targets.find { |item| item.name == name }
unless target
  target = project.new_target(:unit_test_bundle, name, :ios, '18.0')
  group = project.main_group.new_group(name, name)
  target.add_file_references([group.new_file('MoodHealthExchangeTests.swift')])
  target.add_dependency(app)
end

target.build_configurations.each do |config|
  app_config = app.build_configurations.find { |item| item.name == config.name }
  raise "Missing app configuration #{config.name}" unless app_config
  # Reuse production pod search paths, not the legacy test/mocking dependencies.
  config.base_configuration_reference = app_config.base_configuration_reference
  config.build_settings.merge!(
    'PRODUCT_NAME' => '$(TARGET_NAME)',
    'PRODUCT_MODULE_NAME' => name,
    'TEST_TARGET_NAME' => 'Introspective',
    'PRODUCT_BUNDLE_IDENTIFIER' => 'com.bnova.Introspective.MoodHealthTests',
    'SWIFT_VERSION' => '5.0',
    'GENERATE_INFOPLIST_FILE' => 'YES',
    'TEST_HOST' => '$(BUILT_PRODUCTS_DIR)/Introspective.app/Introspective',
    'BUNDLE_LOADER' => '$(TEST_HOST)',
    'FRAMEWORK_SEARCH_PATHS' => ['$(inherited)', '$(BUILT_PRODUCTS_DIR)'],
    'LD_RUNPATH_SEARCH_PATHS' => ['$(inherited)', '@executable_path/Frameworks', '@loader_path/Frameworks'],
    'ENABLE_USER_SCRIPT_SANDBOXING' => 'NO'
  )
end
project.save

scheme = Xcodeproj::XCScheme.new('Introspective.xcodeproj/xcshareddata/xcschemes/CI-CD.xcscheme')
scheme.test_action.testables = [Xcodeproj::XCScheme::TestAction::TestableReference.new(target)]
scheme.test_action.build_configuration = 'Debug'
scheme.test_action.code_coverage_enabled = false
scheme.add_build_target(target, false)
scheme.save_as('Introspective.xcodeproj', name, true)
puts 'Prepared independent MoodHealthTests target and scheme'

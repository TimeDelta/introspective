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

%w[SavedQueryTests.swift ResultsProcessingTests.swift].each do |test_file|
  next if target.source_build_phase.files_references.any? { |ref| ref.path == test_file }
  raise "Missing native test source #{test_file}" unless File.exist?(File.join(name, test_file))
  group = project.main_group.groups.find { |item| item.name == name }
  target.add_file_references([group.new_file(test_file)])
end

# Compile the production transfer cells into the hostless lifecycle tests.
%w[
  Introspective/UI/RecordData/Activities/RecordActivityDefinitionTableViewCell.swift
  Introspective/UI/RecordData/Activities/ActivityTagsTableViewCell.swift
  Introspective/UI/RecordData/Activities/ActivityDefinitionTagsTableViewCell.swift
  Introspective/UI/ActiveImportTableViewCell.swift
  Introspective/UI/Settings/Export/ActiveExportTableViewCell.swift
  Introspective/UI/Results/ResultsProcessing.swift
  TestSupport/UITestFixtures.swift
  TestSupport/UITestFixtureLoader.swift
  Introspective/UI/Explore/MetricContextViewController.swift
].each do |path|
  reference = project.files.find { |file| file.real_path.to_s == File.expand_path(path) }
  raise "Missing production source #{path}" unless reference
  target.add_file_references([reference]) unless target.source_build_phase.files_references.include?(reference)
end

# Compile the actual app graph sources into the hostless regression target.
# They depend on production frameworks, not on the app's entry point or UI state.
%w[XYGraphDataGenerator SingleSampleTypeXYGraphDataGenerator].each do |basename|
  path = File.expand_path("Introspective/UI/Graphing/GraphDataGenerators/#{basename}.swift")
  reference = project.files.find { |file| file.real_path.to_s == path }
  raise "Missing production graph source #{path}" unless reference
  unless target.source_build_phase.files_references.include?(reference)
    target.add_file_references([reference])
  end
end

# Exercise the actual chart controller lifecycle without launching the application.
chart_path = File.expand_path('Introspective/UI/Graphing/GraphTypes/BasicXYGraph/BasicXYChartViewController.swift')
chart_reference = project.files.find { |file| file.real_path.to_s == chart_path }
raise 'Missing production chart controller source' unless chart_reference
unless target.source_build_phase.files_references.include?(chart_reference)
  target.add_file_references([chart_reference])
end

target.build_configurations.each do |config|
  app_config = app.build_configurations.find { |item| item.name == config.name }
  raise "Missing app configuration #{config.name}" unless app_config
  # Reuse production pod search paths, not the legacy test/mocking dependencies.
  config.base_configuration_reference = app_config.base_configuration_reference
  %w[TEST_HOST BUNDLE_LOADER TEST_TARGET_NAME].each { |key| config.build_settings.delete(key) }
  config.build_settings.merge!(
    'PRODUCT_NAME' => '$(TARGET_NAME)',
    'PRODUCT_MODULE_NAME' => name,
    'PRODUCT_BUNDLE_IDENTIFIER' => 'com.bnova.Introspective.MoodHealthTests',
    'SWIFT_VERSION' => '5.0',
    'GENERATE_INFOPLIST_FILE' => 'YES',
    'FRAMEWORK_SEARCH_PATHS' => ['$(inherited)', '$(BUILT_PRODUCTS_DIR)'],
    'LD_RUNPATH_SEARCH_PATHS' => ['$(inherited)', '@executable_path/Frameworks', '@loader_path/Frameworks'],
    'ENABLE_USER_SCRIPT_SANDBOXING' => 'NO'
  )
end
# Bundle the same versioned model and dynamic frameworks used by the app.
model = project.objects.find do |object|
  object.is_a?(Xcodeproj::Project::Object::XCVersionGroup) && object.path == 'Introspective.xcdatamodeld'
end
raise 'Missing production Core Data model' unless model
target.resources_build_phase.add_file_reference(model, true)
embed = target.copy_files_build_phases.find { |phase| phase.name == 'Embed production frameworks' }
embed ||= target.new_copy_files_build_phase('Embed production frameworks')
embed.dst_subfolder_spec = '10'
app.copy_files_build_phases.select { |phase| phase.dst_subfolder_spec == '10' }.each do |phase|
  phase.files.each do |file|
    next unless file.file_ref && file.file_ref.path.end_with?('.framework')
    copied = embed.add_file_reference(file.file_ref, true)
    copied.settings = { 'ATTRIBUTES' => ['CodeSignOnCopy', 'RemoveHeadersOnCopy'] }
  end
end
pods_embed = target.shell_script_build_phases.find { |phase| phase.name == 'Embed production pods' }
pods_embed ||= target.new_shell_script_build_phase('Embed production pods')
pods_embed.shell_script = '"${PODS_ROOT}/Target Support Files/Pods-Introspective/Pods-Introspective-frameworks.sh"'

project.save

scheme = Xcodeproj::XCScheme.new('Introspective.xcodeproj/xcshareddata/xcschemes/CI-CD.xcscheme')
scheme.test_action.testables = [Xcodeproj::XCScheme::TestAction::TestableReference.new(target)]
scheme.test_action.build_configuration = 'Debug'
# Include production sources compiled into the hostless bundle as well as frameworks.
scheme.test_action.code_coverage_enabled = true
scheme.test_action.add_code_coverage_target(Xcodeproj::XCScheme::BuildableReference.new(target))
scheme.add_build_target(target, false)
scheme.save_as('Introspective.xcodeproj', name, true)
puts 'Prepared independent MoodHealthTests target and scheme'

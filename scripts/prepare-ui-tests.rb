#!/usr/bin/env ruby
# Select the existing UI target without building the legacy unit-test mocks.
require 'xcodeproj'
Dir.chdir(File.expand_path('..', __dir__))
project = Xcodeproj::Project.open('Introspective.xcodeproj')
target = project.targets.find { |item| item.name == 'IntrospectiveUITests' }
raise 'Missing IntrospectiveUITests target' unless target
# CocoaPods can silently omit a nested runner's own dependency settings.
# Catch that configuration failure before compiling the full application.
target.build_configurations.each do |configuration|
  reference = configuration.base_configuration_reference
  raise "Missing UI CocoaPods configuration for #{configuration.name}" unless reference && reference.real_path.file?
  contents = reference.real_path.read
  unless contents.include?('SwiftDate') && !contents.include?('AAInfographics')
    raise "UI CocoaPods configuration must link SwiftDate without application-only pods"
  end
end
embed_script = 'Pods/Target Support Files/Pods-IntrospectiveUITests/Pods-IntrospectiveUITests-frameworks.sh'
unless File.file?(embed_script) && File.read(embed_script).include?('SwiftDate.framework')
  raise 'Missing SwiftDate embedding in UI runner'
end
scheme = Xcodeproj::XCScheme.new('Introspective.xcodeproj/xcshareddata/xcschemes/CI-CD.xcscheme')
testable = Xcodeproj::XCScheme::TestAction::TestableReference.new(target)
testable.parallelizable = true
scheme.test_action.testables = [testable]
scheme.add_build_target(target, false)
scheme.save_as('Introspective.xcodeproj', 'UIRegressionTests', true)
puts 'Prepared UIRegressionTests scheme for the original UI suite'

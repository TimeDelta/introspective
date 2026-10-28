#!/usr/bin/env ruby
# Select the existing UI target without building the legacy unit-test mocks.
require 'xcodeproj'
Dir.chdir(File.expand_path('..', __dir__))
project = Xcodeproj::Project.open('Introspective.xcodeproj')
target = project.targets.find { |item| item.name == 'IntrospectiveUITests' }
raise 'Missing IntrospectiveUITests target' unless target
scheme = Xcodeproj::XCScheme.new('Introspective.xcodeproj/xcshareddata/xcschemes/CI-CD.xcscheme')
scheme.test_action.testables = [Xcodeproj::XCScheme::TestAction::TestableReference.new(target)]
scheme.add_build_target(target, false)
scheme.save_as('Introspective.xcodeproj', 'UIRegressionTests', true)
puts 'Prepared UIRegressionTests scheme for the original UI suite'

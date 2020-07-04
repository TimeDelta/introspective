# Introspective: A data-driven approach to introspection


## Getting Started
### Setting up Git pre-commit hook (optional)
1. If you are using a Mac, you will need to download [this file](https://github.com/TimeDelta/dotfiles/blob/master/compile/realpath.c), compile it and add it to your PATH.
1. You will also need to download [this Python script](https://github.com/TimeDelta/dotfiles/blob/master/osx_bin/xunique) and add it to your PATH.
1. In terminal, navigate to the root clone directory and run `cd .git/hooks`
1. Run `ln -s ../../scripts/pre-commit .`


## Dependencies
For dependency management, [CocoaPods](https://cocoapods.org) is used. See [Podfile](./Podfile) for configuration.


## Build Targets
There are 5 main build targets in this project:
- **Release**: This target does aggressive optimizations and is the only target that should be used to release a new version of the app.
- **Testing**: This target runs all tests (Unit, Functional and UI) and also provides some additional useful sections in the settings tab.
- **Non-UI Testing**: This target will only run Unit and Functional tests but not any UI Tests. It does not provide the same sections under the settings tab that the "Testing" target does.
- **DiscreteMoodWidget**: This target can be used to debug the [DiscreteMoodWidget](DiscreteMoodWidget).
- **SiriIntents**: This target can be used to debug the commands under [SiriIntents directory](SiriIntents)


## Tests
There are 3 different types of tests in this project:
- [UnitTest](IntrospectiveTests/UnitTests/UnitTest.swift) - There are many of these and each one is very quick and specific as to what it tests.
- [FunctionalTest](IntrospectiveTests/FunctionalTests/FunctionalTest.swift) - Functional tests use very little mocking and test the full stack from a specific class down.
- [UITest](IntrospectiveUITests/UITest.swift) - Fragile but test the entirety of the stack all at once.


### Mocks
This project uses [SwiftyMocky](https://github.com/MakeAWishFoundation/SwiftyMocky) for mocking. This is why you will sometimes find `//sourcery: AutoMockable` on some protocols. As part of the build process, `rake mock` is ran in a Run Script Build Phase. Running `rake mock` in the root project directory will search for and regenerate any mockable protocols (marked with the previously mentioned comment) and any custom mocks that are in the [CustomMocks directory](IntrospectiveTests/CustomMocks) as defined by the [Rakefile](./Rakefile) and the [SwiftyMocky config generation script](./gen-swifty-mocky-config-files.sh).


### Test Pre-requisites
Any time you need to run a FunctionalTest class that requires Health App integration on a new simulator, you will first need to:
1. Run the "Testing" target on the target iPhone simulator
1. Go to the "Explore" tab in the app
1. Choose "Query"
1. Tap the only present TableViewCell
1. Choose a data type that exists in the Health App
1. Tap "Save"
1. Tap "Run"
1. Tap "Turn All Categories On"
1. Tap "Allow"
1. Close simulator

All FunctionalTest classes should now run properly on the target simulator.

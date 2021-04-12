# Introspective: A data-driven approach to introspection

## Contents
- [Features](#main-features)
- [Getting Started](#getting-started)
- [Dependencies](#dependencies)
- [Build Targets](#build-targets)
- [Tests](#tests)
- [Future Plans](#future-plans)
- [Privacy Policy](#privacy-policy)

## What is this?
Introspective is an iOS app that is focused on both mental and physical health. It is a new way to explore your health data. It allows you to write custom (easy-to-understand) queries against your data and create custom graphs that can show the relationship between different pieces of your health data. This app is available for download at https://apps.apple.com/us/app/introspective/id1521706312. This has been a passion project of mine for a few years now and I recently decided to make it open source instead of trying to sell it one day. I decided this even after starting an LLC to sell it on the App Store because I think that it has a lot of potential to help people and because I have other responsibilities (like a full time job) that don't leave enough room for where I want this to go so I need help with it.

### Main Features
#### Custom queries
Explore your data in a unique way by querying for exactly the records in which you're interested. Specify complex conditions on any attribute for any supported data type by combining them using "and", "or", and condition groups (full boolean algebra support with grouping). Even better, you can limit your query further by looking at other data types within the query. For example, you can find all moods that were recorded within a half hour of socializing.

#### Custom graphs
Use custom queries to specify exactly which data points you want to graph. The following graphs are available:
  - Line Chart
  - Bar Chart
  - Scatter Plot

Use queries to find trends between two different types of data (i.e. how your heart rate affects your mood).
Show multiple values (i.e. avg mood, min mood) over time in the same graph.
Specify how to group data into a single value for each point (i.e. avg mood per hour).


#### Apple Health integration
Introspection integrates with a number of data types from the Apple Health app, allowing you to query against them. For a full list of supported data types, see the list below.

#### Siri integration (Shortcuts app)
  - Record mood (decimal)
  - Record mood (integer)
  - Start activities
  - Start activity
  - Start activity from end of last stopped activity
  - Start activity [number] [time-units] ago
  - Stop activities
  - Stop all activities
  - Stop last started activity
  - Take a medication using default dosage
  - Take a medication with specific dosage
  - Is [date] a weekday

#### Data import / export
  - import activity data from "ATracker"
  - import medication history from "EasyPill"
  - import moods from "Wellness"
  - import from Introspective export
  - export activities, medications or moods to CSV file


#### Data Types
The following data types are supported (with more to come, guaranteed):

**?** = optional field
  - Activity (what you're doing and when you're doing it)
    - Definition (common to all instances of the activity so that you don't have to constantly type everything)
      - Name
      - Description **?**
      - Common Tags **?**
      - Source (the name of the app that generated this record - automatically recorded)
    - Start Time (with time zone)
    - End Time **?** (with time zone)
    - Additional Tags **?** (only appear on this instance of the activity)
    - Note **?**
    - Source (the name of the app that generated this record - automatically recorded)
  - Blood Pressure (from Apple Health app)
  - Body Mass Index (from Apple Health app)
  - Fatigue (with customizable scale)
    - Timestamp (with time zone)
    - Rating
    - Note **?**
    - Source (the name of the app that generated this record - automatically recorded)
  - Heart Rate (from Apple Health app)
  - Lean Body Mass (from Apple Health app)
  - Medication Dose
    - Medication Definition (common to all doses of this medication)
      - Name
      - Started On **?** (when did you start taking this medication)
      - Frequency **?** (how frequently are you supposed to take this medication)
      - Default Dosage **?** (use this dosage every time you quick take this medication)
      - Notes **?** (anything else you want to remember about this medication)
      - Source (the name of the app that generated this record - automatically recorded)
    - Timestamp (with time zone)
    - Dosage **?** (how much of this medication you took this time)
    - Source (the name of the app that generated this record - automatically recorded)
  - Mood (with customizable scale)
    - Timestamp (with time zone)
    - Rating
    - Note **?**
    - Source (the name of the app that generated this record - automatically recorded)
  - Resting Heart Rate (from Apple Health app)
  - Sexual Activity (from Apple Health app)
  - Sleep (from Apple Health app)
  - Weight (from Apple Health app)

## Getting Started
### Code Formatting
Code formatting is done via [SwiftFormat](https://github.com/nicklockwood/SwiftFormat). You _**must**_ [install it](https://github.com/nicklockwood/SwiftFormat#how-do-i-install-it) for the build to work because all non-test code is automatically formatted during the build process.
#### Links
- [Rule Descriptions](https://github.com/nicklockwood/SwiftFormat/blob/master/Rules.md)
- [Enabled Code Formatting Rules](config/enabled-code-format-rules.txt)
- [Disabled Code Formatting Rules](config/disabled-code-format-rules.txt)
- [Code Formatting Script](scripts/format-code)


### Setting up Git pre-commit hook (optional for build but needed to contribute)
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


### Mocks
This project uses [SwiftyMocky](https://github.com/MakeAWishFoundation/SwiftyMocky) for mocking. This is why you will sometimes find `//sourcery: AutoMockable` on some protocols. As part of the build process, `rake mock` is ran in a Run Script Build Phase. Running `rake mock` in the root project directory will search for and regenerate any mockable protocols (marked with the previously mentioned comment) and any custom mocks that are in the [CustomMocks directory](IntrospectiveTests/CustomMocks) as defined by the [Rakefile](./Rakefile) and the [SwiftyMocky config generation script](./gen-swifty-mocky-config-files.sh).


## Future Plans
Currently, this project uses a public [Trello board](https://trello.com/b/jmYSr5bx/introspective), though this may be migrated to something else in the future. Feel free to take a look.

## Privacy Policy
From the very beginning of this project, I decided that privacy and security were the number one priorities. As such, any and all of your data NEVER leaves your phone (unless you export it). Don't believe me? Look at the source code yourself.

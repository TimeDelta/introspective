# Introspective: A data-driven approach to introspection

## Contents
- [What is this?](#what-is-this)
- [Why?](#why)
- [The dangers of doing this wrong](#the-dangers-of-doing-this-wrong)
- [Choosing the right recording method](#choosing-the-right-recording-method)
- [Features](#main-features)
- [Getting Started](#getting-started)
- [Dependencies](#dependencies)
- [Build Targets](#build-targets)
- [Tests](#tests)
- [Future Plans](#future-plans)
- [Privacy Policy](#privacy-policy)

## What is this?
Introspective is an iOS app that is focused on both mental and physical health. It is a new way to explore your health data. It allows you to write custom (easy-to-understand) queries against your data and create custom graphs that can show the relationship between different pieces of your health data. Self-tracking, as it is sometimes called, has a lot of potential value to offer. This tool helps you harness that value. It is available to download for free on the App Store at https://apps.apple.com/us/app/introspective/id1521706312

## Why?
My goal is to change the way medicine is practiced by adapting experimental design to the individual. The problem with many studies is the shallowness of their analysis, which is necessitated in real world population statistics because of the lack of controllability and the chaotic complexity of the human body. The lack of controllability is born out of the fact that it is very difficult to get patients to be consistent with each other and thus to accurately determine the exact causes of symptoms, which side effects of a medication are real, etc. in a given population. The failure of this type of analysis is that it tries to apply too broadly and generalize too much. This type of analysis indeed has tremendous value and has been used to a large degree of success for many things in at least the past century. However, we cannot possibly control for everything in the real world across patients. Everybody’s life is different and nobody is going to have the same requirements and it could be unethical to force somebody to only receive one treatment for something at a time, depending on their situation. It is, however, easy to get a patient to be consistent with themself, thus simultaneously addressing this problem of controllability and, to a lesser extent, the issue of the chaotic complexity of the human body. This partially solves for the complexity of the human body only because it removes a number of variables that vary more when comparing across individuals. There is, however, still the issue of changes within an individual (their metabolism, etc.) over time to be dealt with and since we don’t compare to other people, we have to replace the control group (e.g. what would have happened if the variable wasn’t changed) with something else. This is where there is an opportunity to borrow from economics. The idea of a proxy (similar to a heuristic in AI) can be used to do pseudo-controlled experiments with an individual patient. By focusing on a single individual, we eliminate the burden of medical knowledge to always generalize to other people’s situations. The most important part (and a vital piece) about this method, though, is education of people on how to properly use it. It also allows the use of data to quantify on an individual level less conventional methods that may be less expensive. Further benefit can be derived in the form of preventative measures. For example, monitoring mood journals for suicidal ideation or bipolar disorder. For psychiatry in particular, this could also allow the doctor to spend more time with each patient by providing them with a sort of dashboard for checkup appointments based on a patient’s diagnoses instead of them having to spend 5-10 mins asking each ongoing patient every time how they’ve been feeling over the past x months, etc (Importantly, this data would never have to leave the user’s mobile device as they can just bring it with them to show the doctor instead of transmitting the data, eliminating almost all privacy concerns from a technical level as far as compliance with HIPAA). This data can also allow be used for “augmented” introspection for an individual with lower than average emotional intelligence (perhaps one with ASD like myself) by automatically looking for trends in their mood across activities / days of the week, etc. and prompting them with questions of why they think the found correlations might be, as well as other appropriate questions. This would prep the patient to be thinking about things in between appointments. Not only would this be a better patient outcome, allowing them to have more independence and be better able to communicate their needs, but it would also reduce the amount of financial burden on insurance companies and the time burden on medical staff by increasing the efficiency of time spent by a therapist / counselor, allowing for both a reduction in the amount of time they need to spend with the patient and faster outcomes. The value of these and other preventative measures based on the tracked data is compounded even more when you consider the current shortage of doctors in the US and other countries.

## The dangers of doing this wrong
### The echo chamber
### Distorted data: tracking bias
### This is not a replacement for doctors or for the type of population studies done for medications, merely a supplement.

## Choosing the right recording method
There are many things to consider when choosing a recording method. For most people, your phone is going to be your new best friend. For those of you wanting to use a more analog approach, this section won’t be useful. If you’re still reading, you’ll want to find an app for recording (even if it’s just a spreadsheet in Numbers / Excel). The priorities I’ve fleshed out for choosing an app, their order and justifications for them are listed below.
1. Privacy - Without privacy, there is risk of degradation to the individual’s amount of honesty with themself when they look back on their data. Without honesty, this method is useless.
1. Exportability / Backup - This is critically important if you are using multiple apps for recording and want to have any hope of correlating different pieces of data together. Beyond that, I’ve also lost data multiple times before due to either a bug in an app or losing my phone, etc. It sucks, especially when you’re in the middle of an experiment. If an app allows you to export your data (as a CSV, to Apple Health, etc.), at least you won’t lose that data if you export it on a regular basis.
1. Importability - Similar reasoning to the exportability / backup but it’s really nice to be able to import lost data back into the app or data from a different app if needed in order to check data correlations.
1. Ease of recording - In my experience, if it’s not extremely easy (< 3-5 secs in my experience) to record something, you will be less likely to record it with high frequency. This makes it harder to build a habit and it makes the data less useful. I highly recommend taking the time to set up your phone’s personal assistant to understand custom voice commands for recording things. This makes my life so much easier and has even made it feel less rude to observers that I frequently use my phone during a conversation because they know that I’m tracking something medical instead of playing with my phone because I’m bored or something.
1. Ease of analyzing - I put this below ease of recording because (again speaking from experience), once you have the data, there is extra incentive to analyze the data in order to avoid having wasted your time. This doesn’t go that far, though, and I have actually decided to stop doing certain uncontrolled “look-back” analyses before because it was too difficult to get all the required data together in order to analyze it.
Of course, this ordering ignores what conditions you have and how they matter but the main point is to provide a starting point for your list of priorities. As such, you should modify this list to fit your needs. For example, you may need to prioritize ease of recording over everything else due to hand mobility issues.


## Main Features
### Custom queries
Explore your data in a unique way by querying for exactly the records in which you're interested. Specify complex conditions on any attribute for any supported data type by combining them using "and", "or", and condition groups (full boolean algebra support with grouping). Even better, you can limit your query further by looking at other data types within the query. For example, you can find all moods that were recorded within a half hour of socializing.

### Custom graphs
Use custom queries to specify exactly which data points you want to graph. The following graphs are available:
  - Line Chart
  - Bar Chart
  - Scatter Plot

Use queries to find trends between two different types of data (i.e. how your heart rate affects your mood).
Show multiple values (i.e. avg mood, min mood) over time in the same graph.
Specify how to group data into a single value for each point (i.e. avg mood per hour).


### Apple Health integration
Introspection integrates with a number of data types from the Apple Health app, allowing you to query against them. For a full list of supported data types, see the list below.

### Siri integration (Shortcuts app)
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

### Data import / export
  - import activity data from "ATracker"
  - import medication history from "EasyPill"
  - import moods from "Wellness"
  - import from Introspective export
  - export activities, medications or moods to CSV file


### Data Types
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
  - Dietary Sugar (from Apple Health app)
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

## Getting Started with contributing
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

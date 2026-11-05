import UIKit

#if DEBUG
UILaunchProfileRecorder.activate(environment: ProcessInfo.processInfo.environment,
	isUITesting: CommandLine.arguments.contains("--ui-testing"))
UILaunchProfileRecorder.current?.record(.processEntry)
#endif

UIApplicationMain(CommandLine.argc, CommandLine.unsafeArgv, nil, NSStringFromClass(AppDelegate.self))

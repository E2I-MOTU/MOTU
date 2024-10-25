import Flutter
import flutter_local_notifications
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    var applicationLifeCycleChannel: FlutterBasicMessageChannel!

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
        }

        GeneratedPluginRegistrant.register(with: self)

        applicationLifeCycleChannel = FlutterBasicMessageChannel(
            name: "applicationLifeCycle",
            binaryMessenger: (window?.rootViewController as! FlutterViewController).binaryMessenger,
            codec: FlutterStringCodec.sharedInstance()
        )
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func applicationWillTerminate(_ application: UIApplication) {
        applicationLifeCycleChannel.sendMessage("applicationWillTerminate")
    }
}

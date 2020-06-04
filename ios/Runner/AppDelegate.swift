import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    // google map api key
    GMSServices.provideAPIKey("AIzaSyAvuYMPGFLyeaHcD6T6pgoPZqHP0NtUz5s");
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

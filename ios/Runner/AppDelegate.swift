import UIKit
import Flutter
import Firebase
import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      FirebaseApp.configure()
      GMSServices.provideAPIKey("AIzaSyBcI2mPewamGg8bSTwZFAD0QNaXLgb84Cc")
    GeneratedPluginRegistrant.register(with: self)
      UIApplication.shared.setMinimumBackgroundFetchInterval(TimeInterval(10))
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

import UIKit
import Flutter
//import GoogleMaps

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
  //  GMSServices.provideAPIKey("AIzaSyAJU7Qd9F9kj18nMnXSNB3Vodf0r4fhHOY")
  GMSServices.provideAPIKey("AIzaSyDC9WFXg8tjm5UlquX9IVSb2Mkv1wiQjFk")
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

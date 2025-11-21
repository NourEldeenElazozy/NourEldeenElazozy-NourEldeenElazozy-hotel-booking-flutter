import UIKit
import Flutter
import GoogleMaps
import FirebaseCore
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GMSServices.provideAPIKey("AIzaSyDC9WFXg8tjm5UlquX9IVSb2Mkv1wiQjFk")
      // ✅ Firebase
      FirebaseApp.configure()

      // ✅ Flutter plugins
      GeneratedPluginRegistrant.register(with: self)

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
  }
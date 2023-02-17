import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // WORKROUND: keep symbols of static library libk8z.a
      print("FreePointer address: \(K8zRequest)")
      print("FreePointer address: \(FreePointer)")
      print("FreePointer address: \(LocalServerAddr)")
      print("FreePointer address: \(StartLocalServer)")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

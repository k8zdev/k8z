import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // WORKROUND: keep symbols of static library libk8z.a
      print("FreePointer address: \(String(describing: K8zRequest))")
      print("FreePointer address: \(String(describing: FreePointer))")
      print("FreePointer address: \(String(describing: LocalServerAddr))")
      print("FreePointer address: \(String(describing: StartLocalServer))")
      print("FreePointer address: \(String(describing: Json2yaml))")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

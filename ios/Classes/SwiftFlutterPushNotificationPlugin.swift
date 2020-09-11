import Flutter
import UIKit

// also ref: https://github.com/mwaylabs/flutter-apns/blob/master/ios/Classes/FlutterApnsPlugin.m
public class SwiftFlutterPushNotificationPlugin: NSObject, FlutterPlugin, FPNFlutterPushNotificationHostApi {
    
    static var instance: SwiftFlutterPushNotificationPlugin? = nil
    
    var flutterApi: FPNFlutterPushNotificationFlutterApi
    
    public init(registrar: FlutterPluginRegistrar) {
        flutterApi = FPNFlutterPushNotificationFlutterApi(binaryMessenger: registrar.messenger())
        super.init()
    }
    
    public static func register(with registrar: FlutterPluginRegistrar) {
        // ref https://github.com/flutter/plugins/blob/master/packages/video_player/video_player/ios/Classes/FLTVideoPlayerPlugin.m
        let newInstance = SwiftFlutterPushNotificationPlugin(registrar: registrar)
        FPNFlutterPushNotificationHostApiSetup(registrar.messenger(), newInstance)
        
        if instance != nil { NSLog("WARN: SwiftFlutterPushNotificationPlugin already has an instance, overwriting.") }
        instance = newInstance
    }
    
    public func triggerRegister(_ input: FPNTriggerRegisterArg, error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        NSLog("triggerRegister start")
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, e in
                NSLog("iosRegister callback of requestAuthorization \(granted) \(String(describing: e))")
                if granted {
                    DispatchQueue.main.async {
                        NSLog("iosRegister actually call registerForRemoteNotifications")
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    let r = FPNIosRegisterCallbackArg()
                    r.success = false
                    r.errorMessage = "Permission is not granted (with optional error: \(String(describing: e))"
                    self.flutterApi.iosRegisterCallback(r, completion: {e in })
                }
            }
        } else {
            error.pointee = FlutterError(code: "flutter_push_notification", message: "iOS version is too old to call requestAuthorization", details: nil)
            return
        }
    }
    
    public func androidGetRegisterId(_ error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        error.pointee = FlutterError(code: "flutter_push_notification", message: "unsupported method", details: nil)
    }
    
    // TODO 写文档解释，必须在主程序的AppDelegate.swift中加一行调用这个的
    public static func hack_application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        NSLog("didRegisterForRemoteNotificationsWithDeviceToken deviceToken=\(deviceToken)")
        // https://stackoverflow.com/a/24979958/4619958
        let deviceTokenStr = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        
        let r = FPNIosRegisterCallbackArg()
        r.success = true
        r.deviceToken = deviceTokenStr
        instance!.flutterApi.iosRegisterCallback(r, completion: {e in })
    }
    
    // TODO 写文档解释，必须在主程序的AppDelegate.swift中加一行调用这个的
    public static func hack_application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        NSLog("didFailToRegisterForRemoteNotificationsWithError \(error)")
        let r = FPNIosRegisterCallbackArg()
        r.success = false
        r.errorMessage = "\(error)"
        instance!.flutterApi.iosRegisterCallback(r, completion: {e in })
    }
    
}

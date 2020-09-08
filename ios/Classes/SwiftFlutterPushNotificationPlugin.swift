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
    
    public func iosRegister(forRemoteNotifications error: AutoreleasingUnsafeMutablePointer<FlutterError?>) {
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let r = FPNIosDidRegisterRequest()
        r.deviceTokenBase64 = deviceToken.base64EncodedString()
        flutterApi.iosDidRegister(r, completion: {e in })
    }
    
    // TODO 写文档解释，必须在主程序的AppDelegate.swift中加一行调用这个的
    static func hack_application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        instance!.flutterApi.iosFailedRegister({e in })
    }
    
}

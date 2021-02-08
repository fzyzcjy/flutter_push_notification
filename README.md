# FlutterPushNotification 混合推送（安卓6个厂商推送 + 苹果APNs）

### Setup

### Android

1. Add line to your proguard rules by reading [this document](https://github.com/taoweiji/MixPush#%E6%B7%B7%E6%B7%86%E9%85%8D%E7%BD%AE)

### iOS

1. In your `AppDelegate.swift`, add the following lines

```
// 1. add the import at the top
import flutter_push_notification

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  
    ...
    
    // 2. inside AppDelegate, forward these two functions to our plugin
    override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        SwiftFlutterPushNotificationPlugin.hack_application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
    }
    override func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // NOTE: do NOT need super.application(...) for THIS method
        SwiftFlutterPushNotificationPlugin.hack_application(application, didFailToRegisterForRemoteNotificationsWithError: error)
    }
}

```


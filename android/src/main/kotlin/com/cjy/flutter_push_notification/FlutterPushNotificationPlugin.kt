package com.cjy.flutter_push_notification

import android.app.Activity
import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.cjy.flutter_push_notification.Messages.*
import com.mixpush.core.*
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

/** FlutterPushNotificationPlugin */
class FlutterPushNotificationPlugin : FlutterPlugin, FlutterPushNotificationHostApi, ActivityAware {

    private var context: Context? = null

    // NOTE 关于得到context/activity
    // https://stackoverflow.com/questions/60048704/how-to-get-activity-and-context-in-flutter-plugin
    // https://github.com/Sh1d0w/multi_image_picker/blob/master/android/src/main/java/com/vitanov/multiimagepicker/MultiImagePickerPlugin.java#L599
    private var activity: Activity? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        // ref: https://github.com/flutter/plugins/blob/master/packages/video_player/video_player/android/src/main/java/io/flutter/plugins/videoplayer/VideoPlayerPlugin.java#L210
        FlutterPushNotificationHostApi.setup(flutterPluginBinding.binaryMessenger, this)
        flutterApi = FlutterPushNotificationFlutterApi(flutterPluginBinding.binaryMessenger)
        context = flutterPluginBinding.applicationContext
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        FlutterPushNotificationHostApi.setup(binding.binaryMessenger, null)
        flutterApi = null
        context = null
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun triggerRegister(arg: TriggerRegisterArg?) {
        Log.i(TAG, "triggerRegister start")

        MixPushClient.getInstance().register(context, arg!!.androidDefaultPlatform!!)

        Log.i(TAG, "triggerRegister end")
    }

    override fun androidGetRegisterId() {
        MixPushClient.getInstance().getRegisterId(context, object : GetRegisterIdCallback() {
            override fun callback(platform: MixPushPlatform?): Unit {
                Log.i(TAG, "GetRegisterIdCallback $platform")

                flutterApi!!.androidGetRegisterIdCallback(AndroidGetRegisterIdCallbackArg().apply {
                    success = platform != null
                    platformName = platform?.platformName
                    regId = platform?.regId
                }) {}
            }
        })
    }

    companion object {
        var flutterApi: FlutterPushNotificationFlutterApi? = null

        private const val TAG = "FlutterPushNotification"

        // NOTE 在android的Application启动时，必须调用这个！否则不会进行任何注册
        fun handleApplicationOnCreate() {
            Log.i(TAG, "handleApplicationOnCreate start")

            MixPushClient.getInstance().setLogger(object : MixPushLogger {
                override fun log(tag: String?, content: String?, throwable: Throwable?) {
                    Log.i(tag, content, throwable); }

                override fun log(tag: String?, content: String?) {
                    Log.i(tag, content); }
            })

            MixPushClient.getInstance().setPushReceiver(MyMixedPushReceiver)

            Log.i(TAG, "handleApplicationOnCreate end")
        }
    }

    // debug get huawei app id
//    val appId = AGConnectServicesConfig.fromContext(context).getString("client/app_id");
//    Log.i(TAG, "debug huawei appId: $appId")

}


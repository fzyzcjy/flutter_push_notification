package com.cjy.flutter_push_notification

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.cjy.flutter_push_notification.Messages.*
import com.mixpush.core.*
import io.flutter.embedding.engine.plugins.FlutterPlugin

/** FlutterPushNotificationPlugin */
class FlutterPushNotificationPlugin : FlutterPlugin, FlutterPushNotificationHostApi {

    private var context: Context? = null

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

    override fun triggerRegister() {
        val mixPushClient = MixPushClient.getInstance()

        mixPushClient.setLogger(object : MixPushLogger {
            override fun log(tag: String?, content: String?, throwable: Throwable?) {
                Log.i(tag, content, throwable);
            }

            override fun log(tag: String?, content: String?) {
                Log.i(tag, content);
            }
        });

        mixPushClient.setPushReceiver(object : MixPushReceiver() {
            override fun onRegisterSucceed(context: Context?, mixPushPlatform: MixPushPlatform?) {
                Log.i(TAG, "onRegisterSucceed platform=$mixPushPlatform")
                if (flutterApi == null) Log.w(TAG, "no flutterApi for callback")

                flutterApi?.androidOnRegisterSucceedCallback(AndroidOnRegisterSucceedCallbackArg().apply {
                    platformName = mixPushPlatform?.platformName
                    regId = mixPushPlatform?.regId
                }){}
            }

            // NOTE 这个函数被调用时，flutter应该是没启动的(?)，因为整个后台可能早就被kill掉了
            override fun onNotificationMessageClicked(context: Context?, message: MixPushMessage?) {
                Log.i(TAG, "onNotificationMessageClicked message=$message")
                // TODO 暂时直接打开app，之后修改，比如把message传入flutter等等
                MixPushClient.getInstance().openApp(context)
            }
        })

        mixPushClient.register(context)
    }

    override fun androidGetRegisterId() {
        MixPushClient.getInstance().getRegisterId(context, object : GetRegisterIdCallback() {
            override fun callback(platform: MixPushPlatform?): Unit {
                Log.i("GetRegisterIdCallback", platform.toString())

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

        const val TAG = "FlutterPushNotification"

    }
}

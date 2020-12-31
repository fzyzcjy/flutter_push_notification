package com.cjy.flutter_push_notification

import android.content.Context
import android.os.Handler
import android.os.Looper
import android.util.Log
import com.mixpush.core.MixPushClient
import com.mixpush.core.MixPushMessage
import com.mixpush.core.MixPushPlatform
import com.mixpush.core.MixPushReceiver

// 使用singleton，避免多个实例时各种奇怪问题
object MyMixedPushReceiver : MixPushReceiver() {
    private const val TAG = "MyMixedPushReceiver"

    override fun onRegisterSucceed(context: Context?, mixPushPlatform: MixPushPlatform?) {
        Log.i(TAG, "onRegisterSucceed platform=$mixPushPlatform")

        // 这个getMainLooper实际上是runOnUiThread https://stackoverflow.com/questions/11123621
        Handler(Looper.getMainLooper()).post {
            Log.i(TAG, "onRegisterSucceed run on main looper")

            if (FlutterPushNotificationPlugin.flutterApi != null) {
                Log.i(TAG, "onRegisterSucceed call flutterApi")
                val arg = Messages.AndroidOnRegisterSucceedCallbackArg().apply {
                    platformName = mixPushPlatform?.platformName
                    regId = mixPushPlatform?.regId
                }
                FlutterPushNotificationPlugin.flutterApi!!.androidOnRegisterSucceedCallback(arg) {}
            } else {
                Log.e(TAG, "no flutterApi for callback, ignore")
            }
        }
    }

    // NOTE 这个函数被调用时，flutter应该是没启动的(?)，因为整个后台可能早就被kill掉了
    override fun onNotificationMessageClicked(context: Context?, message: MixPushMessage?) {
        Log.i(TAG, "onNotificationMessageClicked message=$message")
        // NOTE 暂时直接打开app; 之后可以修改，比如把message传入flutter等等
        MixPushClient.getInstance().openApp(context)
    }

}
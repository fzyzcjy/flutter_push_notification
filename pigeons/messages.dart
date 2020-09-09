import 'package:pigeon/pigeon_lib.dart';

class IosRegisterCallbackArg {
  bool success;
  String deviceToken;
  String errorMessage;
}

class AndroidOnRegisterSucceedCallbackArg {
  String platformName;
  String regId;
}

class AndroidGetRegisterIdCallbackArg {
  bool success;
  String platformName;
  String regId;
}

@HostApi()
abstract class FlutterPushNotificationHostApi {
  void triggerRegister();

  // NOTE GetRegisterId是直接读取regid，搭配androidGetRegisterIdCallback; 不同于triggerRegister是调用整个注册流程
  void androidGetRegisterId();
}

@FlutterApi()
abstract class FlutterPushNotificationFlutterApi {
  void iosRegisterCallback(IosRegisterCallbackArg arg);

  void androidOnRegisterSucceedCallback(AndroidOnRegisterSucceedCallbackArg arg);

  void androidGetRegisterIdCallback(AndroidGetRegisterIdCallbackArg arg);
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = 'lib/src/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'FPN';
  opts.javaOut = 'android/src/main/java/com/cjy/flutter_push_notification/Messages.java';
  opts.javaOptions.package = 'com.cjy.flutter_push_notification';
}

import 'package:pigeon/pigeon_lib.dart';

class IosDidRegisterCallbackArg {
  bool success;
  String deviceToken;
  String errorMessage;
}

@HostApi()
abstract class FlutterPushNotificationHostApi {
  void iosRegister();
}

@FlutterApi()
abstract class FlutterPushNotificationFlutterApi {
  void iosRegisterCallback(IosDidRegisterCallbackArg arg);
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = 'lib/src/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'FPN';
  opts.javaOut = 'android/src/main/java/com/rzzsdxx/flutter_push_notification/Messages.java';
  opts.javaOptions.package = 'com.rzzsdxx.flutter_push_notification';
}

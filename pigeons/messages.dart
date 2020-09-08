import 'package:pigeon/pigeon_lib.dart';

class IosDidRegisterRequest {
  String deviceToken;
}

class IosFailRegisterRequest {
  String error;
}

@HostApi()
abstract class FlutterPushNotificationHostApi {
  void iosRegisterForRemoteNotifications();
}

@FlutterApi()
abstract class FlutterPushNotificationFlutterApi {
  void iosDidRegister(IosDidRegisterRequest request);

  void iosFailedRegister(IosFailRegisterRequest request);
}

void configurePigeon(PigeonOptions opts) {
  opts.dartOut = 'lib/src/messages.dart';
  opts.objcHeaderOut = 'ios/Classes/messages.h';
  opts.objcSourceOut = 'ios/Classes/messages.m';
  opts.objcOptions.prefix = 'FPN';
  opts.javaOut = 'android/src/main/java/com/rzzsdxx/flutter_push_notification/Messages.java';
  opts.javaOptions.package = 'com.rzzsdxx.flutter_push_notification';
}

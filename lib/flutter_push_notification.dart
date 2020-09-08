import 'dart:io';

import 'package:flutter_push_notification/src/messages.dart';

class FlutterPushNotification {
  static _FlutterApiHandler _flutterApiHandler;

  final _hostApi = FlutterPushNotificationHostApi();

  FlutterPushNotification() {
    if (_flutterApiHandler == null) {
      _flutterApiHandler = _FlutterApiHandler();
      FlutterPushNotificationFlutterApi.setup(_flutterApiHandler);
    }
  }

  void register() {
    if (Platform.isIOS) {
      // NOTE even if AWAIT for this method, the future completes does NOT mean the register FINISHES!
      // thus DO NOT AWAIT this
      _hostApi.iosRegisterForRemoteNotifications();
      return;
    }
    throw Exception('unsupported platform');
  }
}

class _FlutterApiHandler implements FlutterPushNotificationFlutterApi {
  @override
  void iosDidRegister(IosDidRegisterRequest arg) {
    print('iosDidRegister deviceToken=${arg.deviceToken}');
    // TODO
  }

  @override
  void iosFailedRegister(IosFailRegisterRequest arg) {
    print('iosFailedRegister ${arg.error}');
    // TODO
  }
}

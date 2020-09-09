// Autogenerated from Pigeon (v0.1.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import
import 'dart:async';
import 'package:flutter/services.dart';

class IosRegisterCallbackArg {
  bool success;
  String deviceToken;
  String errorMessage;
  // ignore: unused_element
  Map<dynamic, dynamic> _toMap() {
    final Map<dynamic, dynamic> pigeonMap = <dynamic, dynamic>{};
    pigeonMap['success'] = success;
    pigeonMap['deviceToken'] = deviceToken;
    pigeonMap['errorMessage'] = errorMessage;
    return pigeonMap;
  }
  // ignore: unused_element
  static IosRegisterCallbackArg _fromMap(Map<dynamic, dynamic> pigeonMap) {
    if (pigeonMap == null){
      return null;
    }
    final IosRegisterCallbackArg result = IosRegisterCallbackArg();
    result.success = pigeonMap['success'];
    result.deviceToken = pigeonMap['deviceToken'];
    result.errorMessage = pigeonMap['errorMessage'];
    return result;
  }
}

class AndroidOnRegisterSucceedCallbackArg {
  String platformName;
  String regId;
  // ignore: unused_element
  Map<dynamic, dynamic> _toMap() {
    final Map<dynamic, dynamic> pigeonMap = <dynamic, dynamic>{};
    pigeonMap['platformName'] = platformName;
    pigeonMap['regId'] = regId;
    return pigeonMap;
  }
  // ignore: unused_element
  static AndroidOnRegisterSucceedCallbackArg _fromMap(Map<dynamic, dynamic> pigeonMap) {
    if (pigeonMap == null){
      return null;
    }
    final AndroidOnRegisterSucceedCallbackArg result = AndroidOnRegisterSucceedCallbackArg();
    result.platformName = pigeonMap['platformName'];
    result.regId = pigeonMap['regId'];
    return result;
  }
}

class AndroidGetRegisterIdCallbackArg {
  bool success;
  String platformName;
  String regId;
  // ignore: unused_element
  Map<dynamic, dynamic> _toMap() {
    final Map<dynamic, dynamic> pigeonMap = <dynamic, dynamic>{};
    pigeonMap['success'] = success;
    pigeonMap['platformName'] = platformName;
    pigeonMap['regId'] = regId;
    return pigeonMap;
  }
  // ignore: unused_element
  static AndroidGetRegisterIdCallbackArg _fromMap(Map<dynamic, dynamic> pigeonMap) {
    if (pigeonMap == null){
      return null;
    }
    final AndroidGetRegisterIdCallbackArg result = AndroidGetRegisterIdCallbackArg();
    result.success = pigeonMap['success'];
    result.platformName = pigeonMap['platformName'];
    result.regId = pigeonMap['regId'];
    return result;
  }
}

class FlutterPushNotificationHostApi {
  Future<void> triggerRegister() async {
    const BasicMessageChannel<dynamic> channel =
        BasicMessageChannel<dynamic>('dev.flutter.pigeon.FlutterPushNotificationHostApi.triggerRegister', StandardMessageCodec());
    
    final Map<dynamic, dynamic> replyMap = await channel.send(null);
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null);
    } else if (replyMap['error'] != null) {
      final Map<dynamic, dynamic> error = replyMap['error'];
      throw PlatformException(
          code: error['code'],
          message: error['message'],
          details: error['details']);
    } else {
      // noop
    }
    
  }
  Future<void> androidGetRegisterId() async {
    const BasicMessageChannel<dynamic> channel =
        BasicMessageChannel<dynamic>('dev.flutter.pigeon.FlutterPushNotificationHostApi.androidGetRegisterId', StandardMessageCodec());
    
    final Map<dynamic, dynamic> replyMap = await channel.send(null);
    if (replyMap == null) {
      throw PlatformException(
        code: 'channel-error',
        message: 'Unable to establish connection on channel.',
        details: null);
    } else if (replyMap['error'] != null) {
      final Map<dynamic, dynamic> error = replyMap['error'];
      throw PlatformException(
          code: error['code'],
          message: error['message'],
          details: error['details']);
    } else {
      // noop
    }
    
  }
}

abstract class FlutterPushNotificationFlutterApi {
  void iosRegisterCallback(IosRegisterCallbackArg arg);
  void androidOnRegisterSucceedCallback(AndroidOnRegisterSucceedCallbackArg arg);
  void androidGetRegisterIdCallback(AndroidGetRegisterIdCallbackArg arg);
  static void setup(FlutterPushNotificationFlutterApi api) {
    {
      const BasicMessageChannel<dynamic> channel =
          BasicMessageChannel<dynamic>('dev.flutter.pigeon.FlutterPushNotificationFlutterApi.iosRegisterCallback', StandardMessageCodec());
      channel.setMessageHandler((dynamic message) async {
        final Map<dynamic, dynamic> mapMessage = message as Map<dynamic, dynamic>;
        final IosRegisterCallbackArg input = IosRegisterCallbackArg._fromMap(mapMessage);
        api.iosRegisterCallback(input);
      });
    }
    {
      const BasicMessageChannel<dynamic> channel =
          BasicMessageChannel<dynamic>('dev.flutter.pigeon.FlutterPushNotificationFlutterApi.androidOnRegisterSucceedCallback', StandardMessageCodec());
      channel.setMessageHandler((dynamic message) async {
        final Map<dynamic, dynamic> mapMessage = message as Map<dynamic, dynamic>;
        final AndroidOnRegisterSucceedCallbackArg input = AndroidOnRegisterSucceedCallbackArg._fromMap(mapMessage);
        api.androidOnRegisterSucceedCallback(input);
      });
    }
    {
      const BasicMessageChannel<dynamic> channel =
          BasicMessageChannel<dynamic>('dev.flutter.pigeon.FlutterPushNotificationFlutterApi.androidGetRegisterIdCallback', StandardMessageCodec());
      channel.setMessageHandler((dynamic message) async {
        final Map<dynamic, dynamic> mapMessage = message as Map<dynamic, dynamic>;
        final AndroidGetRegisterIdCallbackArg input = AndroidGetRegisterIdCallbackArg._fromMap(mapMessage);
        api.androidGetRegisterIdCallback(input);
      });
    }
  }
}


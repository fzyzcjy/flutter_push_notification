// Autogenerated from Pigeon (v0.1.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon
// ignore_for_file: public_member_api_docs, non_constant_identifier_names, avoid_as, unused_import
import 'dart:async';
import 'package:flutter/services.dart';

class IosDidRegisterRequest {
  String deviceToken;
  // ignore: unused_element
  Map<dynamic, dynamic> _toMap() {
    final Map<dynamic, dynamic> pigeonMap = <dynamic, dynamic>{};
    pigeonMap['deviceToken'] = deviceToken;
    return pigeonMap;
  }
  // ignore: unused_element
  static IosDidRegisterRequest _fromMap(Map<dynamic, dynamic> pigeonMap) {
    if (pigeonMap == null){
      return null;
    }
    final IosDidRegisterRequest result = IosDidRegisterRequest();
    result.deviceToken = pigeonMap['deviceToken'];
    return result;
  }
}

class IosFailRegisterRequest {
  String error;
  // ignore: unused_element
  Map<dynamic, dynamic> _toMap() {
    final Map<dynamic, dynamic> pigeonMap = <dynamic, dynamic>{};
    pigeonMap['error'] = error;
    return pigeonMap;
  }
  // ignore: unused_element
  static IosFailRegisterRequest _fromMap(Map<dynamic, dynamic> pigeonMap) {
    if (pigeonMap == null){
      return null;
    }
    final IosFailRegisterRequest result = IosFailRegisterRequest();
    result.error = pigeonMap['error'];
    return result;
  }
}

class FlutterPushNotificationHostApi {
  Future<void> iosRegisterForRemoteNotifications() async {
    const BasicMessageChannel<dynamic> channel =
        BasicMessageChannel<dynamic>('dev.flutter.pigeon.FlutterPushNotificationHostApi.iosRegisterForRemoteNotifications', StandardMessageCodec());
    
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
  void iosDidRegister(IosDidRegisterRequest arg);
  void iosFailedRegister(IosFailRegisterRequest arg);
  static void setup(FlutterPushNotificationFlutterApi api) {
    {
      const BasicMessageChannel<dynamic> channel =
          BasicMessageChannel<dynamic>('dev.flutter.pigeon.FlutterPushNotificationFlutterApi.iosDidRegister', StandardMessageCodec());
      channel.setMessageHandler((dynamic message) async {
        final Map<dynamic, dynamic> mapMessage = message as Map<dynamic, dynamic>;
        final IosDidRegisterRequest input = IosDidRegisterRequest._fromMap(mapMessage);
        api.iosDidRegister(input);
      });
    }
    {
      const BasicMessageChannel<dynamic> channel =
          BasicMessageChannel<dynamic>('dev.flutter.pigeon.FlutterPushNotificationFlutterApi.iosFailedRegister', StandardMessageCodec());
      channel.setMessageHandler((dynamic message) async {
        final Map<dynamic, dynamic> mapMessage = message as Map<dynamic, dynamic>;
        final IosFailRegisterRequest input = IosFailRegisterRequest._fromMap(mapMessage);
        api.iosFailedRegister(input);
      });
    }
  }
}


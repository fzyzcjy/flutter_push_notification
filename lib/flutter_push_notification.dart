import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_push_notification/src/messages.dart';

class PushPlatformNames {
  static const APNS = 'apns';
}

@immutable
class DeviceToken {
  final String platformName;
  final String deviceToken;

  DeviceToken({this.platformName, this.deviceToken});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DeviceToken &&
          runtimeType == other.runtimeType &&
          platformName == other.platformName &&
          deviceToken == other.deviceToken;

  @override
  int get hashCode => platformName.hashCode ^ deviceToken.hashCode;

  @override
  String toString() => 'DeviceToken{platformName: $platformName, deviceToken: $deviceToken}';
}

_FlutterApiHandler _flutterApiHandler;

abstract class FlutterPushNotification {
  final _hostApi = FlutterPushNotificationHostApi();

  factory FlutterPushNotification() {
    if (Platform.isAndroid) return _AndroidFlutterPushNotification();
    if (Platform.isIOS) return _IOSFlutterPushNotification();
    throw Exception('unsupported platform');
  }

  FlutterPushNotification._() {
    if (_flutterApiHandler == null) {
      _flutterApiHandler = _FlutterApiHandler();
      FlutterPushNotificationFlutterApi.setup(_flutterApiHandler);
    }
  }

  Future<DeviceToken> register();
}

class _AndroidFlutterPushNotification extends FlutterPushNotification {
  _AndroidFlutterPushNotification() : super._();

  @override
  Future<DeviceToken> register() {
    // TODO: implement register
    throw UnimplementedError();
  }
}

class _IOSFlutterPushNotification extends FlutterPushNotification {
  _IOSFlutterPushNotification() : super._();

  @override
  Future<DeviceToken> register() {
    final completer = Completer<DeviceToken>();

    _flutterApiHandler.onceIosRegisterCallback = (arg) {
      if (arg.success) {
        completer.complete(DeviceToken(platformName: PushPlatformNames.APNS, deviceToken: arg.deviceToken));
      } else {
        completer.completeError(Exception(arg.errorMessage));
      }
    };

    // even if the hostApi's Future completes, the work is NOT done. Thus do not await for this
    _hostApi.iosRegister().catchError(completer.completeError);

    return completer.future;
  }
}

class _FlutterApiHandler implements FlutterPushNotificationFlutterApi {
  _IosDidRegisterCallback _onceIosRegisterCallback;

  set onceIosRegisterCallback(_IosDidRegisterCallback f) {
    if (_onceIosRegisterCallback != null) print('WARN: onceIosRegisterCallback != null');
    _onceIosRegisterCallback = f;
  }

  @override
  void iosRegisterCallback(IosDidRegisterCallbackArg arg) {
    _onceIosRegisterCallback?.call(arg);
    _onceIosRegisterCallback = null;
  }
}

typedef void _IosDidRegisterCallback(IosDidRegisterCallbackArg arg);

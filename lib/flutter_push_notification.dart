import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_push_notification/src/messages.dart';

enum PushPlatform {
  APNS,
}

@immutable
class PushDevice {
  final PushPlatform platform;
  final String deviceToken;

  PushDevice({this.platform, this.deviceToken});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PushDevice &&
          runtimeType == other.runtimeType &&
          platform == other.platform &&
          deviceToken == other.deviceToken;

  @override
  int get hashCode => platform.hashCode ^ deviceToken.hashCode;

  @override
  String toString() => 'DeviceToken{platform: $platform, deviceToken: $deviceToken}';
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

  Future<PushDevice> register();
}

class _AndroidFlutterPushNotification extends FlutterPushNotification {
  _AndroidFlutterPushNotification() : super._();

  @override
  Future<PushDevice> register() {
    // TODO: implement register
    throw UnimplementedError();
  }
}

class _IOSFlutterPushNotification extends FlutterPushNotification {
  _IOSFlutterPushNotification() : super._();

  @override
  Future<PushDevice> register() {
    final completer = Completer<PushDevice>();

    _flutterApiHandler.onceIosRegisterCallback = (arg) {
      if (arg.success) {
        completer.complete(PushDevice(platform: PushPlatform.APNS, deviceToken: arg.deviceToken));
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
    if (_onceIosRegisterCallback != null) print('WARN: onceIosRegisterCallback != null when set');
    _onceIosRegisterCallback = f;
  }

  @override
  void iosRegisterCallback(IosDidRegisterCallbackArg arg) {
    if (_onceIosRegisterCallback == null) print('WARN: onceIosRegisterCallback == null when iosRegisterCallback');
    _onceIosRegisterCallback?.call(arg);
    _onceIosRegisterCallback = null;
  }
}

typedef void _IosDidRegisterCallback(IosDidRegisterCallbackArg arg);

import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_push_notification/src/messages.dart';
import 'package:flutter_push_notification/src/utils.dart';

enum PushPlatform {
  // ios
  APNS,

  // android
  MI,
  HUAWEI,
  MEIZU,
  OPPO,
  VIVO,
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

  Future<PushDevice> register() {
    final completer = Completer<PushDevice>();

    _setUpRegisterCallback(completer);

    // even if the hostApi's Future completes, the work is NOT done. Thus do not await this
    _hostApi.triggerRegister().catchError(completer.completeError);

    return completer.future;
  }

  void _setUpRegisterCallback(Completer<PushDevice> completer);
}

class _AndroidFlutterPushNotification extends FlutterPushNotification {
  _AndroidFlutterPushNotification() : super._();

  @override
  void _setUpRegisterCallback(Completer<PushDevice> completer) {
    _flutterApiHandler._androidOnRegisterSucceedCallback.registerOnce((arg) {
      completer.complete(PushDevice(platform: _convertPushPlatform(arg.platformName), deviceToken: arg.regId));
    });
  }

  PushPlatform _convertPushPlatform(String mixPushPlatformName) {
    const _MAP = {
      'mi': PushPlatform.MI,
      'huawei': PushPlatform.HUAWEI,
      'oppo': PushPlatform.OPPO,
      'vivo': PushPlatform.VIVO,
      'meizu': PushPlatform.MEIZU,
    };
    if (!_MAP.containsKey(mixPushPlatformName))
      throw Exception('_convertPushPlatform unknown platform: $mixPushPlatformName');
    return _MAP[mixPushPlatformName];
  }
}

class _IOSFlutterPushNotification extends FlutterPushNotification {
  _IOSFlutterPushNotification() : super._();

  @override
  void _setUpRegisterCallback(Completer<PushDevice> completer) {
    _flutterApiHandler._iosRegisterCallback.registerOnce((arg) {
      if (arg.success) {
        completer.complete(PushDevice(platform: PushPlatform.APNS, deviceToken: arg.deviceToken));
      } else {
        completer.completeError(Exception(arg.errorMessage));
      }
    });
  }
}

class _FlutterApiHandler implements FlutterPushNotificationFlutterApi {
  final _iosRegisterCallback = OnceFunction<IosRegisterCallbackArg>();
  final _androidGetRegisterIdCallback = OnceFunction<AndroidGetRegisterIdCallbackArg>();
  final _androidOnRegisterSucceedCallback = OnceFunction<AndroidOnRegisterSucceedCallbackArg>();

  @override
  void iosRegisterCallback(IosRegisterCallbackArg arg) => _iosRegisterCallback.callAndRemove(arg);

  @override
  void androidGetRegisterIdCallback(AndroidGetRegisterIdCallbackArg arg) =>
      _androidGetRegisterIdCallback.callAndRemove(arg);

  @override
  void androidOnRegisterSucceedCallback(AndroidOnRegisterSucceedCallbackArg arg) =>
      _androidOnRegisterSucceedCallback.callAndRemove(arg);
}

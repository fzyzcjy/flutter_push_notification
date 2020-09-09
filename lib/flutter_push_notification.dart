import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_push_notification/src/messages.dart';
import 'package:flutter_push_notification/src/utils.dart';
import 'package:permission_handler/permission_handler.dart';

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

extension _ExtPushPlatform on PushPlatform {
  static const _TO_MIX_PUSH_PLATFORM_NAME_MAP = {
    PushPlatform.MI: 'mi',
    PushPlatform.HUAWEI: 'huawei',
    PushPlatform.OPPO: 'oppo',
    PushPlatform.VIVO: 'vivo',
    PushPlatform.MEIZU: 'meizu',
  };

  static PushPlatform fromMixPushPlatformName(String mixPushPlatformName) =>
      _TO_MIX_PUSH_PLATFORM_NAME_MAP.entries.firstWhere((entry) => entry.value == mixPushPlatformName).key;

  String toMixPushPlatformName() => _TO_MIX_PUSH_PLATFORM_NAME_MAP[this];
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

  Future<PushDevice> register({PushPlatform androidDefaultPlatform = PushPlatform.MI}) {
    final completer = Completer<PushDevice>();

    // TODO remove, only for debug
    () async {
      print('TODO TODO TODO get permission');
      final statuses = await [Permission.storage, Permission.phone].request();
      for (final status in statuses.values) {
        if (status != PermissionStatus.granted) throw Exception("Microphone permission not granted");
      }
      print('TODO TODO TODO get permission');
    }();

    _setUpRegisterCallback(completer);

    // NOTE even if triggerRegister's Future completes, the process is still NOT finished.
    final arg = TriggerRegisterArg()..androidDefaultPlatform = androidDefaultPlatform.toMixPushPlatformName();
    _hostApi.triggerRegister(arg).catchError(completer.completeError);

    return completer.future;
  }

  void _setUpRegisterCallback(Completer<PushDevice> completer);
}

class _AndroidFlutterPushNotification extends FlutterPushNotification {
  _AndroidFlutterPushNotification() : super._();

  @override
  void _setUpRegisterCallback(Completer<PushDevice> completer) {
    _flutterApiHandler._androidOnRegisterSucceedCallback.registerOnce((arg) {
      completer.complete(PushDevice(
        platform: _ExtPushPlatform.fromMixPushPlatformName(arg.platformName),
        deviceToken: arg.regId,
      ));
    });
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

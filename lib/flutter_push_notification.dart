import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_push_notification/src/messages.dart';
import 'package:flutter_push_notification/src/utils.dart';

const _TAG = 'FlutterPushNotification';

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

  Future<PushDevice> register(
      {PushPlatform androidDefaultPlatform = PushPlatform.MI, Duration timeout = const Duration(seconds: 10)}) {
    print('$_TAG register start');

    final completer = Completer<PushDevice>();

    Future.delayed(timeout).then((_) {
      if (!completer.isCompleted) {
        print('$_TAG register timeout');
        completer.completeError(Exception('$_TAG register() timeout without receiving any reply'));
      }
    });

    _setUpRegisterCallback(completer);

    // NOTE even if triggerRegister's Future completes, the process is still NOT finished.
    final arg = TriggerRegisterArg()..androidDefaultPlatform = androidDefaultPlatform.toMixPushPlatformName();
    _hostApi.triggerRegister(arg).catchError(completer.completeErrorIfNotCompleted);

    return completer.future;
  }

  void _setUpRegisterCallback(Completer<PushDevice> completer);
}

class _AndroidFlutterPushNotification extends FlutterPushNotification {
  _AndroidFlutterPushNotification() : super._();

  @override
  void _setUpRegisterCallback(Completer<PushDevice> completer) {
    _flutterApiHandler._androidOnRegisterSucceedCallback.registerOnce((arg) {
      print('$_TAG _androidOnRegisterSucceedCallback ${arg.platformName} ${arg.regId}');
      completer.completeIfNotCompleted(PushDevice(
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
      print('$_TAG _iosRegisterCallback ${arg.success} ${arg.deviceToken} ${arg.errorMessage}');
      if (arg.success) {
        completer.completeIfNotCompleted(PushDevice(platform: PushPlatform.APNS, deviceToken: arg.deviceToken));
      } else {
        completer.completeErrorIfNotCompleted(Exception(arg.errorMessage), null);
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

extension _ExtCompleter<T> on Completer<T> {
  void completeIfNotCompleted(T value) {
    if (isCompleted) {
      print('WARN want to complete() but already iisCompleted (value=$value)');
    } else {
      complete(value);
    }
  }

  void completeErrorIfNotCompleted(Object error, StackTrace stackTrace) {
    if (isCompleted) {
      print('WARN want to completeError() but already iisCompleted (error=$error, stackTrace=$stackTrace)');
    } else {
      completeError(error, stackTrace);
    }
  }
}

// Autogenerated from Pigeon (v0.1.4), do not edit directly.
// See also: https://pub.dev/packages/pigeon
#import "messages.h"
#import <Flutter/Flutter.h>

#if !__has_feature(objc_arc)
#error File requires ARC to be enabled.
#endif

static NSDictionary* wrapResult(NSDictionary *result, FlutterError *error) {
  NSDictionary *errorDict = (NSDictionary *)[NSNull null];
  if (error) {
    errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
        (error.code ? error.code : [NSNull null]), @"code",
        (error.message ? error.message : [NSNull null]), @"message",
        (error.details ? error.details : [NSNull null]), @"details",
        nil];
  }
  return [NSDictionary dictionaryWithObjectsAndKeys:
      (result ? result : [NSNull null]), @"result",
      errorDict, @"error",
      nil];
}

@interface FPNIosDidRegisterRequest ()
+(FPNIosDidRegisterRequest*)fromMap:(NSDictionary*)dict;
-(NSDictionary*)toMap;
@end

@implementation FPNIosDidRegisterRequest
+(FPNIosDidRegisterRequest*)fromMap:(NSDictionary*)dict {
  FPNIosDidRegisterRequest* result = [[FPNIosDidRegisterRequest alloc] init];
  result.deviceTokenBase64 = dict[@"deviceTokenBase64"];
  if ((NSNull *)result.deviceTokenBase64 == [NSNull null]) {
    result.deviceTokenBase64 = nil;
  }
  return result;
}
-(NSDictionary*)toMap {
  return [NSDictionary dictionaryWithObjectsAndKeys:(self.deviceTokenBase64 ? self.deviceTokenBase64 : [NSNull null]), @"deviceTokenBase64", nil];
}
@end

void FPNFlutterPushNotificationHostApiSetup(id<FlutterBinaryMessenger> binaryMessenger, id<FPNFlutterPushNotificationHostApi> api) {
  {
    FlutterBasicMessageChannel *channel =
      [FlutterBasicMessageChannel
        messageChannelWithName:@"dev.flutter.pigeon.FlutterPushNotificationHostApi.iosRegisterForRemoteNotifications"
        binaryMessenger:binaryMessenger];
    if (api) {
      [channel setMessageHandler:^(id _Nullable message, FlutterReply callback) {
        FlutterError *error;
        [api iosRegisterForRemoteNotifications:&error];
        callback(wrapResult(nil, error));
      }];
    }
    else {
      [channel setMessageHandler:nil];
    }
  }
}
@interface FPNFlutterPushNotificationFlutterApi ()
@property (nonatomic, strong) NSObject<FlutterBinaryMessenger>* binaryMessenger;
@end

@implementation FPNFlutterPushNotificationFlutterApi
- (instancetype)initWithBinaryMessenger:(NSObject<FlutterBinaryMessenger>*)binaryMessenger {
  self = [super init];
  if (self) {
    self.binaryMessenger = binaryMessenger;
  }
  return self;
}

- (void)iosDidRegister:(FPNIosDidRegisterRequest*)input completion:(void(^)(NSError* _Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.FlutterPushNotificationFlutterApi.iosDidRegister"
      binaryMessenger:self.binaryMessenger];
  NSDictionary* inputMap = [input toMap];
  [channel sendMessage:inputMap reply:^(id reply) {
    completion(nil);
  }];
}
- (void)iosFailedRegister:(void(^)(NSError* _Nullable))completion {
  FlutterBasicMessageChannel *channel =
    [FlutterBasicMessageChannel
      messageChannelWithName:@"dev.flutter.pigeon.FlutterPushNotificationFlutterApi.iosFailedRegister"
      binaryMessenger:self.binaryMessenger];
  [channel sendMessage:nil reply:^(id reply) {
    completion(nil);
  }];
}
@end

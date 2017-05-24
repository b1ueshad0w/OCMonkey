//
//  AgentForHost.m
//  OCMonkey
//
//  Created by gogleyin on 6/29/16.
//  Copyright © 2016 gogleyin. All rights reserved.
//

#import "AgentForHost.h"
#import <peertalk/PTChannel.h>
#import <Foundation/Foundation.h>
#import "Macros.h"
#import <objc/runtime.h>

static const uint32_t GGUSBFrameType = 104;

@interface AgentForHost() <PTChannelDelegate>
@property (atomic, strong) PTChannel *serverChannel;
@property (atomic, strong) PTChannel *peerChannel;
@property (atomic, strong) PTChannel *connectedChannel;
@property (atomic, strong) NSDictionary *frameCache;
@end

@implementation AgentForHost

static NSDictionary *SelectorMapping;

+ (void)createMapping
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SelectorMapping =
        @{
          @"viewDidAppear:" : @"viewController:didAppearAnimated:",
          @"initWithRootViewController:" : @"naviCtrl:initWithRootViewController:",
          @"pushViewController:animated:" : @"naviCtrl:shouldPushViewController:animated:",
          @"popViewControllerAnimated:" : @"naviCtrl:shouldPopViewControllerAnimated:",
          @"popToViewController:animated:" : @"naviCtrl:shouldPopToViewController:animated:",
          @"popToRootViewControllerAnimated:" : @"naviCtrl:shouldPopToRootViewControllerAnimated:",
          @"setViewControllers:animated:": @"naviCtrl:setViewControllers:animated:"
          };
    });
}

+ (NSString *)getProtocolSelByOriginSel:(NSString *)selectorStr
{
    [self createMapping];
    return SelectorMapping[selectorStr];
}

- (id)initWithDelegate:(id<UIChangeDelegate>)delegate
{
    if (!(self = [super init])) return nil;
    _delegate = delegate;
    return self;
}

- (void)disconnectFromCurrentChannel
{
  if (self.connectedChannel) {
    [self.connectedChannel close];
    self.connectedChannel = nil;
  }
}

- (void)sendJSON:(NSDictionary *)info
{
    [self sendJSON:info tag:PTFrameNoTag];
}

- (void)sendJSON:(NSDictionary *)info tag:(uint32_t)tag
{
    //    NSLog(@"%@ in sendJSON", prefix);
    if (!self.connectedChannel) {
        return;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
    dispatch_data_t payload = [data createReferencingDispatchData];
    [self.connectedChannel sendFrameOfType:GGUSBFrameType tag:tag withPayload:payload callback:^(NSError *error) {
        if (error) {
            NSLog(@"Failed to send json: %@", error);
        }
    }];
//    NSLog(@"%@ JSON sent: %@", prefix, info);
}

- (void)connectToLocalIPv4AtPort:(in_port_t)port {
//    PTChannel *channel = [PTChannel channelWithDelegate:self];  // such channel will work in the main thread
    PTProtocol *protocol = [[PTProtocol alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    PTChannel *channel = [[PTChannel alloc] initWithProtocol:protocol delegate:self];
    channel.userInfo = [NSString stringWithFormat:@"127.0.0.1:%d", port];
    [channel connectToPort:port IPv4Address:INADDR_LOOPBACK callback:^(NSError *error, PTAddress *address) {
    if (error) {
      if (error.domain == NSPOSIXErrorDomain && (error.code == ECONNREFUSED || error.code == ETIMEDOUT)) {
        // this is an expected state
          NSLog(@"No listening socket.");
      } else {
        NSLog(@"Failed to connect to 127.0.0.1:%d: %@", port, error);
      }
    } else {
      [self disconnectFromCurrentChannel];
      self.connectedChannel = channel;
      channel.userInfo = address;
      NSLog(@"%@ Connected to %@", prefix, address);
    }
    }];
}

- (void)connectToLocalIPv4AtPort:(in_port_t)port timeout:(uint32_t)seconds
{
    PTProtocol *protocol = [[PTProtocol alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    __block BOOL keepWaiting = YES;
    for (int i = 0; i < seconds; i++) {
        if (!keepWaiting)
            break;
        NSLog(@"%@ Attemp to connect to 127.0.0.1:%d ... %d", prefix, port, i);
        PTChannel *channel = [[PTChannel alloc] initWithProtocol:protocol delegate:self];
        channel.userInfo = [NSString stringWithFormat:@"127.0.0.1:%d", port];
        [channel connectToPort:port IPv4Address:INADDR_LOOPBACK callback:^(NSError *error, PTAddress *address) {
            if (error) {
                if (error.domain == NSPOSIXErrorDomain && (error.code == ECONNREFUSED || error.code == ETIMEDOUT)) {
                    /* this is an expected state */
                    NSLog(@"%@ No listening socket.", prefix);
                    [NSThread sleepForTimeInterval:0.1];
                } else {
                    // keepWaiting = NO;
                    NSLog(@"%@ Failed to connect to 127.0.0.1:%d: %@", prefix, port, error);
                    [NSThread sleepForTimeInterval:0.1];
                }
            } else {
                keepWaiting = NO;
                [self disconnectFromCurrentChannel];
                self.connectedChannel = channel;
                channel.userInfo = address;
                NSLog(@"%@ Connected to %@", prefix, address);
            }
        }];
    }
}

/* I don' know why this will crash */
- (void)handleDataSelector_:(NSDictionary *)data tag:(uint32_t)tag
{
    NSString *selectorStr = data[@"selector"];
    SEL selector = NSSelectorFromString([AgentForHost getProtocolSelByOriginSel:selectorStr]);
    if (![_delegate respondsToSelector:selector])
        return;
    id returned;
    NSMutableArray *args = [NSMutableArray arrayWithArray:data[@"args"]];
    [args insertObject:data[@"receiver"] atIndex:0];
    
//    NSMethodSignature *signature = [_delegate instanceMethodSignatureForSelector:@selector(viewController:didAppearAnimated:)];
    struct objc_method_description description = protocol_getMethodDescription(@protocol(UIChangeDelegate), selector, NO, YES);
    NSMethodSignature *signature = [NSMethodSignature signatureWithObjCTypes:description.types];
    if (!signature) {
        NSLog(@"%@ signature for selector %@ is nil.", prefix, selectorStr);
        return;
    }
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setTarget:_delegate];
    [args enumerateObjectsUsingBlock:^(id arg, NSUInteger index, BOOL *stop) {
        [invocation setArgument:&arg atIndex:index];
    }];
    [invocation invoke];
    [invocation getReturnValue:&returned];
    NSLog(@"Return Value:%@", returned);
}

- (void)handleDataSelector:(NSDictionary *)data tag:(uint32_t)tag
{
    NSString *selector = data[@"selector"];
    NSString *clas = data[@"class"];
    NSArray *args = data[@"args"];
    if ([selector isEqualToString:@"viewDidAppear:"]) {
        if ([_delegate respondsToSelector:@selector(viewController:didAppearAnimated:)]) {
            [_delegate viewController:args[0]
                    didAppearAnimated:[args[1] boolValue]];
        }
    } else if ([selector isEqualToString:@"pushViewController:animated:"]) {
        if ([_delegate respondsToSelector:@selector(naviCtrl:shouldPushViewController:animated:)]) {
            BOOL shouldDo = [_delegate naviCtrl:args[0]
                       shouldPushViewController:args[1]
                                       animated:[args[2] boolValue]];
            [self sendJSON:@{@"shouldDo": [NSNumber numberWithBool:shouldDo]} tag:tag];
        }
    } else if ([selector isEqualToString:@"popViewControllerAnimated:"]) {
        if ([_delegate respondsToSelector:@selector(naviCtrl:shouldPopViewControllerAnimated:)]) {
            BOOL shouldDo = [_delegate naviCtrl:args[0]
                shouldPopViewControllerAnimated:[args[1] boolValue]];
            [self sendJSON:@{@"shouldDo": [NSNumber numberWithBool:shouldDo]} tag:tag];
        }
    } else if ([selector isEqualToString:@"popToRootViewControllerAnimated:"]) {
        if ([_delegate respondsToSelector:@selector(naviCtrl:shouldPopToRootViewControllerAnimated:)]) {
            BOOL shouldDo = [_delegate naviCtrl:args[0]
               shouldPopToRootViewControllerAnimated:[args[1] boolValue]];
            [self sendJSON:@{@"shouldDo": [NSNumber numberWithBool:shouldDo]} tag:tag];
        }
    } else if ([selector isEqualToString:@"popToViewController:animated:"]) {
        if ([_delegate respondsToSelector:@selector(naviCtrl:shouldPopToViewController:animated:)]) {
            BOOL shouldDo = [_delegate naviCtrl:args[0]
                      shouldPopToViewController:args[1]
                                    animated:[args[2] boolValue]];
            [self sendJSON:@{@"shouldDo": [NSNumber numberWithBool:shouldDo]} tag:tag];
        }
    } else if ([selector isEqualToString:@"initWithRootViewController:"]) {
        if ([_delegate respondsToSelector:@selector(naviCtrl:initWithRootViewController:)]) {
            [_delegate naviCtrl:args[0] initWithRootViewController:args[1]];
        }
    } else if ([selector isEqualToString:@"setViewControllers:animated:"]) {
        if ([clas isEqualToString:@"UINavigationController"]) {
            if ([_delegate respondsToSelector:@selector(naviCtrl:setViewControllers:animated:)]) {
                [_delegate naviCtrl:args[0] setViewControllers:args[1] animated:args[2]];
            }
        }
        else if ([clas isEqualToString:@"UITabBarController"]) {
            if ([_delegate respondsToSelector:@selector(tabCtrl:setViewControllers:animated:)]) {
                [_delegate tabCtrl:args[0] setViewControllers:args[1] animated:args[2]];
            }
        }
    } else if ([selector isEqualToString:@"init"] && [clas isEqualToString:@"UITabBarController"]) {
        if ([_delegate respondsToSelector:@selector(tabCtrlInit:)]) {
            [_delegate tabCtrlInit:args[0]];
        }
    } else if ([clas isEqualToString:@"UITabBarController"] && [selector isEqualToString:@"setSelectedIndex:"]) {
        if ([_delegate respondsToSelector:@selector(tabCtrl:setSelectedIndex:)]) {
            [_delegate tabCtrl:args[0] setSelectedIndex:[args[1] unsignedIntegerValue]];
        }
    }

}

- (void)handleData:(NSData *)data tag:(uint32_t)tag
{
    NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"Received a json from tested app: %@", parsed);
    if ([parsed objectForKey:@"selector"]) {
        [self handleDataSelector:parsed tag:tag];
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(PTData*)payload
{
  if (type == TCFrameTypeTextMessage) {
    PTExampleTextFrame *textFrame = (PTExampleTextFrame*)payload.data;
    textFrame->length = ntohl(textFrame->length);
    NSString *message = [[NSString alloc] initWithBytes:textFrame->utf8text length:textFrame->length encoding:NSUTF8StringEncoding];
    NSLog(@"Receive a text from test app: %@", message);
  } else if (type == GGUSBFrameType) {
      dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
          [self handleData:[NSData dataWithContentsOfDispatchData:payload.dispatchData] tag:tag];
      });
  }
}

- (BOOL)ioFrameChannel:(PTChannel *)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize
{
  return (type == TCFrameTypeTextMessage || type == GGUSBFrameType);
}

@end

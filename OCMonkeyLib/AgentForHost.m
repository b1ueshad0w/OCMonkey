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

static const uint32_t GGUSBFrameType = 104;

@interface AgentForHost() <PTChannelDelegate>
@property (atomic, strong) PTChannel *serverChannel;
@property (atomic, strong) PTChannel *peerChannel;
@property (atomic, strong) PTChannel *connectedChannel;
@property (atomic, strong) NSDictionary *frameCache;
@end

@implementation AgentForHost

- (void)disconnectFromCurrentChannel
{
  if (self.connectedChannel) {
    [self.connectedChannel close];
    self.connectedChannel = nil;
  }
}

- (void)sendJSON:(NSDictionary *)info
{
    //    NSLog(@"%@ in sendJSON", prefix);
    if (!self.connectedChannel) {
        return;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
    dispatch_data_t payload = [data createReferencingDispatchData];
    uint32_t tagno = [self.connectedChannel.protocol newTag];
    [self.connectedChannel sendFrameOfType:GGUSBFrameType tag:tagno withPayload:payload callback:^(NSError *error) {
        if (error) {
            NSLog(@"Failed to send json: %@", error);
        }
    }];
}

- (void)connectToLocalIPv4AtPort:(in_port_t)port {
  PTChannel *channel = [PTChannel channelWithDelegate:self];
  channel.userInfo = [NSString stringWithFormat:@"127.0.0.1:%d", port];
  [channel connectToPort:port IPv4Address:INADDR_LOOPBACK callback:^(NSError *error, PTAddress *address) {
    if (error) {
      if (error.domain == NSPOSIXErrorDomain && (error.code == ECONNREFUSED || error.code == ETIMEDOUT)) {
        // this is an expected state
      } else {
        NSLog(@"Failed to connect to 127.0.0.1:%d: %@", port, error);
      }
    } else {
      [self disconnectFromCurrentChannel];
      self.connectedChannel = channel;
      channel.userInfo = address;
      NSLog(@"Connected to %@", address);
    }
  }];
}

- (void)ioFrameChannel:(PTChannel*)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(PTData*)payload
{
  if (type == TCFrameTypeTextMessage) {
    PTExampleTextFrame *textFrame = (PTExampleTextFrame*)payload.data;
    textFrame->length = ntohl(textFrame->length);
    NSString *message = [[NSString alloc] initWithBytes:textFrame->utf8text length:textFrame->length encoding:NSUTF8StringEncoding];
    NSLog(@"Receive a text from test app: %@", message);
  } else if (type == GGUSBFrameType) {
      NSData *data = [NSData dataWithContentsOfDispatchData:payload.dispatchData];
      NSDictionary *parsed = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
      NSLog(@"Received a json from tested app: %@", parsed);
  }
}

- (BOOL)ioFrameChannel:(PTChannel *)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize
{
  return (type == TCFrameTypeTextMessage || type == GGUSBFrameType);
}

@end

//
//  Outlet.m
//  libmonkey
//
//  Created by gogleyin on 1/6/16.
//  Copyright © 2016 gogleyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <peertalk/PTChannel.h>
#import <peertalk/PTProtocol.h>
#import "Macros.h"
#import "Outlet.h"

#define GGValidateObjectWithClass(object, aClass) \
    if (object && ![object isKindOfClass:aClass]) { \
        [self respondWithErrorMessage:[NSString stringWithFormat:@"Invalid object class %@ for %@", [object class], @#object]]; \
        return; \
    }

static const uint32_t GGUSBFrameType = 104;
static const in_port_t GGUSBPort = 2345;

@interface Outlet () <PTChannelDelegate>
{
    __weak PTChannel *serverChannel_;
    __weak PTChannel *peerChannel_;
}
@property NSMutableDictionary *semaphores;  // {tagNo1: semaphore1, tagNo2: semaphore2}
@property int nextFrameTag;


@end

@implementation Outlet

+(id)sharedOutlet {
    static Outlet *sharedOutlet = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedOutlet = [[self alloc] init];
        sharedOutlet.didAppearVCs = [[NSMutableArray alloc] init];
        sharedOutlet.semaphores = [[NSMutableDictionary alloc] init];
        sharedOutlet.nextFrameTag = 1;
    });
    return sharedOutlet;
}

+(int)responseTimeout
{
    static int _responseTimeout = -1;
    if (_responseTimeout < 0) {
        _responseTimeout = [[[NSProcessInfo processInfo] environment][@"responseTimeout"] intValue];
        if (!_responseTimeout || _responseTimeout < 0)
            _responseTimeout = RESPONSE_TIMEOUT;
    }
    return _responseTimeout;
}

-(int)newTag
{
    return ++_nextFrameTag;
}

-(void)start {
//    PTChannel *channel = [PTChannel channelWithDelegate:self];  // work in main thread
    PTProtocol *protocol = [[PTProtocol alloc] initWithDispatchQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    PTChannel *channel = [[PTChannel alloc] initWithProtocol:protocol delegate:self];
    
    NSDictionary *envi = [[NSProcessInfo processInfo] environment];
//    NSLog(@"environment: %@", envi);
    in_port_t port = GGUSBPort;
    if (envi[@"STUB_PORT"]) {
        port = [envi[@"STUB_PORT"] intValue];
    }
    [channel listenOnPort:port IPv4Address:INADDR_LOOPBACK callback:^(NSError *error) {
        if (error) {
            NSLog(@"%@ Failed to listen on 127.0.0.1:%d: %@", prefix, port, error);
        } else {
            NSLog(@"%@ Listening on 127.0.0.1:%d", prefix, port);
            serverChannel_ = channel;
        }
    }];
}

-(BOOL)isConnected {
    return YES ? peerChannel_ : NO;
}

-(NSString *)obtainCurrentVC{
    if (!self.tabBarController) {
        NSLog(@"TabBarController of dylib is nil.");
        return nil;
    }
    UINavigationController *navi = [self.tabBarController selectedViewController];
    UIViewController *topVC = navi.topViewController;
    UIViewController *currentVC = topVC;
    if([topVC isKindOfClass:[UITabBarController class]]){
        UITabBarController *tabVC = (UITabBarController *)topVC;
        currentVC= tabVC.selectedViewController;
    }
    else{
        if(currentVC.presentedViewController){
            currentVC = currentVC.presentedViewController;
        }
    }
    if([currentVC isKindOfClass:[UINavigationController class]]){
        UINavigationController *naviVC = (UINavigationController *)currentVC;
        currentVC = naviVC.topViewController;
    }
    return NSStringFromClass([currentVC class]);
}

//-(NSString *)obtainCurrentVCStack {
-(NSArray<NSString *> *)obtainCurrentVCStack {
    UINavigationController *navi;
    if (!self.tabBarController) {
            return nil;
    }
    navi = [self.tabBarController selectedViewController];
    NSMutableArray<NSString *> *vcNames = [[NSMutableArray alloc] init];
    if ([navi isKindOfClass:[UINavigationController class]]) {
        NSArray<UIViewController *> *vcs = navi.viewControllers;
        for (UIViewController *vc in vcs) {
            [vcNames addObject:NSStringFromClass([vc class])];
        }
    }
    else {
        [vcNames addObject:NSStringFromClass([navi class])];
    }
    return vcNames;
}

- (void)respondWithErrorMessage:(NSString *)errorMessage
{
    NSLog(@"%@ in respondWithErrorMessage", prefix);
    [self respondWithData:[NSJSONSerialization dataWithJSONObject:@{@"error" : errorMessage ?: @"FBHTTPOverUSBServer failed with no error."}
                                                          options:NSJSONWritingPrettyPrinted
                                                            error:nil]];
}

- (void)respondWithData:(NSData *)data
{
    NSLog(@"%@ in respondWithErrorMessage", prefix);
    void (^completionBlock)(NSError *) = ^(NSError *innerError){
        if (innerError) {
            NSLog(@"%@ Failed to send USB message. %@", prefix, innerError);
        }
    };
    [peerChannel_ sendFrameOfType:GGUSBFrameType
                                  tag:PTFrameNoTag
                          withPayload:data.createReferencingDispatchData
                             callback:completionBlock];
}

- (void)handleRequestData:(NSData *)data tag:(uint32_t)tag
{
    NSError *error;
    NSDictionary *receivedJson = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if (!receivedJson) {
        [self respondWithErrorMessage:error.description];
        return;
    }
    NSLog(@"%@ Receive json: %@ Tag: %u", prefix, receivedJson, tag);
    
    if (tag) {
        NSNumber *keyForTag = [NSNumber numberWithInt:tag];
        if ([_semaphores objectForKey:keyForTag]) {
            dispatch_semaphore_signal([_semaphores objectForKey:keyForTag]);
            [_semaphores setObject:receivedJson forKey:keyForTag];
        }
        return;
    }

    GGValidateObjectWithClass(receivedJson, NSDictionary.class);
//    GGValidateObjectWithClass(requestDictionary[@"uuid"], NSString.class);
//    GGValidateObjectWithClass(requestDictionary[@"method"], NSString.class);
    GGValidateObjectWithClass(receivedJson[@"path"], NSString.class);
//    GGValidateObjectWithClass(requestDictionary[@"parameters"], NSDictionary.class);
    
//    NSString *uuid = requestDictionary[@"uuid"];
//    NSString *method = requestDictionary[@"method"];
    NSString *path = receivedJson[@"path"];
//    NSDictionary *parameters = requestDictionary[@"parameters"];
    
    if ([path isEqualToString:@"/viewControllerStack"]) {
        NSArray<NSString*> *vcs = [self obtainCurrentVCStack];
//        [self sendJSON:@{@"value": vcs ? vcs : [NSNull null]}];
        NSString *currentVc = [self obtainCurrentVC];
        [self sendJSON:@{@"value": @{@"VCStack": vcs ? vcs : [NSNull null],
                                     @"AppearedVCs": self.didAppearVCs ? self.didAppearVCs : [NSNull null],
                                     @"CurrentVC": currentVc ? currentVc : [NSNull null],
                                     }}
         tag:tag];
        [self.didAppearVCs removeAllObjects];
    } else if ([path isEqualToString:@"/openURL"]) {
        NSDictionary *paras = receivedJson[@"parameters"];
        if (paras) {
            NSString *urlString = paras[@"url"];
            if (urlString) {
                NSLog(@"Opening URL: %@", urlString);
                UIApplication *app = [UIApplication sharedApplication];
                if ([app respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString] options:@{} completionHandler:^(BOOL success) {
                        NSLog(@"Open %@: %d", urlString, success);
                    }];
                } else {
                    [app openURL:urlString];
                }
            } else {
                NSLog(@"Could not get url from parameters.");
            }
        } else {
            NSLog(@"parameters is nil");
        }

    }
}

#pragma mark - Communicating

- (void)sendJSON:(NSDictionary *)info
{
    if (![self isConnected])
        return;
    [self sendJSON:info tag:PTFrameNoTag];
}

- (nullable NSDictionary *)jsonAction:(NSDictionary *)data timeout:(int64_t)seconds
{
    int tag = [self newTag];
    NSNumber *keyForTag = [NSNumber numberWithInt:tag];
    [self sendJSON:data tag:tag];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [_semaphores setObject:semaphore forKey:keyForTag];
    dispatch_time_t waitTime = dispatch_time(DISPATCH_TIME_NOW, seconds * 1000000000);
    dispatch_semaphore_wait(semaphore, waitTime);
    if ([_semaphores objectForKey:keyForTag] == semaphore) {
        NSLog(@"%@ JSON action timeout.", prefix);
        return nil;
    }
    NSDictionary *result = [[_semaphores objectForKey:keyForTag] copy];
    [_semaphores removeObjectForKey:keyForTag];
    return result;
}


- (void)sendJSON:(NSDictionary *)info tag:(uint32_t)tag
{
//    NSLog(@"%@ in sendJSON", prefix);
    if (!peerChannel_) {
        return;
    }
    NSData *data = [NSJSONSerialization dataWithJSONObject:info options:NSJSONWritingPrettyPrinted error:nil];
    dispatch_data_t payload = [data createReferencingDispatchData];
    [peerChannel_ sendFrameOfType:GGUSBFrameType tag:tag withPayload:payload callback:^(NSError *error) {
        if (error) {
            NSLog(@"%@ Failed to send json: %@", prefix, error);
        }
    }];
    NSLog(@"Sent JSON: %@ with tag: %u", info, tag);
}

- (void)sendDeviceInfo {
    if (!peerChannel_) {
        return;
    }
    
    NSLog(@"Sending device info over %@", peerChannel_);
    
    UIScreen *screen = [UIScreen mainScreen];
    CGSize screenSize = screen.bounds.size;
    NSDictionary *screenSizeDict = (__bridge_transfer NSDictionary*)CGSizeCreateDictionaryRepresentation(screenSize);
    UIDevice *device = [UIDevice currentDevice];
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:
                          device.localizedModel, @"localizedModel",
                          [NSNumber numberWithBool:device.multitaskingSupported], @"multitaskingSupported",
                          device.name, @"name",
                          (UIDeviceOrientationIsLandscape(device.orientation) ? @"landscape" : @"portrait"), @"orientation",
                          device.systemName, @"systemName",
                          device.systemVersion, @"systemVersion",
                          screenSizeDict, @"screenSize",
                          [NSNumber numberWithDouble:screen.scale], @"screenScale",
                          nil];
    dispatch_data_t payload = [info createReferencingDispatchData];
    [peerChannel_ sendFrameOfType:GGUSBFrameType tag:PTFrameNoTag withPayload:payload callback:^(NSError *error) {
        if (error) {
            NSLog(@"Failed to send PTExampleFrameTypeDeviceInfo: %@", error);
        }
    }];
}


#pragma mark - PTChannelDelegate

- (BOOL)ioFrameChannel:(PTChannel*)channel shouldAcceptFrameOfType:(uint32_t)type tag:(uint32_t)tag payloadSize:(uint32_t)payloadSize {
    return (type == GGUSBFrameType);
}

- (void)ioFrameChannel:(PTChannel *)channel didReceiveFrameOfType:(uint32_t)type tag:(uint32_t)tag payload:(PTData *)payload
{
    if (type != GGUSBFrameType) {
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self handleRequestData:[NSData dataWithContentsOfDispatchData:payload.dispatchData] tag:tag];
    });
}

- (void)ioFrameChannel:(PTChannel*)channel didEndWithError:(NSError*)error {
    if (error) {
        NSLog(@"%@ %@ ended with error: %@", prefix, channel, error);
    } else {
        NSLog(@"%@ Disconnected from %@", prefix, channel.userInfo);
    }
}

- (void)ioFrameChannel:(PTChannel*)channel didAcceptConnection:(PTChannel*)otherChannel fromAddress:(PTAddress*)address {
    if (peerChannel_) {
        [peerChannel_ cancel];
    }

    peerChannel_ = otherChannel;
    peerChannel_.userInfo = address;
    NSLog(@"%@ Connected to %@", prefix, address);
    
}

@end

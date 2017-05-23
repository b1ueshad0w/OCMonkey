//
//  SmartMonkey.m
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import "SmartMonkey.h"
#import "AgentForHost.h"
#import "NSMutableArray+Queue.h"

@interface SmartMonkey()
@property AgentForHost *appAgent;
@end

@implementation SmartMonkey

-(id)initWithBundleID:(NSString*)bundleID
{
    self = [super initWithBundleID:bundleID];
    if (self) {
        _appearedVCs = [[NSMutableArray alloc] init];
        _appearedVCs.maxSize = 100;
        _vcStack = [[NSMutableArray alloc] init];
        _appAgent = [[AgentForHost alloc] initWithDelegate:self];
    }
    return self;
}

-(void)preRun
{
    in_port_t port = 2349;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [_appAgent connectToLocalIPv4AtPort:port timeout:15];
    });
    self.launchEnvironment[@"STUB_PORT"] = @(port);
    [super preRun];
}

-(void)postRun
{
    [_appAgent disconnectFromCurrentChannel];
    [super postRun];
}

-(nullable NSString *)getCurrentVC
{
    for (int i = (int)(_appearedVCs.count - 1); i >= 0; i--) {
        /* UIInputWindowController ...
         * Most VC names start with "UI" is probably a system pre-defined vc name.
         * TODO - If UIInputWindowController keeps showing up, as the queue is fixed size, the queue will
         * be full of UIInputWindowController
         */
        if ([_appearedVCs[i] hasPrefix:@"UI"])
            continue;
        return _appearedVCs[i];
    }
    return nil;
}

@end


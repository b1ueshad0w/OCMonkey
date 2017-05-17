//
//  AgentForHost.h
//  OCMonkey
//
//  Created by gogleyin on 6/29/16.
//  Copyright © 2016 gogleyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol UIChangeDelegate;

enum {
  TCFrameTypeDeviceInfo = 100,
  TCFrameTypeTextMessage = 101,
};

typedef struct _PTExampleTextFrame {
  uint32_t length;
  uint8_t utf8text[100];
} PTExampleTextFrame;

@interface AgentForHost : NSObject

@property (weak) id<UIChangeDelegate> delegate;
- (id)initWithDelegate:(id<UIChangeDelegate>)delegate;

- (void)connectToLocalIPv4AtPort:(in_port_t)port;
- (void)connectToLocalIPv4AtPort:(in_port_t)port timeout:(uint32_t)seconds;
- (void)sendJSON:(NSDictionary *)info;
@end

@protocol UIChangeDelegate <NSObject>

@optional

// should we also pass the address info?
- (void)viewController:(NSString *)vc didAppearAnimated:(BOOL)animated;

/**
 Determine whether a UINavigationController should push a vc into its stack.
 
 @param pushedVC classname of the VC to be pushed into the stack
 @param animated whether this push action is animated
 @param naviCtrl classname of the UINavigationController to push
 @return YES if allow the push action, otherwise NO.
 */
- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPushViewController:(NSString *)pushedVC animated:(BOOL)animated;

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPopViewControllerAnimated:(BOOL)animated;

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPopToRootViewControllerAnimated:(BOOL)animated;

- (BOOL)naviCtrl:(NSString *)naviCtrl shouldPopToViewController:(NSString *)toVC animated:(BOOL)animated;

- (void)naviCtrl:(NSString *)naviCtrl initWithRootViewController:(NSString *)vc;

- (void)naviCtrl:(NSString *)naviCtrl setViewControllers:(NSArray<NSString *>*)vc animated:(BOOL)animted;

@end

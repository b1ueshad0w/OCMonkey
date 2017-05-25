//
//  AgentForHost.h
//  OCMonkey
//
//  Created by gogleyin on 6/29/16.
//  Copyright © 2016 gogleyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Tree.h"

typedef NSString VCType;

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
- (void)disconnectFromCurrentChannel;
- (void)connectToLocalIPv4AtPort:(in_port_t)port;
- (void)connectToLocalIPv4AtPort:(in_port_t)port timeout:(uint32_t)seconds;
- (void)sendJSON:(NSDictionary *)info;
- (nullable NSDictionary *)jsonAction:(NSDictionary *)data timeout:(double)seconds;
-(Tree *)getViewHierarchy;
@end

@protocol UIChangeDelegate <NSObject>

@optional

// should we also pass the address info?
- (void)viewController:(VCType *)vc didAppearAnimated:(BOOL)animated;

/**
 Determine whether a UINavigationController should push a vc into its stack.
 
 @param pushedVC classname of the VC to be pushed into the stack
 @param animated whether this push action is animated
 @param naviCtrl classname of the UINavigationController to push
 @return YES if allow the push action, otherwise NO.
 */
- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPushViewController:(VCType *)pushedVC animated:(BOOL)animated;

- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPopViewControllerAnimated:(BOOL)animated;

- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPopToRootViewControllerAnimated:(BOOL)animated;

- (BOOL)naviCtrl:(VCType *)naviCtrl shouldPopToViewController:(VCType *)toVC animated:(BOOL)animated;

- (void)naviCtrl:(VCType *)naviCtrl initWithRootViewController:(VCType *)vc;

- (void)naviCtrl:(VCType *)naviCtrl setViewControllers:(NSArray<VCType *>*)vc animated:(BOOL)animted;

- (void)tabCtrl:(VCType *)tabCtrl setViewControllers:(NSArray<VCType *>*)vc animated:(BOOL)animted;

- (void)tabCtrlInit:(VCType *)tabCtrl;

- (void)tabCtrl:(VCType *)tabCtrl setSelectedIndex:(NSUInteger)index;

@end

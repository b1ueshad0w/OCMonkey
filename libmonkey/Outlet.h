//
//  Outlet.h
//  libmonkey
//
//  Created by gogleyin on 1/6/16.
//  Copyright © 2016 gogleyin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UITabBarController.h>
#import <UIKit/UINavigationController.h>
#import <UIKit/UIWindow.h>
#import "MonkeyPaws.h"

#define RESPONSE_TIMEOUT 0.1

@interface Outlet : NSObject

@property (nonatomic, readwrite) int counter;
@property (nonatomic, readwrite, weak) UITabBarController *tabBarController;
// We will save last 10 viewDidAppear VC
@property (atomic, readwrite, strong) NSMutableArray<NSString*> *didAppearVCs;
@property (nonatomic, readwrite, weak) UIWindow *window;
@property (strong, nonatomic) MonkeyPaws *paws;

-(void)start;

-(BOOL)isConnected;
- (void)sendJSON:(NSDictionary *)info;
- (nullable NSDictionary *)jsonAction:(NSDictionary *)data timeout:(int64_t)seconds;
+(id)sharedOutlet;
+(int)responseTimeout;

@end

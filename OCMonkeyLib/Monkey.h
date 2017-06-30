//
//  Monkey.h
//  OCMonkey
//
//  Created by gogleyin on 02/03/2017.
//
//

#import <Foundation/Foundation.h>
#import "RandomAction.h"
#import <CoreGraphics/CoreGraphics.h>
#import "XCUIApplication.h"

@interface Monkey : NSObject

-(instancetype)initWithBundleID:(NSString*)bundleID;
-(instancetype)initWithBundleID:(NSString*)bundleID launchEnvironment:(NSDictionary *)launchEnv;
-(void)run:(int)steps;
-(void)run;
-(void)runOneStep;
-(void)preRun;
-(void)postRun;
-(void)addAction:(ActionBlock)action withWeight:(double)weight;
-(void)addAction:(ActionBlock)action withInterval:(int)interval;
-(CGPoint)randomPoint;
-(CGPoint)randomPointInRect:(CGRect)rect;
-(CGPoint)randomPointAvoidingPanelAreas;
-(CGRect)randomRect;
-(CGRect)randomRectWithSizeFraction:(CGFloat)sizeFraction;

/**
 Check whether app is inactive due to a system alert, or in background due to an
 app-jumping. It will try to bring app to frontground. Also, if the processID
 changes, it will raise the GGApplicationCrashedException.
 For efficiency, you should not call it too much.
 */
-(void)checkAppState;

/**
 Check whether app is inactive due to a system alert (known as Access
 Authorization alerts). If exists, it will try to dismiss by tapping the last
 button of it.
 */
+(void)handleSpringBoardAlerts;

@property (readonly) int actionCounter;
@property (readonly, nonatomic) NSString *testedAppBundleID;
@property (readonly, nonatomic) pid_t testedAppPid;
@property (nonatomic, readonly) XCUIApplication *testedApp;
@property (nonatomic, readwrite) NSMutableDictionary *launchEnvironment;
@property (nonatomic, readonly) NSDate *startTime;
@property (nonatomic, readonly) NSDate *endTime;
@property (nonatomic, readonly) NSString *exitReason;
@property CGRect screenFrame;
@property NSString *testedAppIdentifier;

@end

//
//  SmartMonkey.h
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import "Monkey.h"
#import "AgentForHost.h"
#import "Tree.h"
#import "ElementTree.h"

@interface TabBarCtrl : NSObject

/**
 Each tab will be an NSString like: @"<XXXController: 0x107f014A>"
 */
@property NSMutableArray<VCType *> *tabs;
@property NSUInteger selectedIndex;

-(VCType *)getSelectedVC;

@end

@interface NaviCtrl : NSObject

-(id)initWithRootVC:(VCType *)rootVC;
-(void)pushVC:(VCType *)vc;
-(VCType *)pop;
-(NSArray<VCType *> *)popToRootVC;
-(NSArray<VCType *> *)popToVC:(VCType *)vc;
-(void)setVCs:(NSArray<VCType *> *)vcs;

@property VCType *rootVC;
@property (nonatomic, readonly) NSUInteger vcCount;
/**
 Stack data structure. The most recent pushed VC is at the end of the array.
 */
@property NSMutableArray<VCType *> *vcStack;

@end

/**
 SmartMonkey has the ability to inspect test target's ViewController structure.
 */
@interface SmartMonkey : Monkey

/**
 Queue data structure. The most recent appeared VC is at the end of the array.
 */
@property (atomic, readwrite) NSMutableArray *appearedVCs;

@property (atomic, readwrite) NSMutableDictionary<VCType *, NaviCtrl *> *naviCtrls;

@property (atomic, readwrite) NSMutableDictionary<VCType *, TabBarCtrl *> *tabCtrls;

@property (atomic, readwrite) TabBarCtrl *activeTabCtrl;

@property (nonatomic, readonly) NSUInteger stackDepth;

-(VCType *)getCurrentVC;

-(Tree *)getViewHierarchy;

@end

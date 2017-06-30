//
//  WeightedMonkey.h
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import "SmartMonkey.h"
#import "MonkeyAlgorithm.h"

/**
 Block type for registering VC callbacks.

 @param tree the current UI Tree
 @return YES to continue performing the current monkey step;
         NO  to quit the current step.
 */
typedef BOOL (^VCCallback)(ElementTree *tree);

@interface WeightedMonkey : SmartMonkey

@property id<MonkeyAlgorithm> algorithm;

/**
 Range from 0 to 1. Probability to perform state checking at each monkey step.
 If set to 1 or larer than 1, it will perform at every step.
 If set to 0, it will never perfom.
 */
@property (nonatomic, readwrite) double frequencyOfStateChecking;


-(void)registerAction:(VCCallback)callback forVC:(NSString *)vc;

-(NSMutableArray<ElementTree *> *)getValidElementsFromTree:(ElementTree *)uiTree;

-(id)initWithBundleID:(NSString *)bundleID algorithm:(id<MonkeyAlgorithm>)algorithm;

@end

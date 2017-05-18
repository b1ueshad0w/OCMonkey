//
//  WeightedMonkey.h
//  OCMonkey
//
//  Created by gogleyin on 18/05/2017.
//
//

#import "SmartMonkey.h"
#import "MonkeyAlgorithm.h"

@interface WeightedMonkey : SmartMonkey

@property id<MonkeyAlgorithm> algorithm;

-(id)initWithBundleID:(NSString *)bundleID algorithm:(id<MonkeyAlgorithm>)algorithm;

@end

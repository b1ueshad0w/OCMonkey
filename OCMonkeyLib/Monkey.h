//
//  Monkey.h
//  OCMonkey
//
//  Created by gogleyin on 02/03/2017.
//
//

#import <Foundation/Foundation.h>

@interface Monkey : NSObject

-(instancetype)initWithBundleID:(NSString*)bundleID;

-(void)run:(int)steps;
@end

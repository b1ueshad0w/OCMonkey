//
//  Gesture.h
//  Master
//
//  Created by gogleyin on 23/03/2017.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

UIBezierPath* monkeyHandPath(CGFloat angle, CGFloat scale, BOOL mirrored);

@interface Gesture : NSObject
@property NSMutableArray<NSValue*> *points;
@property CALayer *containerLayer;
@property CAShapeLayer *startLayer;
@property CATextLayer *numberLayer;
@property CAShapeLayer *pathLayer;
@property CAShapeLayer *endLayer;
@property (nonatomic) int number;
+(int)counter;
-(id)initFrom:(CGPoint)from inLayer:(CALayer*)layer;
-(void)extend:(CGPoint)to;
-(void)end:(CGPoint)at;
-(void)cancel:(CGPoint)at;
@end

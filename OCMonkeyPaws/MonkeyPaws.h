//
//  MonkeyPaws.h
//  Master
//
//  Created by gogleyin on 23/03/2017.
//

#import <Foundation/Foundation.h>
#import "Gesture.h"
#import "GestureHash.h"
#import <UIKit/UIKit.h>

extern const int maxGesturesShown;
extern const CGFloat crossRadius;
extern const CGFloat circleRadius;



@interface MonkeyPaws : NSObject

@property (strong, nonatomic) NSMutableArray<GestureHash*> *gestures;
@property (strong) UIView *view;
@property CALayer *layer;

+(NSMutableArray<MonkeyPaws*>*)tappingTracks;
+(int)maxGesturesShown;
-(id)initWithView:(UIView *)view tapUIApplication: (BOOL)tap;
-(void)append:(UIEvent *)event;
//+(void)drawPaw:(UIView *)view at:(CGPoint)point;

@end

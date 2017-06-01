//
//  UIViewTree.h
//  OCMonkey
//
//  Created by gogleyin on 01/06/2017.
//
//

#import "Tree.h"
#import <UIKit/UIKit.h>

@interface UIViewInfo : NSObject

@property (nonatomic, strong) NSString *className;

@property (nonatomic) CGRect frame;

-(id)initWithClassName:(NSString *)className frame:(CGRect)frame;

@end


@interface UIViewTree : Tree

@property (nonatomic, strong) UIViewInfo *data;

@end

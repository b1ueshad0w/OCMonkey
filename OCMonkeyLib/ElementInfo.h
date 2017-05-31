//
//  ElementInfo.h
//  OCMonkey
//
//  Created by gogleyin on 26/04/2017.
//
//

#import <Foundation/Foundation.h>
#import "XCUIApplication.h"
#import "XCElementSnapshot.h"

@interface ElementInfo : NSObject <XCUIElementAttributes>

-(id)initWithSnapshot:(XCElementSnapshot *)snapshot;

@property (nonatomic, readonly) BOOL isMainWindow;

@end


@interface UIViewInfo : NSObject

@property (nonatomic, strong) NSString *className;
@property (nonatomic) CGRect frame;

-(id)initWithClassName:(NSString *)className frame:(CGRect)frame;

@end

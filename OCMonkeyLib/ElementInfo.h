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
-(id)initWithSnapshot:(XCElementSnapshot *)snapshot detectVisible:(BOOL)detectVisible;

@property (nonatomic, readonly) BOOL isMainWindow;
@property (nonatomic, readonly) BOOL isVisible;

@end

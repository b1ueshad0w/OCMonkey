//
//  XCUIElement+GGIsVisible.h
//  OCMonkey
//
//  Created by gogleyin on 22/06/2017.
//
//

#import "XCUIElement.h"
#import "XCElementSnapshot.h"

@interface XCUIElement (GGIsVisible)

@property (atomic, readonly) BOOL gg_isVisible;

@end


@interface XCElementSnapshot (GGIsVisble)

@property (atomic, readonly) BOOL gg_isVisible;

@end

//
//  APICompatibility.h
//  OCMonkey
//
//  Created by gogleyin on 12/10/2017.
//

#ifndef APICompatibility_h
#define APICompatibility_h

#import <OCMonkeyLib/OCMonkeyLib.h>

@interface XCElementSnapshot (APICompatibility)

- (XCElementSnapshot *)gg_rootElement;

@end


#endif /* APICompatibility_h */

//
//  XCElementSnapshot+GGHelpers.h
//  OCMonkeyLib
//
//  Created by gogleyin on 12/10/2017.
//

#import <OCMonkeyLib/OCMonkeyLib.h>

@interface XCElementSnapshot (GGHelpers)

/**
 Returns value for given accessibility property identifier.
 
 @param attribute attribute's accessibility identifier
 @return value for given accessibility property identifier
 */
- (id)gg_attributeValue:(NSNumber *)attribute;

@end

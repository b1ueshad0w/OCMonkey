//
//  XCUIElement+Tree.h
//  OCMonkey
//
//  Created by gogleyin on 26/04/2017.
//
//

#import "XCUIElement+Tree.h"
#import "XCElementSnapshot.h"
#import "XCUIElement.h"
#import "ElementInfo.h"

@implementation XCUIElement (Monkey)

-(ElementTree *)tree
{
    ElementTree *root = [[ElementTree alloc] initWithParent:nil
                                                   withData:[[ElementInfo alloc] initWithSnapshot:self.lastSnapshot]];
    [self buildTree:root forElement:self.lastSnapshot];
    return root;
}

-(void)buildTree:(ElementTree *)root forElement:(XCElementSnapshot *)snapshot
{
    for (XCElementSnapshot *childSnapshot in snapshot.children) {
        [root appendChildWithData:[[ElementInfo alloc] initWithSnapshot:childSnapshot]];
        [self buildTree:root.children.lastObject forElement:childSnapshot];
    }
}


@end

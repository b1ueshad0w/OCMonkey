//
//  XCUIApplication+Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 26/04/2017.
//
//

#import "XCUIApplication+Monkey.h"
#import "XCElementSnapshot.h"
#import "XCUIApplication.h"
#import "Tree.h"
#import "ElementInfo.h"

@implementation XCUIApplication (Monkey)

-(Tree *)tree
{
    Tree *root = [[Tree alloc] initWithParent:nil
                                     withData:[[ElementInfo alloc] initWithSnapshot:self.lastSnapshot]];
    [self buildTree:root forElement:self.lastSnapshot];
    return root;
}

-(void)buildTree:(Tree *)root forElement:(XCElementSnapshot *)snapshot
{
    for (XCElementSnapshot *childSnapshot in snapshot.children) {
        [root appendChildWithData:[[ElementInfo alloc] initWithSnapshot:childSnapshot]];
        [self buildTree:root.children.lastObject forElement:childSnapshot];
    }
}


@end

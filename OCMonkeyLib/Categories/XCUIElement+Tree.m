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
#import "GGLogger.h"

@implementation XCUIElement (Monkey)

-(ElementTree *)tree
{
    return [self treeDetectVisible:NO];
}

-(ElementTree *)treeDetectVisible:(BOOL)detectVisible
{
    NSDate *startTime = [NSDate date];
    ElementTree *root = [[ElementTree alloc] initWithParent:nil
                                                   withData:[[ElementInfo alloc] initWithSnapshot:self.lastSnapshot]];
    [self buildTree:root forElement:self.lastSnapshot detectVisible:detectVisible];
    NSTimeInterval timeCostInSeconds = [[NSDate date] timeIntervalSinceDate:startTime];
    [GGLogger logFmt:@"Time cost of constructing UI tree : %f", timeCostInSeconds];
    return root;
}

-(void)buildTree:(ElementTree *)root forElement:(XCElementSnapshot *)snapshot detectVisible:(BOOL)detectVisible
{
    for (XCElementSnapshot *childSnapshot in snapshot.children) {
        [root appendChildWithData:[[ElementInfo alloc] initWithSnapshot:childSnapshot detectVisible:detectVisible]];
        [self buildTree:root.children.lastObject forElement:childSnapshot detectVisible:detectVisible];
    }
}

@end

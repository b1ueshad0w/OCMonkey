//
//  UIViewController+Monkey.m
//  OCMonkey
//
//  Created by gogleyin on 02/05/2017.
//
//

#import "UIViewController+Monkey.h"
#import "NSMutableArray+FixedSizeQueue.h"
#import "Outlet.h"
#import "Macros.h"
#import "GGLogger.h"

#define UIVC @"UIViewController"

@implementation UIViewController (Monkey)

- (void)monkey_viewDidAppear:(BOOL)animated
{
//    NSString *selStr = NSStringFromSelector(_cmd);
    NSString *selStr = @"viewDidAppear:";
    NSArray<NSString *> *args = @[self.description, [NSNumber numberWithBool:animated]];
    
    NSString *className = NSStringFromClass([self class]);
    Outlet *sharedOutlet = [Outlet sharedOutlet];
    // Uncomment following lines to make the injected app crash
    //    sharedOutlet.counter++;
    //    if (sharedOutlet.counter >= 10) {
    //    NSLog(@"%@", [@[] objectAtIndex:2]);
    //    }
    [sharedOutlet.didAppearVCs enqueue:className];
    

    [sharedOutlet sendJSON:@{@"selector": selStr,
                             @"args": args,
                             @"class": UIVC}];
    
    //    if (![className hasPrefix:@"UI"]) {
    //        NSLog(@"%@ [%@(%p) viewDidAppear: %@]", prefix, className, self, animated ? @"Yes" : @"No");
    //    }
    [GGLogger logFmt:@"[%@ (did)%@] %@", UIVC, selStr, [args componentsJoinedByString:@" "]];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        if (delegate) {
            UIWindow *window;
            if ([delegate respondsToSelector:@selector(window)]) {
                window = [delegate window];
            } else {
                [GGLogger log:@"Delegate does not respond to selector (window)."];
                window = [[UIApplication sharedApplication] windows][0];
            }
            sharedOutlet.paws = [[MonkeyPaws alloc] initWithView:window tapUIApplication:YES];
        } else {
            [GGLogger log:@"Delegate is nil."];
        }
    });
    
    return [self monkey_viewDidAppear:animated];
}

- (void)monkey_showViewController:(UIViewController *)vc sender:(nullable id)sender
{
    NSString *className = NSStringFromClass([self class]);
    NSString *vcName = NSStringFromClass([vc class]);
    [GGLogger logFmt:@"[%@ showViewController: %@ sender: %@", className, vcName, NSStringFromClass([sender class])];
    return [self monkey_showViewController:vc sender:sender];
}

- (void)monkey_showDetailViewController:(UIViewController *)vc sender:(nullable id)sender
{
    NSString *className = NSStringFromClass([self class]);
    NSString *vcName = NSStringFromClass([vc class]);
    [GGLogger logFmt:@"[%@ showDetailViewController: %@ sender: %@", className, vcName, NSStringFromClass([sender class])];
    return [self monkey_showDetailViewController:vc sender:sender];
}

- (void)monkey_presentViewController:(UIViewController *)viewControllerToPresent
                            animated:(BOOL)flag
                          completion:(void (^ __nullable)(void))completion
{
    //  always displays the view controller modally
    [GGLogger logFmt:@"[%@(%p) presentViewController: %@(%p) animated: %@ completion: %@]",
          NSStringFromClass([self class]),
          self,
          NSStringFromClass([viewControllerToPresent class]),
          viewControllerToPresent,
          flag ? @"Yes" : @"No", completion];
    return [self monkey_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end

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

@implementation UIViewController (Monkey)

- (void)monkey_viewDidAppear:(BOOL)animated
{
    NSString *className = NSStringFromClass([self class]);
    Outlet *sharedOutlet = [Outlet sharedOutlet];
    // Uncomment following lines to make the injected app crash
    //    sharedOutlet.counter++;
    //    if (sharedOutlet.counter >= 10) {
    //    NSLog(@"%@", [@[] objectAtIndex:2]);
    //    }
    [sharedOutlet.didAppearVCs enqueue:className];
    

    [sharedOutlet sendJSON:@{@"selector": @"viewDidAppear:",
                             @"receiver": className,
                             @"args": @[[NSNumber numberWithBool:animated]],
                             @"returned": [NSNull null]}];
    
    //    if (![className hasPrefix:@"UI"]) {
    //        NSLog(@"%@ [%@(%p) viewDidAppear: %@]", prefix, className, self, animated ? @"Yes" : @"No");
    //    }
    NSLog(@"%@ [%@(%p) viewDidAppear: %@]", prefix, className, self, animated ? @"Yes" : @"No");
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
        if (delegate) {
            UIWindow *window;
            if ([delegate respondsToSelector:@selector(window)]) {
                window = [delegate window];
            } else {
                NSLog(@"Delegate does not respond to selector (window).");
                window = [[UIApplication sharedApplication] windows][0];
            }
            sharedOutlet.paws = [[MonkeyPaws alloc] initWithView:window tapUIApplication:YES];
        } else {
            NSLog(@"Delegate is nil.");
        }
    });
    
    return [self monkey_viewDidAppear:animated];
}

- (void)monkey_showViewController:(UIViewController *)vc sender:(nullable id)sender
{
    NSString *className = NSStringFromClass([self class]);
    NSString *vcName = NSStringFromClass([vc class]);
    NSLog(@"%@ [%@ showViewController: %@ sender: %@",
          prefix,
          className,
          vcName,
          NSStringFromClass([sender class]));
    return [self monkey_showViewController:vc sender:sender];
}

- (void)monkey_showDetailViewController:(UIViewController *)vc sender:(nullable id)sender
{
    NSString *className = NSStringFromClass([self class]);
    NSString *vcName = NSStringFromClass([vc class]);
    NSLog(@"%@ [%@ showDetailViewController: %@ sender: %@",
          prefix,
          className,
          vcName,
          NSStringFromClass([sender class]));
    return [self monkey_showDetailViewController:vc sender:sender];
}

- (void)monkey_presentViewController:(UIViewController *)viewControllerToPresent
                            animated:(BOOL)flag
                          completion:(void (^ __nullable)(void))completion
{
    //  always displays the view controller modally
    NSLog(@"%@ [%@(%p) presentViewController: %@(%p) animated: %@ completion: %@]",
          prefix,
          NSStringFromClass([self class]),
          self,
          NSStringFromClass([viewControllerToPresent class]),
          viewControllerToPresent,
          flag ? @"Yes" : @"No", completion);
    return [self monkey_presentViewController:viewControllerToPresent animated:flag completion:completion];
}

@end

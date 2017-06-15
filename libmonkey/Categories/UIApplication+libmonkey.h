//
//  UIApplication+libmonkey.h
//  OCMonkey
//
//  Created by gogleyin on 14/06/2017.
//
//

#import <UIKit/UIKit.h>

@interface UIApplication (libmonkey)

-(void)monkey_openURL:(NSURL *)url options:(nonnull NSDictionary<NSString *, id> *)options completionHandler:(void (^ __nullable)(BOOL success))completion;

-(BOOL)monkey_openURL:(NSURL *)url;

@end

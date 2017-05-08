//
//  ViewController.h
//  OCMonkeyExample
//
//  Created by gogleyin on 27/03/2017.
//
//

#import <UIKit/UIKit.h>
#import "AgentForHost.h"

@interface ViewController : UIViewController <UIChangeDelegate>

@property (strong, atomic) AgentForHost *agent;

@end


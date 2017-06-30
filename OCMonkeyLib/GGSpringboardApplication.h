//
//  GGSpringboardApplication.h
//  OCMonkey
//
//  Created by gogleyin on 22/06/2017.
//
//

#import "GGApplication.h"


@interface GGSpringboardApplication : GGApplication

/**
 Get the shared SpringBoard XCUIApplication

 @return XCUIApplicaiton instance of SpringBoard
 */
+ (instancetype)springboard;

/**
 Tap an app's icon on the Springboard.

 @param identifier app's identifier. You can use [XCUIApplication label] to obtain.
 @param error hold the error information
 @return Indicates whether the operation succeeds (YES) or not (NO).
 */
- (BOOL)tapApplicationWithIdentifier:(NSString *)identifier error:(NSError **)error;

/**
 Get the process ID of the Springboard.

 @return the process ID of the Springboard
 */
+(pid_t)springboardProcessID;

@end

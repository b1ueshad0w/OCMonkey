//
//  Keyboard.m
//  OCMonkey
//
//  Created by gogleyin on 02/06/2017.
//
//

#import "Keyboard.h"
#import "MonkeyConfiguration.h"
#import "MonkeyLogger.h"
#import "RunLoopSpinner.h"
#import "XCTestDaemonsProxy.h"
#import "XCTestManager_ManagerInterface-Protocol.h"
#import "XCUIElement.h"


@implementation Keyboard

+ (BOOL)typeText:(NSString *)text error:(NSError **)error
{
    if (![Keyboard waitUntilVisibleWithError:error]) {
        return NO;
    }
    
    NSUInteger maxTypingFrequency = [MonkeyConfiguration maxTypingFrequency];
    [MonkeyLogger logFmt:@"Typing with maximum frequency %lu", (unsigned long)maxTypingFrequency];
    
    __block BOOL didSucceed = NO;
    __block NSError *innerError;
    [RunLoopSpinner spinUntilCompletion:^(void(^completion)()){
        [[XCTestDaemonsProxy testRunnerProxy] _XCT_sendString:text maximumFrequency:maxTypingFrequency completion:^(NSError *typingError){
            didSucceed = (typingError == nil);
            innerError = typingError;
            completion();
        }];
    }];
    if (error) {
        *error = innerError;
    }
    return didSucceed;
}

+ (BOOL)waitUntilVisibleWithError:(NSError **)error
{
    /*
    XCUIElement *keyboard =
    [[[[FBRunLoopSpinner new]
       timeout:5]
      timeoutErrorMessage:@"Keyboard is not present"]
     spinUntilNotNil:^id{
         XCUIElement *foundKeyboard = [[FBApplication fb_activeApplication].query descendantsMatchingType:XCUIElementTypeKeyboard].element;
         return (foundKeyboard.exists ? foundKeyboard : nil);
     }
     error:error];
    
    if (!keyboard) {
        return NO;
    }
    
    if (![keyboard fb_waitUntilFrameIsStable]) {
        return
        [[[FBErrorBuilder builder]
          withDescription:@"Timeout waiting for keybord to stop animating"]
         buildError:error];
    }
     */
    return YES;
}

@end

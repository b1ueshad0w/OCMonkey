# OCMonkey [![GitHub license](https://img.shields.io/badge/license-BSD-lightgrey.svg)](LICENSE)

A powerful monkey testing tool for iOS.

## Features
Inspired from [SwiftMonkey](https://github.com/zalando/SwiftMonkey), written in Objective-C, but most importantly, OCMonkey has these 5 advantages:
* __OCMonkey is totally irrelevant to your test target__
You don't need to embed it into your app's source. OCMonkey can launch any app with a given bundleID.
* __Support element-based actions__
Element-based actions are very important for a Monkey tool. Coordinate-based actions are likely to have no effect on app. For example, clicking on app's blank area makes no sense. Besides, these element-based actions are implemented with private API and runs 3X faster than using the original APIs.
* __An effective traversal algorithm is provided.__
Test time is very limited. It's crucial to find potential bugs at a low time cost before committing apps to AppStore. Hence a traversal algorithm is a key factor to ensure stability of your app. By using dynamic weight adjustment, this OCMonkey is very intellegent and can reach a high coverage of your app.
* __Talk to the test app!__
By using socket communication, OCMonkey can tweak app's function. You can hook any methods of your app. You can even take over viewcontroller management. For example, you can restrict the monkey to stay in only one tab of the TabBarController. You can force OCMonkey not to enter into some viewcontroller.
> This requires app injection. I wil detail it later.
* __Fully customizable__
Thanks to the 4th feature, you can define a callback and bind it to a viewcontroller. Once OCMonkey enters into this viewcontroller, the callback will get invoked. You can do anything in the callback such as performing a series of UI action. Amaaaaaaaazing, isn't it?

## Requirements
* iOS version: >= 9.0. Support both device and simulator.
* If you were to run OCMonkey on a real device rather than a simulator, you must configure ```Code Signing``` and ```Mobile Provisioning Profiles``` settings by your self. You may also need to modify the ```bundleID``` of target ```MonkeyRunner```.

## Usage
Get an instance of  ```Monkey``` with ```bundleID```. Then configure types of actions you require the ```Monkey``` to perform. Finally starts the ```Monkey``` by ```run``` method.

```
//  MonkeyRunner.m
- (void)testRunner {
NSString *bundleID = @"com.apple.Health";
Monkey *monkey = [[Monkey alloc] initWithBundleID:bundleID];
[monkey addDefaultXCTestPrivateActions];
[monkey addXCTestTapAlertAction:100];
[monkey run:100];
}
```
All done. Run the XCUITest via ```Command+Shift+U```. Enjoy yourself.

## Documentation
There are two main categories action:
* random
* periodic

Types of random actions:
* ```XCTestTapAction```
* ```XCTestLongPressAction```
* ```XCTestDragAction```
* ```XCTestPinchCloseAction```
* ```XCTestPinchOpenAction```
* ```XCTestRotateAction```
* ```MonkeyLeafElementAction```

Add an random action to monkey by: ```[monkey addTypeName:weight]```
For example:
```
[monkey addXCTestTapAction:25];
[monkey addXCTestLongPressAction:1];
[monkey addXCTestDragAction:1];
[monkey addXCTestPinchCloseAction:1];
[monkey addXCTestPinchOpenAction:1];
[monkey addXCTestRotateAction:1];
[monkey addMonkeyLeafElementAction:25];
```

Types of periodic actions:
* ```XCTestTapAlertAction ```

Add an random action to monkey by: ```[monkey addTypeName:interval]```
For examle:
```
[monkey addXCTestTapAlertAction:100];
```

## TODO
* Support more types of monkey action [done]
* Action bases on elements rather than random coordinates on screen [done]
* Traverse Algorithm to perform a quick coverage [done]
* Support callbacks [done]
* Control ViewControllers stack [done]

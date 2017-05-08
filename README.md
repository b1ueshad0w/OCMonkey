# OCMonkey [![GitHub license](https://img.shields.io/badge/license-BSD-lightgrey.svg)](LICENSE)

A powerful monkey testing tool for iOS. 

## Features
Inspired from [SwiftMonkey](https://github.com/zalando/SwiftMonkey), written in Objective-C, but most importantly, OCMonkey has these two advantages:
* __OCMonkey is totally irrelevant to your test target__
You don't need to embed it into your app's source. OCMonkey can launch any app with a given bundleID.
* __Support element-based actions__
Element-based actions are very important for a Monkey tool. Coordinate-based actions are likely to have no effect on app. For example, clicking on app's blank area makes no sense. Besides, these element-based actions are implemented with private API and executed more faster than using the original APIs. 


## Requirements
iOS version: >= 9.0
Support both device and simulator.
If you were to run OCMonkey on a real device rather than a simulator, you must configure ```Code Signing``` and ```Mobile Provisioning Profiles``` settings by your self. You may also need to modify the ```bundleID``` of target ```MonkeyRunner```.

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
* Traverse Algorithm to perform a quick coverage
* Support callbacks
* Control ViewControllers stack [done]

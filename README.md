# OCMonkey
Monkey Testing for iOS

## Overview
Inspired from [SwiftMonkey](https://github.com/zalando/SwiftMonkey), written in Objective-C, but most importantly, OCMonkey is totally irrelevant to your test target! In other words, you don't have to    modify your app's project.

## Installation
Could not be more simple. No other requirement.


## Requirements
iOS version: >= 9.0
Support both device and simulators.
If you were to run monkey on real device rather than simulators, you must configure ```Code Signing``` and ```Mobile Provisioning Profiles``` settings by your self. You may also need to modify the ```bundleID``` of target ```MonkeyRunner```.

### Usage
The first parameter is the bundleID of your tested app.
The second parameter is the events count for the monkey.
All done. Run the XCUITest via ```Command+Shift+U```. Enjoy yourselfQ
```
//  MonkeyRunner.m
[[[Monkey alloc] initWithBundleID:@"com.apple.Health"] run:100];
```

### TODO
* Support more types of monkey action
* Action bases on elements rather than random coordinates on screen
* Traverse Algorithm to perform a quick coverage
* Support callbacks

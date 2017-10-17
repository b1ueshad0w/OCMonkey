//
//  XCTestPrivateSymbols.m
//  OCMonkeyLib
//
//  Created by gogleyin on 12/10/2017.
//

#import "XCTestPrivateSymbols.h"
#import "GGRuntimeUtils.h"

NSNumber *GG_XCAXAIsVisibleAttribute;
NSNumber *GG_XCAXAIsElementAttribute;

void (*XCSetDebugLogger)(id <XCDebugLogDelegate>);
id<XCDebugLogDelegate> (*XCDebugLogger)(void);

__attribute__((constructor)) void FBLoadXCTestSymbols(void)
{
    NSString *XC_kAXXCAttributeIsVisible = *(NSString*__autoreleasing*)GGRetrieveXCTestSymbol("XC_kAXXCAttributeIsVisible");
    NSString *XC_kAXXCAttributeIsElement = *(NSString*__autoreleasing*)GGRetrieveXCTestSymbol("XC_kAXXCAttributeIsElement");
    
    NSArray *(*XCAXAccessibilityAttributesForStringAttributes)(NSArray *list) =
    (NSArray<NSNumber *> *(*)(NSArray *))GGRetrieveXCTestSymbol("XCAXAccessibilityAttributesForStringAttributes");
    
    XCSetDebugLogger = (void (*)(id <XCDebugLogDelegate>))GGRetrieveXCTestSymbol("XCSetDebugLogger");
    XCDebugLogger = (id<XCDebugLogDelegate>(*)(void))GGRetrieveXCTestSymbol("XCDebugLogger");
    
    NSArray<NSNumber *> *accessibilityAttributes = XCAXAccessibilityAttributesForStringAttributes(@[XC_kAXXCAttributeIsVisible, XC_kAXXCAttributeIsElement]);
    GG_XCAXAIsVisibleAttribute = accessibilityAttributes[0];
    GG_XCAXAIsElementAttribute = accessibilityAttributes[1];
    
    NSCAssert(GG_XCAXAIsVisibleAttribute != nil , @"Failed to retrieve GG_XCAXAIsVisibleAttribute", GG_XCAXAIsVisibleAttribute);
    NSCAssert(GG_XCAXAIsElementAttribute != nil , @"Failed to retrieve GG_XCAXAIsElementAttribute", GG_XCAXAIsElementAttribute);
}

void *GGRetrieveXCTestSymbol(const char *name)
{
    Class XCTestClass = NSClassFromString(@"XCTestCase");
    NSCAssert(XCTestClass != nil, @"XCTest should be already linked", XCTestClass);
    NSString *XCTestBinary = [NSBundle bundleForClass:XCTestClass].executablePath;
    const char *binaryPath = XCTestBinary.UTF8String;
    NSCAssert(binaryPath != nil, @"XCTest binary path should not be nil", binaryPath);
    return GGRetrieveSymbolFromBinary(binaryPath, name);
}

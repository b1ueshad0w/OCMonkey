//
//  ElementInfo.m
//  OCMonkey
//
//  Created by gogleyin on 26/04/2017.
//
//

#import "ElementInfo.h"
#import "ElementTypeTransformer.h"
#import <XCTest/XCUIElementAttributes.h>

@interface ElementInfo ()

@property (nonatomic, readwrite) XCUIElementType elementType;
@property (nonatomic, readwrite) NSString *identifier;
@property (nonatomic, readwrite) CGRect frame;
@property (nonatomic, readwrite) id value;
@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *label;
@property (nonatomic, readwrite, getter = isEnabled) BOOL enabled;
@property (nonatomic, readwrite, nullable) NSString *placeholderValue;
@property (nonatomic, readwrite, getter = isSelected) BOOL selected;
@property (nonatomic, readwrite) XCUIUserInterfaceSizeClass horizontalSizeClass;
@property (nonatomic, readwrite) XCUIUserInterfaceSizeClass verticalSizeClass;
@end

@implementation ElementInfo

-(id)initWithSnapshot:(XCElementSnapshot *)snapshot
{
    self = [super init];
    if (self) {
        _identifier = snapshot.identifier;
        _frame = snapshot.frame;
        _value = snapshot.value;
        _title = snapshot.title;
        _label = snapshot.label;
        _elementType = snapshot.elementType;
        _enabled = snapshot.enabled;
        _selected = snapshot.selected;
        _placeholderValue = snapshot.placeholderValue;
    }
    return self;
}

-(NSString *)description
{
    NSString *elementType = [ElementTypeTransformer shortStringWithElementType:_elementType];
    return [NSString stringWithFormat:@"type: %@ | frame: {{%.1f, %.1f},{%.1f, %.1f}} | label: %@", elementType, _frame.origin.x, _frame.origin.y, _frame.size.width, _frame.size.height, _label];
}

@end

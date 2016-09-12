//
//  UITableViewCell+PureForm.m
//
// Copyright (c) 2016 Puzyrev Pavel
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "UITableViewCell+PureForm.h"
#import <objc/runtime.h>
#import "PFEnums.h"
#import "PFConstants.h"
#import "PFProtocols.h"
#import "UIView+PureForm.h"
#import "PFInputView+Validation.h"
#import "UISlider+PureForm.h"
#import "UIColor+PureForm.h"

@implementation UITableViewCell (PureForm)

- (void)setValue:(id)value forPropertyName:(id)inputView {
    id inputViewObject = [self valueForKey:inputView];

    if ([inputViewObject respondsToSelector:@selector(text)]) {
        id <PFText> dInputViewObject = inputViewObject;
        dInputViewObject.text = value;
    }

    if ([inputViewObject isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *segmentedControl = inputViewObject;
        segmentedControl.selectedSegmentIndex = [value integerValue];
    }

    if ([inputViewObject isKindOfClass:[UISwitch class]]) {
        UISwitch *switchControl = inputViewObject;
        switchControl.on = [value boolValue];
    }

    if ([inputViewObject isKindOfClass:[UIStepper class]]) {
        UIStepper *stepperControl = inputViewObject;

        double dValue = [PFInputView doubleWithComparableNumber:value number:@(stepperControl.stepValue)];
        stepperControl.value = dValue;
        stepperControl.pf_display.text = [NSString stringWithFormat:@"%@", @(dValue)];
    }

    if ([inputViewObject isKindOfClass:[UISlider class]]) {
        UISlider *sliderControl = inputViewObject;

        sliderControl.value = [value floatValue];
        sliderControl.pf_display.text = [value stringValue];
    }
}

- (void)setValue:(id)value forKeyPath:(NSString *)keyPath {
    NSString *propertyName = [keyPath componentsSeparatedByString:@"."].firstObject;
    NSString *paramName = [keyPath componentsSeparatedByString:@"."].lastObject;
    id view = [self valueForKey:propertyName];

    Class propertyClass = [[self valueForKeyPath:propertyName] class];
    Class paramClass = [self classOfPropertyNamed:paramName withOwnerClass:propertyClass];

    if (paramClass == [UIImage class]) {
        UIImage *image = [UIImage imageNamed:value];
        if ([value containsString:PFSpecialCharHex]) {
            NSArray *valueComponents = [value componentsSeparatedByString:PFSpecialCharHex];
            image = [UIImage imageNamed:valueComponents.firstObject];
            image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            [view setTintColor:[UIColor pf_colorWithHexString:valueComponents.lastObject]];
        }

        [super setValue:image forKeyPath:keyPath];

        return;
    }

    if (paramClass == [UIColor class]) {
        [super setValue:[UIColor pf_colorWithHexString:value] forKeyPath:keyPath];

        return;
    }

#pragma mark - UITextInputTraits

    //TODO: I'm not sure that it's a good solution, but it works, hm
    if ([view conformsToProtocol:@protocol(UITextInputTraits)]) {
        NSDictionary *specialInputTraitsCases = @{
                [NSString stringWithFormat:@"%@.autocapitalizationType", propertyName] : ^(UITextField *t, NSInteger v) {
                    t.autocapitalizationType = (UITextAutocapitalizationType) v;
                },
                [NSString stringWithFormat:@"%@.autocorrectionType", propertyName] : ^(UITextField *t, NSInteger v) {
                    t.autocorrectionType = (UITextAutocorrectionType) v;
                },
                [NSString stringWithFormat:@"%@.spellCheckingType", propertyName] : ^(UITextField *t, NSInteger v) {
                    t.spellCheckingType = (UITextSpellCheckingType) v;
                },
                [NSString stringWithFormat:@"%@.keyboardType", propertyName] : ^(UITextField *t, NSInteger v) {
                    t.keyboardType = (UIKeyboardType) v;
                },
                [NSString stringWithFormat:@"%@.keyboardAppearance", propertyName] : ^(UITextField *t, NSInteger v) {
                    t.keyboardAppearance = (UIKeyboardAppearance) v;
                },
                [NSString stringWithFormat:@"%@.returnKeyType", propertyName] : ^(UITextField *t, NSInteger v) {
                    t.returnKeyType = (UIReturnKeyType) v;
                }};

        NSDictionary *specialBoolCases = @{
                [NSString stringWithFormat:@"%@.enablesReturnKeyAutomatically", propertyName] : ^(UITextField *t, BOOL v) {
                    t.enablesReturnKeyAutomatically = v;
                },
                [NSString stringWithFormat:@"%@.secureTextEntry", propertyName] : ^(UITextField *t, BOOL v) {
                    t.secureTextEntry = v;
                }};

        if ([specialInputTraitsCases.allKeys containsObject:keyPath]) {
            void (^block)(UITextField *f, NSInteger v) = specialInputTraitsCases[keyPath];
            block(view, [PFEnums enumFromValue:value]);

            return;
        }

        if ([specialBoolCases.allKeys containsObject:keyPath]) {
            void (^block)(UITextField *f, BOOL v) = specialBoolCases[keyPath];
            block(view, [value boolValue]);

            return;
        }
    }

#pragma mark - UISegmentedControl

    if ([view isKindOfClass:[UISegmentedControl class]]) {
        NSCharacterSet *notNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
        NSUInteger index = (NSUInteger) [[paramName stringByTrimmingCharactersInSet:notNumbers] integerValue];

        UISegmentedControl *segmentedControl = view;

        if ([paramName containsString:PFSegmentedControlSectionTitleKey]) {
            [segmentedControl removeSegmentAtIndex:index animated:NO];
            [segmentedControl insertSegmentWithTitle:value atIndex:index animated:NO];

            return;
        }

        if ([paramName containsString:PFSegmentedControlSectionImageKey]) {
            [segmentedControl removeSegmentAtIndex:index animated:NO];
            [segmentedControl insertSegmentWithImage:[UIImage imageNamed:value] atIndex:index animated:NO];

            return;
        }
    }

    if ([view isKindOfClass:[UISwitch class]]) {
        UISwitch *switchControl = view;
        switchControl.on = [value boolValue];

        return;
    }

    if ([view isKindOfClass:[UISlider class]] && [paramName isEqualToString:PFSliderControlStepValueKey]) {
        UISlider *sliderControl = view;
        sliderControl.pf_stepValue = [value floatValue];

        return;
    }

    [super setValue:value forKeyPath:keyPath];
}

- (Class)classOfPropertyNamed:(NSString *)propertyName withOwnerClass:(Class)ownerClass {
    if (ownerClass == NULL) {
        return NULL;
    }

    Class propertyClass = nil;
    objc_property_t property = class_getProperty(ownerClass, [propertyName UTF8String]);

    if (property == NULL) {
        return NULL;
    }

    NSString *propertyAttributes = [NSString stringWithCString:property_getAttributes(property) encoding:NSUTF8StringEncoding];
    NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];

    if (splitPropertyAttributes.count > 0) {
        NSString *encodeType = splitPropertyAttributes[0];
        NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
        NSString *className = splitEncodeType.count > 1 ? splitEncodeType[1] : nil;
        propertyClass = NSClassFromString(className);
    }

    return propertyClass;
}

@end

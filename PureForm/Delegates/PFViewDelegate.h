//
// PFViewDelegate.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PFSegmentedControlDelegate <NSObject>

@optional
/**
 Called when a UISegmentedControl value was changed.
 @param segmentedControl The UISegmentedControl object.
 @param index The index of the selected item.
 */
- (void)segmentedControl:(UISegmentedControl *)segmentedControl didSelectItemAtIndex:(NSInteger)index;

@end

@protocol PFSwitchControlDelegate <NSObject>

@optional
/**
 Called when a UISwitch value was changed.
 @param switchControl The UISwitch object.
 @param state The state of UISwitch object.
 */
- (void)switchControl:(UISwitch *)switchControl didChangeState:(BOOL)state;

@end

@protocol PFSliderControlDelegate <NSObject>

@optional
/**
 Called when the user interaction with a UISlider object was ended.
 @param sliderControl The UISlider object.
 @param value The value of UISlider object.
 */
- (void)sliderControl:(UISlider *)sliderControl didChangeValue:(CGFloat)value;

@end

@protocol PFStepperControlDelegate <NSObject>

@optional
/**
 Called when a UIStepper value was changed.
 @param stepperControl The UIStepper object.
 @param value The value of UIStepper object.
 */
- (void)stepperControl:(UIStepper *)stepperControl didChangeValue:(CGFloat)value;

@end

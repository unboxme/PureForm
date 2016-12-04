//
// PFSettings.h
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
#import "PFViewDelegate.h"
#import "PFFormDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface PFSettings : NSObject

/**
 Provides a real-time validation for approved characters by UIKeyboardType.
 `NO` by default.
 */
@property(assign, nonatomic, getter=isKeyboardTypeValidation) BOOL keyboardTypeValidation;

/**
 Provides an automatic keyboard avoiding.
 `NO` by default.
 */
@property(assign, nonatomic, getter=isKeyboardAvoiding) BOOL keyboardAvoiding;

/**
 The height for each cell in the table view.
 `nil` by default.
 */
@property(strong, nonatomic, nullable) NSDictionary *failureReasons;

/**
 The height for each cell in the table view.
 `PFCellHeightDefault` by default.
 */
@property(assign, nonatomic) CGFloat cellHeight;

///----------------
/// @name Delegates
///----------------

@property(weak, nonatomic, nullable) id <PFFormDelegate> formDelegate;

@property(weak, nonatomic, nullable) id <UITableViewDelegate> tableViewDelegate;

@property(weak, nonatomic, nullable) id <UITextFieldDelegate> textFieldDelegate;

@property(weak, nonatomic, nullable) id <PFSegmentedControlDelegate> segmentedControlDelegate;

@property(weak, nonatomic, nullable) id <PFSwitchControlDelegate> switchControlDelegate;

@property(weak, nonatomic, nullable) id <PFSliderControlDelegate> sliderControlDelegate;

@property(weak, nonatomic, nullable) id <PFStepperControlDelegate> stepperControlDelegate;

@end

///---------------------------
/// @name Cell height contants
///---------------------------

/**
 Similar to UITableViewAutomaticDimension.
 */
FOUNDATION_EXPORT CGFloat const PFCellHeightAutomatic;

/**
 Equals to storyboard params.
 */
FOUNDATION_EXPORT CGFloat const PFCellHeightDefault;

///-------------------------------------
/// @name Validation failure reason keys
///-------------------------------------

/**
 When the value doesn't match the expected one.
 */
FOUNDATION_EXPORT NSString *const PFValidationEqualFailureKey;

/**
 When the value doesn't match the next one.
 */
FOUNDATION_EXPORT NSString *const PFValidationEqualNextFailureKey;

/**
 When the value doesn't match the previous one.
 */
FOUNDATION_EXPORT NSString *const PFValidationEqualPreviousFailureKey;

/**
 When the value length doesn't match expected one.
 */
FOUNDATION_EXPORT NSString *const PFValidationEqualLengthFailureKey;

/**
 When the value length is too short, than expected.
 */
FOUNDATION_EXPORT NSString *const PFValidationMinLengthFailureKey;

/**
 When the value length is too long, than expected.
 */
FOUNDATION_EXPORT NSString *const PFValidationMaxLengthFailureKey;

/**
 When the value length is too small, than expected.
 */
FOUNDATION_EXPORT NSString *const PFValidationMinValueFailureKey;

/**
 When the value length is too big, than expected.
 */
FOUNDATION_EXPORT NSString *const PFValidationMaxValueFailureKey;

/**
 When the value doesn't exist.
 */
FOUNDATION_EXPORT NSString *const PFValidationRequiredFailureKey;

/**
 When the value doesn't match special format.
 */
FOUNDATION_EXPORT NSString *const PFValidationTypeFailureKey;

/**
 When the value doesn't match regex format.
 */
FOUNDATION_EXPORT NSString *const PFValidationCustomFailureKey;

/**
 When uses unknown validator.
 */
FOUNDATION_EXPORT NSString *const PFValidationUnknownFailureKey;

NS_ASSUME_NONNULL_END

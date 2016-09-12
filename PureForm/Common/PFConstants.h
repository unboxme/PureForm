//
// PFConstants.h
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

#pragma mark - NSNotification

static NSString *const PFDisplayLabelShouldChangeNotification = @"PFDisplayLabelShouldChangeNotification";

#pragma mark - JSON Keys

static NSString *const PFSectionKey = @"<section>";
static NSString *const PFValueKey = @"<value>";
static NSString *const PFKeyKey = @"<key>";
static NSString *const PFValidationKey = @"<validators>";
static NSString *const PFDisplayKey = @"<display>";

static NSString *const PFValidationEqualKey = @"equal";
static NSString *const PFValidationEqualNextKey = @"equal_next";
static NSString *const PFValidationEqualPreviousKey = @"equal_previous";
static NSString *const PFValidationEqualLengthKey = @"equal_length";
static NSString *const PFValidationMinLengthKey = @"min_length";
static NSString *const PFValidationMaxLengthKey = @"max_length";
static NSString *const PFValidationMinValueKey = @"min_value";
static NSString *const PFValidationMaxValueKey = @"max_value";
static NSString *const PFValidationRequiredKey = @"required";
static NSString *const PFValidationTypeKey = @"type";
static NSString *const PFValidationCustomKey = @"custom";

static NSString *const PFValidationTypeEmailKey = @"email";
static NSString *const PFValidationTypeNameKey = @"full_name";

#pragma mark - Special Chars

static NSString *const PFSpecialCharBegin = @"<";
static NSString *const PFSpecialCharEnd = @">";
static NSString *const PFSpecialCharPlus = @"+";
static NSString *const PFSpecialCharSame = @"=";
static NSString *const PFSpecialCharHex = @"#";

static NSString *const PFSuffixForce = @"!";
static NSString *const PFSuffixFormView = @"?";
static NSString *const PFSuffixLocalized = @"*";

static NSString *const PFUnknownKey = @"unknown_key";

#pragma mark - Available Chars

static NSString *const PFPhonePadCharacters = @"+*#0123456789";
static NSString *const PFNumberPadCharacters = @"0123456789";
static NSString *const PFDecimalPadCharacters = @".,0123456789";

#pragma mark - Custom Controls

static NSString *const PFSegmentedControlSectionTitleKey = @"sectionTitle";
static NSString *const PFSegmentedControlSectionImageKey = @"sectionImage";
static NSString *const PFSliderControlStepValueKey = @"stepValue";

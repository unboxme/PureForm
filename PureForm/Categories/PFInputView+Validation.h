//
// PFInputView+Validation.h
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

#import "PFInputView.h"
#import "PFValidator.h"
#import "PFModel.h"

@interface PFInputView (Validation)

/**
 @param value The value for validation.
 @param number The array of PFModel objects from the section.
 @param index The index of the first param.
 @param force Use `YES` for a quick validation. Only validators with `!` will be used.
 @return The failed validation PFValidator object.
 */
- (PFValidator *)failedValidatorWithValue:(id)value sectionModels:(NSArray<PFModel *> *)models modelIndex:(NSUInteger)index force:(BOOL)force;

/**
 @param comparable The full `float` or `double`, wrapped into NSNumber value which will be corrected.
 @param number The `float` or `double` wrapped into NSNumber value without odd numbers.
 @return The double value without odd numbers.
 */
+ (double)doubleWithComparableNumber:(NSNumber *)comparable number:(NSNumber *)number;

@end

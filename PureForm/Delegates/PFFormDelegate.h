//
// PFFormDelegate.h
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
#import "PFModel.h"
#import "PFError.h"

@protocol PFFormDelegate <NSObject>

@optional
/**
 Called when a value was successfully updated.
 */
- (void)valueDidUpdate;

/**
 Called when a value was successfully updated.
 @param inputView The updated PFInputView object.
 */
- (void)valueDidUpdateWithInputView:(PFInputView *)inputView;

/**
 Called when a value was updated with a validation error.
 @param error The validation error.
 */
- (void)valueDidUpdateWithError:(PFError *)error;

/**
 Called when values successfully passed a validation.
 */
- (void)validationDidEndSuccessfully;

/**
 Called when values failed a validation.
 @param errors The array of validation errors.
 */
- (void)validationDidFailWithErrors:(NSArray<PFError *> *)errors;

@end

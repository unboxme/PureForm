//
// NSString+PureForm.h
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

@interface NSString (PureForm)

/**
 @return `YES` if the string is special PureForm key, otherwise `NO`.
 */
- (BOOL)pf_isSpecialKey;

/**
 @return `YES` if the string contains cell class and identifier, otherwise `NO`.
 */
- (BOOL)pf_isCombinedKey;

/**
 @return `YES` if the string has suffix, otherwise `NO`.
 */
- (BOOL)pf_hasSuffix;

/**
 @return `YES` if the string has localized suffix, otherwise `NO`.
 */
- (BOOL)pf_hasLocalizedSuffix;

/**
 @return `YES` if the string has form view suffix, otherwise `NO`.
 */
- (BOOL)pf_hasFormViewSuffix;

/**
 @return The cell class name.
 */
- (NSString *)pf_cellClassName;

/**
 @return The cell identifier.
 */
- (NSString *)pf_cellIdentifier;

/**
 @return The string without suffix.
 */
- (NSString *)pf_suffixFreeString;

@end

//
// NSString+PureForm.m
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

#import "NSString+PureForm.h"
#import "PFConstants.h"

@implementation NSString (PureForm)

NSArray *availablePFSuffixes() {
    return @[PFSuffixFormView, PFSuffixForce, PFSuffixLocalized];
};

- (NSString *)pf_suffix {
    NSInteger suffixIndex = self.length - 1;

    if (suffixIndex < 1) {
        return nil;
    }

    return [self substringFromIndex:(NSUInteger) suffixIndex];
}

- (NSString *)pf_clearString {
    NSString *forbiddenChars = [NSString stringWithFormat:@"%@%@", PFSpecialCharBegin, PFSpecialCharEnd];
    NSCharacterSet *specialCharacterSet = [NSCharacterSet characterSetWithCharactersInString:forbiddenChars];

    NSString *string = self;
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    string = [string stringByTrimmingCharactersInSet:specialCharacterSet];

    return string;
}

#pragma mark -

- (BOOL)pf_isSpecialKey {
    if (self.length < 3) {
        return NO;
    }

    NSString *firstChar = [self substringToIndex:1];
    NSString *lastChar = [self substringFromIndex:self.length - 1];

    return [firstChar isEqualToString:PFSpecialCharBegin] && [lastChar isEqualToString:PFSpecialCharEnd];
}

- (BOOL)pf_isCombinedKey {
    return [[self pf_clearString] componentsSeparatedByString:PFSpecialCharPlus].count > 1;
}

- (BOOL)pf_hasSuffix {
    return [availablePFSuffixes() containsObject:[self pf_suffix]];
}

- (BOOL)pf_hasLocalizedSuffix {
    return [[self pf_suffix] isEqualToString:PFSuffixLocalized];
}

- (BOOL)pf_hasFormViewSuffix {
    return [[self pf_suffix] isEqualToString:PFSuffixFormView];
}

- (NSString *)pf_cellClassName {
    return [[self pf_clearString] componentsSeparatedByString:PFSpecialCharPlus].firstObject;
}

- (NSString *)pf_cellIdentifier {
    return [[self pf_clearString] componentsSeparatedByString:PFSpecialCharPlus].lastObject;
}

- (NSString *)pf_suffixFreeString {
    if (![self pf_hasSuffix]) {
        return self;
    }

    return [[self pf_clearString] substringToIndex:self.length - 1];
}

@end

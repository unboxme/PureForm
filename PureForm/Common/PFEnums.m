//
// PFEnums.m
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

#import "PFEnums.h"

#import "NSString+PureForm.h"
#import "PFConstants.h"

@implementation PFEnums

+ (NSInteger)enumFromValue:(id)value {
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value integerValue];
    }

    value = [value pf_suffixFreeString];

    NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"ANY SELF == %@", value];
    NSArray *results = [[self enumValues] filteredArrayUsingPredicate:searchPredicate];

    if (results.count > 0) {
        return (NSInteger) [results.firstObject indexOfObject:value];
    }

    return 0;
}

+ (NSArray<NSArray *> *)enumValues {
    static NSArray *enumValues = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{

#pragma mark - PureForm

        NSArray *PFValidationArray = @[
                PFValidationEqualKey,
                PFValidationEqualNextKey,
                PFValidationEqualPreviousKey,
                PFValidationEqualLengthKey,
                PFValidationMinLengthKey,
                PFValidationMaxLengthKey,
                PFValidationMinValueKey,
                PFValidationMaxValueKey,
                PFValidationRequiredKey,
                PFValidationTypeKey,
                PFValidationCustomKey,
        ];

#pragma mark - UITextInputTraits

        NSArray *UITextAutocapitalizationTypeArray = @[
                @"UITextAutocapitalizationTypeNone",
                @"UITextAutocapitalizationTypeWords",
                @"UITextAutocapitalizationTypeSentences",
                @"UITextAutocapitalizationTypeAllCharacters"
        ];

        NSArray *UITextAutocorrectionTypeArray = @[
                @"UITextAutocorrectionTypeDefault",
                @"UITextAutocorrectionTypeNo",
                @"UITextAutocorrectionTypeYes"
        ];

        NSArray *UITextSpellCheckingTypeArray = @[
                @"UITextSpellCheckingTypeDefault",
                @"UITextSpellCheckingTypeNo",
                @"UITextSpellCheckingTypeYes"
        ];

        NSArray *UIKeyboardTypeArray = @[
                @"UIKeyboardTypeDefault",
                @"UIKeyboardTypeASCIICapable",
                @"UIKeyboardTypeNumbersAndPunctuation",
                @"UIKeyboardTypeURL",
                @"UIKeyboardTypeNumberPad",
                @"UIKeyboardTypePhonePad",
                @"UIKeyboardTypeNamePhonePad",
                @"UIKeyboardTypeEmailAddress",
                @"UIKeyboardTypeDecimalPad",
                @"UIKeyboardTypeTwitter",
                @"UIKeyboardTypeWebSearch",
                @"UIKeyboardTypeAlphabet"
        ];

        NSArray *UIKeyboardAppearanceArray = @[
                @"UIKeyboardAppearanceDefault",
                @"UIKeyboardAppearanceDark",
                @"UIKeyboardAppearanceLight",
                @"UIKeyboardAppearanceAlert"
        ];

        NSArray *UIReturnKeyTypeArray = @[
                @"UIReturnKeyDefault",
                @"UIReturnKeyGo",
                @"UIReturnKeyGoogle",
                @"UIReturnKeyJoin",
                @"UIReturnKeyNext",
                @"UIReturnKeyRoute",
                @"UIReturnKeySearch",
                @"UIReturnKeySend",
                @"UIReturnKeyYahoo",
                @"UIReturnKeyDone",
                @"UIReturnKeyEmergencyCall",
                @"UIReturnKeyContinue"
        ];

#pragma mark - UITextField

        NSArray *UITextFieldViewModeArray = @[
                @"UITextFieldViewModeNever",
                @"UITextFieldViewModeWhileEditing",
                @"UITextFieldViewModeUnlessEditing",
                @"UITextFieldViewModeAlways"
        ];

#pragma mark - Output

        enumValues = @[
                PFValidationArray,
                UITextAutocapitalizationTypeArray,
                UITextAutocorrectionTypeArray,
                UITextSpellCheckingTypeArray,
                UIKeyboardTypeArray,
                UIKeyboardAppearanceArray,
                UIReturnKeyTypeArray,
                UITextFieldViewModeArray
        ];

    });

    return enumValues;
}

@end

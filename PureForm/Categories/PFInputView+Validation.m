//
// PFInputView+Validation.m
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

#import "PFInputView+Validation.h"
#import "PFConstants.h"

@implementation PFInputView (Validation)

- (PFValidator *)failedValidatorWithValue:(id)value sectionModels:(NSArray<PFModel *> *)models modelIndex:(NSUInteger)index force:(BOOL)force {
    for (PFValidator *validator in self.validators) {
        if (force && !validator.isForceValidation) {
            continue;
        }

        switch (validator.type) {
            case PFValidatorTypeEqual: {
                if (![value isEqual:validator.value]) {
                    return validator;
                }

                break;
            }
            case PFValidatorTypeEqualNext: {
                if (index >= models.count - 1) {
                    break;
                }

                NSArray<PFInputView *> *nextInputViews = models[index + 1].inputViews;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFormView == YES"];
                NSArray<PFInputView *> *results = [nextInputViews filteredArrayUsingPredicate:predicate];

                if (results.count == 0) {
                    break;
                }

                if (![results.firstObject.value isEqual:value]) {
                    return validator;
                }

                break;
            }
            case PFValidatorTypeEqualPrevious: {
                if (index == 0) {
                    break;
                }

                NSArray<PFInputView *> *nextInputViews = models[index - 1].inputViews;
                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isFormView == YES"];
                NSArray<PFInputView *> *results = [nextInputViews filteredArrayUsingPredicate:predicate];

                if (results.count == 0) {
                    break;
                }

                if (![results.firstObject.value isEqual:value]) {
                    return validator;
                }

                break;
            }
            case PFValidatorTypeEqualLength: {
                if (!value && [validator.value integerValue] > 0) {
                    return validator;
                }

                if (![value isKindOfClass:[NSString class]]) {
                    NSString *string = value;
                    if (string.length != [validator.value integerValue]) {
                        return validator;
                    }
                }

                break;
            }
            case PFValidatorTypeMinLength: {
                if (!value && [validator.value integerValue] > 0) {
                    return validator;
                }

                if ([value isKindOfClass:[NSString class]]) {
                    NSString *string = value;
                    if (string.length < [validator.value integerValue]) {
                        return validator;
                    }
                }

                break;
            }
            case PFValidatorTypeMaxLength: {
                if ([value isKindOfClass:[NSString class]]) {
                    NSString *string = value;
                    if (string.length > [validator.value integerValue]) {
                        return validator;
                    }
                }

                break;
            }
            case PFValidatorTypeMinValue: {
                if ([value isKindOfClass:[NSNumber class]]) {
                    if ([PFInputView doubleWithComparableNumber:value number:validator.value] < [validator.value doubleValue]) {
                        return validator;
                    }
                }

                break;
            }
            case PFValidatorTypeMaxValue: {
                if ([value isKindOfClass:[NSNumber class]]) {
                    if ([PFInputView doubleWithComparableNumber:value number:validator.value] > [validator.value doubleValue]) {
                        return validator;
                    }
                }

                break;
            }
            case PFValidatorTypeRequired: {
                if (!value) {
                    return validator;
                }

                if ([value isKindOfClass:[NSString class]]) {
                    NSString *string = value;
                    if ([string isEqualToString:@""]) {
                        return validator;
                    }
                }

                break;
            }
            case PFValidatorTypeFormType:
            case PFValidatorTypeCustom: {
                if (![value isKindOfClass:[NSString class]] || ![validator.value isKindOfClass:[NSString class]]) {
                    return validator;
                }

                NSString *regexString;
                if ([validator.value isEqualToString:PFValidationTypeEmailKey]) {
                    regexString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
                } else if ([validator.value isEqualToString:PFValidationTypeNameKey]) {
                    regexString = @"^[a-z]([-']?[a-z]+)*( [a-z]([-']?[a-z]+)*)+$";
                } else {
                    regexString = validator.value;
                }

                NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regexString];
                if (![predicate evaluateWithObject:value]) {
                    return validator;
                }

                break;
            }
            case PFValidatorTypeUnknown: {
                break;
            }
        }
    }

    return nil;
}

+ (double)doubleWithComparableNumber:(NSNumber *)comparable number:(NSNumber *)number {
    NSString *fraction = [[NSString stringWithFormat:@"%@", number]
            componentsSeparatedByCharactersInSet:[NSCharacterSet punctuationCharacterSet]].lastObject;
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setRoundingMode:NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:fraction.length];

    return [[formatter stringFromNumber:comparable] doubleValue];
}

@end

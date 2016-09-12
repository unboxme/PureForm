//
// PFValidator+FailureReason.m
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

#import "PFValidator+FailureReason.h"
#import "PFSettings.h"

@implementation PFValidator (FailureReason)

- (NSString *)failureReasonWithUserReasons:(NSDictionary *)failureReasons {
    static NSDictionary *defaultReasons = nil;
    static NSArray *defaultReasonsArray = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        defaultReasons = @{
                PFValidationEqualFailureKey : @"Value doesn't match expected one (%@)",
                PFValidationEqualNextFailureKey : @"Value doesn't match next one",
                PFValidationEqualPreviousFailureKey : @"Value doesn't match previous one",
                PFValidationEqualLengthFailureKey : @"Value length doesn't match expected one (%@)",
                PFValidationMinLengthFailureKey : @"String length is too short, than expected (%@)",
                PFValidationMaxLengthFailureKey : @"String length is too long, than expected (%@)",
                PFValidationMinValueFailureKey : @"Value is too small, than expected (%@)",
                PFValidationMaxValueFailureKey : @"Value is too big, than expected (%@)",
                PFValidationRequiredFailureKey : @"Value is required",
                PFValidationTypeFailureKey : @"Value doesn't match %@ format",
                PFValidationCustomFailureKey : @"Check value you entered",
                PFValidationUnknownFailureKey : @""
        };

        defaultReasonsArray = @[
                PFValidationEqualFailureKey,
                PFValidationEqualNextFailureKey,
                PFValidationEqualPreviousFailureKey,
                PFValidationEqualLengthFailureKey,
                PFValidationMinLengthFailureKey,
                PFValidationMaxLengthFailureKey,
                PFValidationMinValueFailureKey,
                PFValidationMaxValueFailureKey,
                PFValidationRequiredFailureKey,
                PFValidationTypeFailureKey,
                PFValidationCustomFailureKey,
                PFValidationUnknownFailureKey
        ];
    });

    NSString *value = [self.value isKindOfClass:[NSNumber class]] ? [self.value stringValue] : self.value;
    NSString *key = defaultReasonsArray[self.type];
    NSString *reason = [failureReasons.allKeys containsObject:key] ? failureReasons[key] : defaultReasons[key];
    reason = [reason stringByReplacingOccurrencesOfString:@"%@" withString:value];

    return reason;
}

@end

//
//  UIColor+PureForm.m
//  Example
//
//  Created by Puzyrev Pavel on 23.08.16.
//  Copyright © 2016 Puzyrev Pavel. All rights reserved.
//

#import "UIColor+PureForm.h"
#import "PFConstants.h"

@implementation UIColor (PureForm)

+ (UIColor *)pf_colorWithHexString:(NSString *)hexString {
    unsigned rgbValue = 0;

    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:[hexString containsString:PFSpecialCharHex] ? 1 : 0];
    [scanner scanHexInt:&rgbValue];

    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.f
                           green:((rgbValue & 0xFF00) >> 8) / 255.f
                            blue:(rgbValue & 0xFF) / 255.f
                           alpha:1.0];
}

@end

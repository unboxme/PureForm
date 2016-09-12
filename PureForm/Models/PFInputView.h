//
//  PFInputView.h
//  Example
//
//  Created by Puzyrev Pavel on 24.08.16.
//  Copyright © 2016 Puzyrev Pavel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PFValidator;

@interface PFInputView : NSObject

/**
 The real input view.
 */
@property(strong, nonatomic) UIView *view;

/**
 The current value.
 */
@property(strong, nonatomic) id value;

/**
 The key for creating an output dictionary.
 */
@property(strong, nonatomic) NSString *key;

/**
 The validators of the input view (`view`).
 */
@property(strong, nonatomic) NSArray<PFValidator *> *validators;

/**
 Indicates whether `view` is a form input view (use `?` to mark as an input view).
 */
@property(assign, nonatomic, getter=isFormView) BOOL formView;

///---------------
/// @name Specials
///---------------

@property(strong, nonatomic) NSString *propertyName;

@property(strong, nonatomic) NSString *displayPropertyName;

@property(strong, nonatomic) NSDictionary *params;

@end

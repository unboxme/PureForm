//
//  PFValidator.h
//  Example
//
//  Created by Puzyrev Pavel on 24.08.16.
//  Copyright © 2016 Puzyrev Pavel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PFEnums.h"

@interface PFValidator : NSObject

/**
 The validator type.
 */
@property(assign, nonatomic) PFValidatorType type;

/**
 It contains validation rule (ex. regex, maximum value, etc).
 */
@property(strong, nonatomic) id value;

///---------------
/// @name Specials
///---------------

@property(assign, nonatomic, getter=isForceValidation) BOOL forceValidation;

@end

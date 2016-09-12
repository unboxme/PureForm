//
//  StepperCell.h
//  Example
//
//  Created by Puzyrev Pavel on 20.08.16.
//  Copyright © 2016 Puzyrev Pavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StepperCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *displayLabel;
@property (weak, nonatomic) IBOutlet UIStepper *stepperControl;

@end

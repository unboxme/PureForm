//
//  MultiTextCell.h
//  Example
//
//  Created by Puzyrev Pavel on 18.08.16.
//  Copyright © 2016 Puzyrev Pavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultiTextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *dayTextField;
@property (weak, nonatomic) IBOutlet UITextField *monthTextField;
@property (weak, nonatomic) IBOutlet UITextField *yearTextField;

@end

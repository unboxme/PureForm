//
//  TextCell.h
//  Example
//
//  Created by Puzyrev Pavel on 14.08.16.
//  Copyright © 2016 Puzyrev Pavel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@end

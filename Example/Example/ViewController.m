//
//  ViewController.m
//  Example
//
//  Created by Puzyrev Pavel on 13.08.16.
//  Copyright © 2016 Puzyrev Pavel. All rights reserved.
//

#import "ViewController.h"

#import "PureForm.h"

@interface ViewController () <UITableViewDelegate, PFSegmentedControlDelegate, PFFormDelegate>

@property(strong, nonatomic) PFFormController *formController;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    PFSettings *settings = [[PFSettings alloc] init];
    settings.keyboardTypeValidation = YES;
    settings.formDelegate = self;
    settings.tableViewDelegate = self;

    self.formController = [[PFFormController alloc] initWithTableView:self.tableView settings:settings];
    [self.formController makeFormWithJSONFile:@"form"];
}

#pragma mark - PFFormDelegate

- (void)valueDidUpdate {
    NSLog(@"valueDidUpdate");
}

- (void)valueDidUpdateWithError:(PFError *)error {
    NSLog(@"valueDidUpdateWithError: - %@", error.reason);
}

- (void)validationDidEndSuccessfully {
    NSLog(@"validationDidEndSuccessfully");

    NSLog(@"%@", [self.formController allKeyValuePairs]);
    [self showAlertWithMessage:[NSString stringWithFormat:@"%@", [self.formController allKeyValuePairs]] error:NO];
}

- (void)validationDidFailWithErrors:(NSArray<PFError *> *)errors {
    NSLog(@"validationDidFailWithErrors: - \n%@", [PFError descriptionFromErrors:errors]);

    [self showAlertWithMessage:@"Some errors, check log." error:YES];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 3) {
        [self.formController validate];
    }
}

#pragma mark - Alerts

- (void)showAlertWithMessage:(NSString *)message error:(BOOL)isError {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:isError ? @"Error" : @"Yep"
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleCancel
                                                     handler:nil];
    [alertController addAction:okAction];

    [self presentViewController:alertController animated:YES completion:nil];
}

@end

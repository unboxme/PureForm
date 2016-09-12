//
// PFFormController.m
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

#import "PFFormController.h"

#import "PFJSONSerialization.h"
#import "PFSettings.h"
#import "PFTableViewDataSource.h"
#import "PFModel.h"
#import "PFConstants.h"
#import "PFInputView+Validation.h"
#import "PFError.h"
#import "PFValidator+FailureReason.h"
#import "PFConstants.h"
#import "UIView+PureForm.h"

@interface PFFormController ()

@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) PFSettings *settings;
@property(strong, nonatomic) NSArray<PFModel *> *models;
@property(strong, nonatomic) PFTableViewDataSource <UITableViewDataSource> *tableViewDataSource;

@end

@implementation PFFormController

- (instancetype)initWithTableView:(UITableView *)tableView settings:(PFSettings *)settings {
    self = [super init];

    if (self) {
        _tableView = tableView;
        _settings = settings;
    }

    return self;
}

- (void)makeFormWithJSONFile:(NSString *)fileName {
    self.models = [PFJSONSerialization modelsFromFile:fileName];

    self.tableViewDataSource = [[PFTableViewDataSource alloc] initWithModels:self.models
                                                                   tableView:self.tableView
                                                                    settings:self.settings];
    self.tableView.dataSource = self.tableViewDataSource;
    self.tableView.delegate = self.settings.tableViewDelegate;

    CGFloat rowHeight = self.settings.cellHeight;
    if (rowHeight > PFCellHeightDefault) {
        self.tableView.rowHeight = rowHeight;
        self.tableView.estimatedRowHeight = rowHeight;
    }
}

- (NSArray<PFInputView *> *)inputFormViews {
    NSMutableArray *inputFormViews = [[NSMutableArray alloc] init];

    NSPredicate *formPredicate = [NSPredicate predicateWithFormat:@"ANY inputViews.isFormView == YES"];

    for (PFModel *model in [self.models filteredArrayUsingPredicate:formPredicate]) {
        NSPredicate *inputViewPredicate = [NSPredicate predicateWithFormat:@"isFormView == YES"];
        NSArray<PFInputView *> *results = [model.inputViews filteredArrayUsingPredicate:inputViewPredicate];
        [inputFormViews addObjectsFromArray:results];
    }

    return inputFormViews;
}

- (BOOL)validate {
    BOOL isValid = YES;

    NSMutableArray *errors = [[NSMutableArray alloc] init];

    for (PFInputView *inputView in [self inputFormViews]) {
        NSArray *sectionModels = self.tableViewDataSource.dataSource[inputView.view.pf_section];
        PFValidator *validator = [inputView failedValidatorWithValue:inputView.value
                                                       sectionModels:sectionModels
                                                          modelIndex:inputView.view.pf_index
                                                               force:NO];

        if (validator) {
            NSString *reason = [validator failureReasonWithUserReasons:self.settings.failureReasons];
            PFError *error = [[PFError alloc] initWithView:inputView.view validator:validator reason:reason];
            [errors addObject:error];
        }

        if (isValid && validator) {
            isValid = NO;
        }
    }

    if (!isValid && self.settings.formDelegate &&
            [self.settings.formDelegate respondsToSelector:@selector(validationDidFailWithErrors:)]) {
        [self.settings.formDelegate validationDidFailWithErrors:[NSArray arrayWithArray:errors]];
    }

    return isValid;
}

- (NSArray *)allValues {
    NSMutableArray *values = [[NSMutableArray alloc] init];

    for (PFInputView *inputView in [self inputFormViews]) {
        if (inputView.value) {
            [values addObject:inputView.value];
        }
    }

    return values;
}

- (NSDictionary *)allKeyValuePairs {
    NSMutableDictionary *pairs = [[NSMutableDictionary alloc] init];

    NSUInteger emptyIndex = 0;
    for (PFInputView *inputView in [self inputFormViews]) {
        if (!inputView.value && !inputView.key) {
            continue;
        }

        NSString *key = inputView.key;
        NSString *value = inputView.value ?: @"";

        if (!inputView.key || [inputView.key isEqualToString:@""]) {
            key = [NSString stringWithFormat:@"%@_%tu", PFUnknownKey, emptyIndex];
            emptyIndex += 1;
        }

        pairs[key] = value;
    }

    return pairs;
}

- (PFModel *)modelByView:(__kindof UIView *)view {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ANY inputViews.view == %@", view];
    NSArray *results = [self.models filteredArrayUsingPredicate:predicate];

    return results.count > 0 ? results.firstObject : nil;
}

- (PFModel *)modelByIndexPath:(NSIndexPath *)indexPath {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
            @"ANY inputViews.view.pf_index == %ld AND sectionIndex == %ld", indexPath.row, indexPath.section];
    NSArray *results = [self.models filteredArrayUsingPredicate:predicate];

    return results.count > 0 ? results.firstObject : nil;
}

- (PFInputView *)inputViewByView:(__kindof UIView *)view {
    PFModel *model = [self modelByView:view];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"view == %@", view];
    NSArray *results = [model.inputViews filteredArrayUsingPredicate:predicate];

    return results.count > 0 ? results.firstObject : nil;
}

- (PFInputView *)inputViewByIndexPath:(NSIndexPath *)indexPath {
    return [self inputViewByIndexPath:indexPath tag:0];
}

- (PFInputView *)inputViewByIndexPath:(NSIndexPath *)indexPath tag:(NSUInteger)tag {
    PFModel *model = [self modelByIndexPath:indexPath];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
            @"view.pf_index == %ld AND view.pf_section == %ld AND view.pf_tag == %ld AND formView == YES",
                    indexPath.row, indexPath.section, tag];
    NSArray *results = [model.inputViews filteredArrayUsingPredicate:predicate];

    return results.count > 0 ? results.firstObject : nil;
}

@end

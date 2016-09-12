//
// PFTableViewDataSource.m
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

#import "PFTableViewDataSource.h"

#import "PFModel.h"
#import "PFMacros.h"
#import "UITableViewCell+PureForm.h"
#import "PFInputViewDelegate.h"
#import "PFSettings.h"
#import "UIView+PureForm.h"
#import "PFConstants.h"
#import "PFInputView.h"

@interface PFTableViewDataSource ()

@property(strong, nonatomic, readwrite) NSMutableArray<NSMutableArray<PFModel *> *> *dataSource;
@property(strong, nonatomic) PFInputViewDelegate *inputViewDelegate;
@property(strong, nonatomic) PFSettings *settings;
@property(strong, nonatomic) UITableView *tableView;

@end

@implementation PFTableViewDataSource

- (instancetype)initWithModels:(NSArray<PFModel *> *)models tableView:(UITableView *)tableView settings:(PFSettings *)settings {
    self = [super init];

    if (self) {
        NSMutableArray *sections = [[NSMutableArray alloc] init];
        for (PFModel *model in models) {
            NSNumber *sectionIndex = @(model.sectionIndex);
            if (![sections containsObject:sectionIndex]) {
                [sections addObject:sectionIndex];
            }
        }

        // Safe for random selection of sections
        NSMutableArray *dataSource = [[NSMutableArray alloc] initWithCapacity:sections.count];
        for (NSUInteger i = 0; i < sections.count; i++) {
            [dataSource addObject:@0];
        }

        for (NSNumber *sectionIndex in sections) {
            NSPredicate *sectionPredicate = [NSPredicate predicateWithFormat:@"sectionIndex == %@", sectionIndex];
            NSArray *results = [models filteredArrayUsingPredicate:sectionPredicate];
            dataSource[[sectionIndex unsignedIntegerValue]] = results;
        }

        _settings = settings;
        _dataSource = dataSource;
        _tableView = tableView;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(changeDisplayLabel:)
                                                     name:PFDisplayLabelShouldChangeNotification
                                                   object:nil];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)changeDisplayLabel:(NSNotification *)notification {
    PFInputView *inputView = notification.object;

    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:inputView.view.pf_index inSection:inputView.view.pf_section];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell setValue:inputView.value forPropertyName:inputView.propertyName];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource[(NSUInteger) section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFModel *model = self.dataSource[(NSUInteger) indexPath.section][(NSUInteger) indexPath.row];

    Class CellClass = NSClassFromString(model.cellClassName);

    __kindof UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellIdentifier];
    if (!cell) {
        cell = (__kindof UITableViewCell *) [[CellClass alloc] init];
    }

    NSUInteger tag = 0;
    for (PFInputView *inputView in model.inputViews) {
        if (inputView.isFormView) {
            __kindof UIView *view = [cell valueForKey:inputView.propertyName];

            view.pf_index = (NSUInteger) indexPath.row;
            view.pf_section = (NSUInteger) indexPath.section;
            view.pf_tag = tag;
            view.pf_display = inputView.displayPropertyName ? [cell valueForKey:inputView.displayPropertyName] : nil;

            inputView.view = view;

            tag += 1;

            [self assignDelegateToView:view];
        }

        for (NSString *paramKey in inputView.params.allKeys) {
            NSString *param = inputView.params[paramKey];

            @try {
                [cell setValue:param forKeyPath:[NSString stringWithFormat:@"%@.%@", inputView.propertyName, paramKey]];
            }
            @catch (NSException *exception) {
                @throw exception;
                UIView *view = inputView.view;
                PFLog(@"Unable to set '%@' to '%@' (row: %tu, section: %tu, tag: %tu)",
                        paramKey, inputView.propertyName, view.pf_index, view.pf_section, view.pf_tag);
            }
        }

        if (inputView.value) {
            [cell setValue:inputView.value forPropertyName:inputView.propertyName];
        }
    }

    return cell;
}

#pragma mark - Delegates

- (void)assignDelegateToView:(id)view {
    if (!self.inputViewDelegate) {
        self.inputViewDelegate = [[PFInputViewDelegate alloc] init];
        self.inputViewDelegate.settings = self.settings;
        self.inputViewDelegate.models = self.dataSource;
    }

    if ([view respondsToSelector:@selector(delegate)]) {
        id <PFDelegate> dView = view;
        dView.delegate = self.inputViewDelegate;
    } else {
        if ([view isKindOfClass:[UISlider class]]) {
            SEL action = @selector(sliderControlDidEndEditing:);
            [view addTarget:self.inputViewDelegate action:action forControlEvents:UIControlEventTouchUpInside];
        }

        SEL action = @selector(controlViewDidChangeValue:);
        [view addTarget:self.inputViewDelegate action:action forControlEvents:UIControlEventValueChanged];
    }
}

#pragma clang diagnostic pop

@end

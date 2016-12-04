//
// PFInputViewDelegate.m
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

#import "PFInputViewDelegate.h"

#import <objc/runtime.h>
#import "PFModel.h"
#import "UIView+PureForm.h"
#import "PFSettings.h"
#import "PFInputView+Validation.h"
#import "PFValidator+FailureReason.h"
#import "PFConstants.h"
#import "UISlider+PureForm.h"

#define PFFormDelegate self.settings.formDelegate
#define PFTextFieldDelegate self.settings.textFieldDelegate
#define PFSegmentedControlDelegate self.settings.segmentedControlDelegate
#define PFSwitchControlDelegate self.settings.switchControlDelegate
#define PFSliderControlDelegate self.settings.sliderControlDelegate
#define PFStepperControlDelegate self.settings.stepperControlDelegate

static void *PFCurrentInputViewPropertyKey = &PFCurrentInputViewPropertyKey;
static void *PFOriginalInputViewPropertyKey = &PFOriginalInputViewPropertyKey;

@interface PFInputViewDelegate ()

@property(weak, nonatomic) PFSettings *settings;
@property(weak, nonatomic) NSMutableArray<NSMutableArray<PFModel *> *> *models;

@property(strong, nonatomic) PFInputView *currentInputView;
@property(strong, nonatomic) id originalValue;
@property(strong, nonatomic) UITableView *tableView;
@property(strong, nonatomic) NSValue *showedKeyboardFrame;

@end

@implementation PFInputViewDelegate

- (PFInputView *)currentInputView {
    return objc_getAssociatedObject(self, PFCurrentInputViewPropertyKey);
}

- (void)setCurrentInputView:(PFInputView *)currentInputView {
    objc_setAssociatedObject(self, PFCurrentInputViewPropertyKey, currentInputView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)originalValue {
    return objc_getAssociatedObject(self, PFOriginalInputViewPropertyKey);
}

- (void)setOriginalValue:(id)originalValue {
    objc_setAssociatedObject(self, PFOriginalInputViewPropertyKey, originalValue, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (instancetype)initWithModels:(NSMutableArray<NSMutableArray<PFModel *> *> *)models tableView:(UITableView *)tableView settings:(PFSettings *)settings {
    self = [super init];

    if (self) {
        _tableView = tableView;
        _settings = settings;
        _models = models;

        if (settings.isKeyboardAvoiding) {
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillShow:)
                                                         name:UIKeyboardWillShowNotification
                                                       object:nil];
            [[NSNotificationCenter defaultCenter] addObserver:self
                                                     selector:@selector(keyboardWillHide:)
                                                         name:UIKeyboardWillHideNotification
                                                       object:nil];
        }
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)searchAndAssignCurrentInputViewByView:(UIView *)view {
    self.currentInputView = nil;

    for (NSArray<PFModel *> *array in self.models) {
        NSPredicate *modelPredicate = [NSPredicate predicateWithFormat:@"ANY inputViews.view == %@", view];
        NSArray *results = [array filteredArrayUsingPredicate:modelPredicate];

        if (results.count > 0) {
            PFModel *model = results.firstObject;
            NSPredicate *inputViewPredicate = [NSPredicate predicateWithFormat:@"view == %@", view];

            self.currentInputView = [model.inputViews filteredArrayUsingPredicate:inputViewPredicate].firstObject;
            self.originalValue = self.currentInputView.value;
        }
    }
}

#pragma mark - PFSegmentedControlDelegate, PFSwitchControlDelegate, PFSliderControlDelegate, PFStepperControlDelegate

- (void)sliderControlDidEndEditing:(id)controlView {
    UISlider *sliderControl = controlView;
    [self makeValidationWithSectionModels:nil modelIndex:0];

    if (PFSliderControlDelegate &&
            [PFSliderControlDelegate respondsToSelector:@selector(sliderControl:didChangeValue:)]) {
        [PFSliderControlDelegate sliderControl:sliderControl didChangeValue:sliderControl.value];
    }
}

- (void)controlViewDidChangeValue:(id)controlView {
    [self searchAndAssignCurrentInputViewByView:controlView];

    if ([controlView isKindOfClass:[UISegmentedControl class]]) {
        UISegmentedControl *segmentedControl = controlView;
        self.currentInputView.value = @(segmentedControl.selectedSegmentIndex);
        [self makeValidationWithSectionModels:nil modelIndex:0];

        if (PFSegmentedControlDelegate &&
                [PFSegmentedControlDelegate respondsToSelector:@selector(segmentedControl:didSelectItemAtIndex:)]) {
            [PFSegmentedControlDelegate segmentedControl:segmentedControl
                                    didSelectItemAtIndex:segmentedControl.selectedSegmentIndex];
        }
    }

    if ([controlView isKindOfClass:[UISwitch class]]) {
        UISwitch *switchControl = controlView;
        self.currentInputView.value = @(switchControl.isOn);
        [self makeValidationWithSectionModels:nil modelIndex:0];

        if (PFSwitchControlDelegate &&
                [PFSwitchControlDelegate respondsToSelector:@selector(switchControl:didChangeState:)]) {
            [PFSwitchControlDelegate switchControl:switchControl didChangeState:switchControl.isOn];
        }
    }

    if ([controlView isKindOfClass:[UIStepper class]]) {
        UIStepper *stepperControl = controlView;
        self.currentInputView.value = @(stepperControl.value);
        [self makeValidationWithSectionModels:nil modelIndex:0];

        [[NSNotificationCenter defaultCenter] postNotificationName:PFDisplayLabelShouldChangeNotification
                                                            object:self.currentInputView];

        if (PFStepperControlDelegate &&
                [PFStepperControlDelegate respondsToSelector:@selector(stepperControl:didChangeValue:)]) {
            [PFStepperControlDelegate stepperControl:stepperControl didChangeValue:(CGFloat) stepperControl.value];
        }
    }

    if ([controlView isKindOfClass:[UISlider class]]) {
        UISlider *sliderControl = controlView;
        CGFloat step = sliderControl.pf_stepValue;
        self.currentInputView.value = @(round(sliderControl.value / step) * step);

        [[NSNotificationCenter defaultCenter] postNotificationName:PFDisplayLabelShouldChangeNotification
                                                            object:self.currentInputView];
    }
}

#pragma mark - PFFormDelegate Methods Calls

- (void)callValueDidUpdate {
    BOOL isDifferent = ![self.currentInputView.value isEqual:self.originalValue];
    if (!self.currentInputView.value && !self.originalValue) {
        isDifferent = NO;
    }

    if ([self.currentInputView.view isKindOfClass:[UISlider class]]) {
        isDifferent = YES;
    }

    if (PFFormDelegate && [PFFormDelegate respondsToSelector:@selector(valueDidUpdate)] && isDifferent) {
        [PFFormDelegate valueDidUpdate];
    }

    if (PFFormDelegate && [PFFormDelegate respondsToSelector:@selector(valueDidUpdateWithInputView:)] && isDifferent) {
        [PFFormDelegate valueDidUpdateWithInputView:self.currentInputView];
    }
}

- (void)callValueUpdateDidFailWithFailedValidator:(PFValidator *)validator {
    if (!PFFormDelegate) {
        return;
    }

    NSString *reason = [validator failureReasonWithUserReasons:self.settings.failureReasons];

    if ([PFFormDelegate respondsToSelector:@selector(valueDidUpdateWithError:)]) {
        PFError *error = [[PFError alloc] initWithView:self.currentInputView.view validator:validator reason:reason];
        [PFFormDelegate valueDidUpdateWithError:error];
    }
}

#pragma mark - Validation

- (void)makeValidationWithSectionModels:(NSArray<PFModel *> *)models modelIndex:(NSUInteger)index {
    PFValidator *failedValidator = [self.currentInputView failedValidatorWithValue:self.currentInputView.value
                                                                     sectionModels:models
                                                                        modelIndex:index
                                                                             force:YES];
    if (failedValidator) {
        [self callValueUpdateDidFailWithFailedValidator:failedValidator];
        return;
    } else {
        [self callValueDidUpdate];
    }
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (PFTextFieldDelegate && [PFTextFieldDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
        return [PFTextFieldDelegate textFieldShouldBeginEditing:textField];
    }

    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self searchAndAssignCurrentInputViewByView:textField];

    if (PFTextFieldDelegate && [PFTextFieldDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [PFTextFieldDelegate textFieldDidBeginEditing:textField];
    }
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (PFTextFieldDelegate && [PFTextFieldDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
        return [PFTextFieldDelegate textFieldShouldEndEditing:textField];
    }

    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [textField resignFirstResponder];

    if (PFTextFieldDelegate && [PFTextFieldDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [PFTextFieldDelegate textFieldDidEndEditing:textField];
    }

    self.currentInputView.value = [textField.text isEqualToString:@""] ? nil : textField.text;

    NSArray *models;
    NSUInteger index = 0;
    for (NSArray<PFModel *> *array in self.models) {
        NSPredicate *modelPredicate = [NSPredicate predicateWithFormat:@"ANY inputViews == %@", self.currentInputView];
        NSArray *results = [array filteredArrayUsingPredicate:modelPredicate];
        if (results.count > 0) {
            models = array;
            index = [array indexOfObject:results.firstObject];
        }
    }

    [self makeValidationWithSectionModels:models modelIndex:index];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *fullString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    NSString *characterSetString;

    switch (textField.keyboardType) {
        case UIKeyboardTypePhonePad: {
            characterSetString = PFPhonePadCharacters;
            break;
        }
        case UIKeyboardTypeNumberPad: {
            characterSetString = PFNumberPadCharacters;
            break;
        }
        case UIKeyboardTypeDecimalPad: {
            characterSetString = PFDecimalPadCharacters;
            break;
        }
        default:
            break;
    }

    if (fullString.length > 0 && characterSetString && self.settings.isKeyboardTypeValidation) {
        NSCharacterSet *numberPadCharacters = [NSCharacterSet characterSetWithCharactersInString:characterSetString];
        if ([fullString rangeOfCharacterFromSet:[numberPadCharacters invertedSet]].location != NSNotFound) {
            string = nil;
        }
    }

    if (PFTextFieldDelegate && [PFTextFieldDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [PFTextFieldDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }

    return string != nil;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if (PFTextFieldDelegate && [PFTextFieldDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [PFTextFieldDelegate textFieldShouldClear:textField];
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];

    if (PFTextFieldDelegate && [PFTextFieldDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
        return [PFTextFieldDelegate textFieldShouldReturn:textField];
    }

    return YES;
}

#pragma mark - Keyboard Avoiding

- (void)keyboardWillHide:(NSNotification *)notification {

    CGRect viewFrame = self.tableView.frame;
    viewFrame.size.height += self.showedKeyboardFrame.CGRectValue.size.height;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.tableView setFrame:viewFrame];
    [UIView commitAnimations];

    self.showedKeyboardFrame = nil;
}

- (void)keyboardWillShow:(NSNotification *)notification {
   if (self.showedKeyboardFrame) {
        return;
    }

    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGRect viewFrame = self.tableView.frame;
    viewFrame.size.height -= keyboardFrame.size.height;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [self.tableView setFrame:viewFrame];
    [UIView commitAnimations];

    self.showedKeyboardFrame = [NSValue valueWithCGRect:keyboardFrame];
}

@end

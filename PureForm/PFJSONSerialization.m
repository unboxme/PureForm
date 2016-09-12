//
// PFJSONSerialization.m
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

#import "PFJSONSerialization.h"
#import "NSString+PureForm.h"
#import "PFModel.h"
#import "PFConstants.h"
#import "PFMacros.h"
#import "PFInputView.h"
#import "PFValidator.h"

@implementation PFJSONSerialization

+ (NSArray *)modelsFromFile:(NSString *)fileName {
    NSError *error;

    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSString *string = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:&error];

    if (error) {
        PFLog(@"%@", error.localizedDescription);
        return nil;
    }

    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *elements = [PFJSONSerialization PFModelWithData:data error:&error];

    if (error) {
        PFLog(@"%@", error.localizedDescription);
        return nil;
    }

    return elements;
}

+ (NSArray *)PFModelWithData:(NSData *)data error:(NSError **)error {
    NSArray<NSDictionary *> *elements = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];
    NSMutableArray<PFModel *> *models = [[NSMutableArray alloc] initWithCapacity:elements.count];

    NSUInteger sectionIndex = 0;

    for (NSDictionary *element in elements) {
        if (element.allKeys.count == 1 && [element.allKeys.firstObject isEqualToString:PFSectionKey]) {
            sectionIndex = [element.allValues.firstObject unsignedIntegerValue];
            continue;
        }

        PFModel *model = [[PFModel alloc] init];
        model.sectionIndex = sectionIndex;

        NSArray *level1Keys = element.allKeys;

        BOOL userDataIsMultiple = level1Keys.count > 2;
        NSMutableArray *userData = userDataIsMultiple ? [[NSMutableArray alloc] initWithCapacity:level1Keys.count - 1] : nil;

        NSDictionary *inputViewsDictionary;
        for (NSString *level1key in level1Keys) {
            if ([level1key pf_isCombinedKey]) {

                NSString *cellClassName = [level1key pf_cellClassName];
                NSString *cellIdentifier = [level1key pf_cellIdentifier];

                PFModel *previousModel = models.lastObject;

                model.cellClassName =
                        [cellClassName isEqualToString:PFSpecialCharSame] ? previousModel.cellClassName : cellClassName;
                model.cellIdentifier =
                        [cellIdentifier isEqualToString:PFSpecialCharSame] ? previousModel.cellIdentifier : cellIdentifier;

                inputViewsDictionary = element[level1key];

                continue;
            }

            [userData addObject:element[level1key]];
        }

        // Hm...
        NSArray *level2Keys = inputViewsDictionary.allKeys;
        NSMutableArray *inputViews = [[NSMutableArray alloc] initWithCapacity:level2Keys.count];
        for (NSString *level2key in level2Keys) {
            PFInputView *inputView = [[PFInputView alloc] init];
            inputView.propertyName = [level2key pf_hasFormViewSuffix] ? [level2key pf_suffixFreeString] : level2key;
            inputView.formView = [level2key pf_hasFormViewSuffix];

            NSDictionary *inputViewOptions = inputViewsDictionary[level2key];
            NSMutableDictionary *inputViewParams = [[NSMutableDictionary alloc] init];

            for (NSString *level3Key in inputViewOptions.allKeys) {
                id value = inputViewOptions[level3Key];

                if ([level3Key pf_isSpecialKey]) {
                    if ([level3Key isEqualToString:PFValueKey]) {
                        inputView.value = value;
                    }
                    if ([level3Key isEqualToString:PFKeyKey]) {
                        inputView.key = value;
                    }
                    if ([level3Key isEqualToString:PFValidationKey]) {
                        NSDictionary *options = value;

                        NSArray *keys = options.allKeys;
                        NSMutableArray *validators = [[NSMutableArray alloc] initWithCapacity:keys.count];

                        for (NSString *key in keys) {
                            PFValidator *validator = [[PFValidator alloc] init];

                            validator.type = (PFValidatorType) [PFEnums enumFromValue:key];
                            validator.forceValidation = [key pf_hasSuffix];
                            validator.value = options[key];

                            [validators addObject:validator];
                        }

                        inputView.validators = [NSArray arrayWithArray:validators];
                    }
                    if ([level3Key isEqualToString:PFDisplayKey]) {
                        inputView.displayPropertyName = value;
                    }

                    continue;
                }

                NSString *saveKey = level3Key;

                if ([saveKey pf_hasLocalizedSuffix]) {
                    value = NSLocalizedString(value,);
                    saveKey = [saveKey pf_suffixFreeString];
                }

                inputViewParams[saveKey] = value;
            }

            inputView.params = [NSDictionary dictionaryWithDictionary:inputViewParams];

            [inputViews addObject:inputView];
        }

        model.inputViews = [NSArray arrayWithArray:inputViews];

        [models addObject:model];
    }

    return [NSArray arrayWithArray:models];
}

@end

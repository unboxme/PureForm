//
// PFFormController.h
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

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class PFSettings;
@class PFInputView;
@class PFModel;

NS_ASSUME_NONNULL_BEGIN

@interface PFFormController : NSObject

/**
 @param tableView The user form table view.
 @return An instance of PFFormController.
 */
- (instancetype)initWithTableView:(nonnull __kindof UITableView *)tableView settings:(nullable PFSettings *)settings;

/**
 @param fileName The file name with JSON data.
 */
- (void)makeFormWithJSONFile:(nullable NSString *)fileName;

///----------------------------------
/// @name Validation & getting values
///----------------------------------

/**
 @return `YES` if validation was successfully passed, otherwise `NO`.
 */
- (BOOL)validate;

/**
 @return The array of all form values at the moment.
 */
- (NSArray *)allValues;

/**
 Uses special keys such as <key>, <value>.
 @return The key-value pairs of all form values at the moment.
 */
- (NSDictionary *)allKeyValuePairs;

///-----------------------------
/// @name Getting views & models
///-----------------------------

/**
 @param view The view which will be using for search.
 @return The model which contains `view` in one of the `inputViews` array.
 */
- (nullable PFModel *)modelByView:(__kindof UIView *)view;

/**
 @param indexPath The index path which will be using for search.
 @return The model which uses for displaying cell by the index path.
 */
- (nullable PFModel *)modelByIndexPath:(NSIndexPath *)indexPath;

/**
 @param view The view which will be using for search.
 @return The PFInputView object associated with the view.
 */
- (nullable PFInputView *)inputViewByView:(__kindof UIView *)view;

/**
 Use it if the cell has only one input view.

 @param indexPath The index path which will be using for search.
 @return The PFInputView object associated with the indexPath.
 */
- (nullable PFInputView *)inputViewByIndexPath:(NSIndexPath *)indexPath;

/**
 Use it if the cell has more than one input view.

 @param indexPath The index path which will be using for search.
 @param tag The tag for exact search.
 @return The PFInputView object associated with the indexPath.
 */
- (nullable PFInputView *)inputViewByIndexPath:(NSIndexPath *)indexPath tag:(NSUInteger)tag;

@end

NS_ASSUME_NONNULL_END

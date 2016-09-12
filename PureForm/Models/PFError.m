//
// PFError.m
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

#import "PFError.h"
#import "PFModel.h"
#import "UIView+PureForm.h"

@implementation PFError

- (instancetype)initWithView:(UIView *)view validator:(PFValidator *)validator reason:(NSString *)reason {
    self = [super init];

    if (self) {
        _view = view;
        _validator = validator;
        _reason = reason;
    }

    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"View: (row: %tu, section: %tu, tag: %tu), reason: %@",
                    self.view.pf_index, self.view.pf_section, self.view.pf_tag, self.reason];
}

+ (NSArray<NSString *> *)descriptionFromErrors:(NSArray<PFError *> *)errors {
    NSMutableArray *descriptions = [[NSMutableArray alloc] initWithCapacity:errors.count];

    for (PFError *error in errors) {
        [descriptions addObject:error.description];
    }

    return [NSArray arrayWithArray:descriptions];
}

@end

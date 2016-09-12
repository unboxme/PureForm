//
// UIView+PureForm.m
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

#import "UIView+PureForm.h"
#import <objc/runtime.h>

static void *kIndexRuntimePropertyKey = &kIndexRuntimePropertyKey;
static void *kSectionRuntimePropertyKey = &kSectionRuntimePropertyKey;
static void *kTagRuntimePropertyKey = &kTagRuntimePropertyKey;
static void *kDisplayRuntimePropertyKey = &kDisplayRuntimePropertyKey;

@implementation UIView (PureForm)

- (NSUInteger)pf_section {
    return [objc_getAssociatedObject(self, kSectionRuntimePropertyKey) unsignedIntegerValue];
}

- (void)setPf_section:(NSUInteger)pf_section {
    objc_setAssociatedObject(self, kSectionRuntimePropertyKey, @(pf_section), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)pf_index {
    return [objc_getAssociatedObject(self, kIndexRuntimePropertyKey) unsignedIntegerValue];
}

- (void)setPf_index:(NSUInteger)pf_index {
    objc_setAssociatedObject(self, kIndexRuntimePropertyKey, @(pf_index), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSUInteger)pf_tag {
    return [objc_getAssociatedObject(self, kTagRuntimePropertyKey) unsignedIntegerValue];
}

- (void)setPf_tag:(NSUInteger)pf_tag {
    objc_setAssociatedObject(self, kTagRuntimePropertyKey, @(pf_tag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id <PFText>)pf_display {
    return objc_getAssociatedObject(self, kDisplayRuntimePropertyKey);
}

- (void)setPf_display:(id <PFText>)pf_display {
    objc_setAssociatedObject(self, kDisplayRuntimePropertyKey, pf_display, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end

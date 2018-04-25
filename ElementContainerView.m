/**
 * Copyright (c) 2003-2018, Carsten Blüm <carsten@bluem.net>
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 * - Redistributions of source code must retain the above copyright notice, this
 *   list of conditions and the following disclaimer.
 * - Redistributions in binary form must reproduce the above copyright notice, this
 *   list of conditions and the following disclaimer in the documentation and/or
 *   other materials provided with the distribution.
 * - Neither the name of Carsten Blüm nor the names of his contributors may be
 *   used to endorse or promote products derived from this software without specific
 *   prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "ElementContainerView.h"

@implementation ElementContainerView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    hasReturnValue = YES;
    isMandatory = NO;
    return self;
}

- (void)dealloc {
    if ([element retainCount] > 1) {
        [element release];
    }
    [super dealloc];
}

- (void)setElement:(id)newElement {
    [newElement retain];
    [element release];
    element = newElement;
}

- (id)element {
    return element;
}

- (NSString *)stringValue {
    return [element stringValue];
}

- (BOOL)hasReturnValue {
    return hasReturnValue;
}

- (CGFloat)elementVerticalCenterYPosition {
    NSRect elementRect = [element frame];
    return [self frame].origin.y +
           elementRect.origin.y +
           (elementRect.size.height / 2);
}

- (NSString *)debugDescription {
    return [NSString stringWithFormat:
            @"%@ [%@] > Element: %@ [%@] ",
            NSStringFromClass([self class]),
            NSStringFromRect([self frame]),
            NSStringFromClass([element class]),
            NSStringFromRect([element frame])
    ];
}

- (void)setMandatory:(BOOL)mandatory {
    isMandatory = mandatory;
}

- (BOOL)failsMandatoryCheck {
    if (!isMandatory) {
        return NO;
    }

    if (![self stringValue]) {
        return YES;
    }

    NSString *trimmedValue = [[self stringValue] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];

    return [trimmedValue isEqualToString:@""];
}

- (void)setHasReturnValue:(BOOL)flag {
    hasReturnValue = flag;
}

- (float)requiredWidth {
    return NSMaxX([self frame]) + UI_WINDOW_CONTENTPADDING;
}

- (float)requiredHeight {
    return NSMaxY([self frame]) + UI_ELEMENTS_VERTICAL_DISTANCE;
}

#if DEBUG_VERBOSE_RECTS
- (void)drawRect:(NSRect)aRect {
    float r = (rand() % 1000) + 1;
    float g = (rand() % 1000) + 1;
    float b = (rand() % 1000) + 1;
    r = r / 1000;
    g = g / 1000;
    b = b / 1000;
    NSColor *color = [NSColor colorWithCalibratedRed:r green:g blue:b alpha:1.0];
    [color set];
    [NSBezierPath setDefaultLineWidth:2];
    [NSBezierPath strokeRect:aRect];
    [super drawRect:aRect];
}
#endif

@end

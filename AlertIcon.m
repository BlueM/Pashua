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

#import "AlertIcon.h"

@implementation AlertIcon

+ (CGFloat)iconSize {
    return 14;
}

- (id)initWithX:(CGFloat)x andY:(CGFloat)y {
    CGFloat size = [AlertIcon iconSize];
    self = [super initWithFrame:NSMakeRect(x, y, size, size)];
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {

    CGFloat size = [AlertIcon iconSize];

    NSColor *color = [NSColor colorWithCalibratedRed: 0.659 green: 0 blue: 0 alpha: 0.784];

    NSBezierPath *ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(0, 0, size, size)];
    [color setFill];
    [ovalPath fill];

    NSBezierPath *bezierPath = [NSBezierPath bezierPath];

    // Arrow head
    [bezierPath moveToPoint: NSMakePoint(2, size * 0.5)];
    [bezierPath lineToPoint: NSMakePoint((7.8 / 12.0 * size), (10.0 / 12.0 * size))];
    [bezierPath lineToPoint: NSMakePoint((7.8 / 12.0 * size), (2.0 / 12.0 * size))];
    [bezierPath closePath];

    [[NSColor whiteColor] setFill];
    [bezierPath fill];
}

@end

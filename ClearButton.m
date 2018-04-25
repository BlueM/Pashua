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

#import "ClearButton.h"

@implementation ClearButton

- (id)initWithFrame:(NSRect)frameRect
           forField:(NSTextField *)theField{

    self = [super initWithFrame:frameRect];

    // Set button appearance
    pathField = theField;
    [pathField retain];

    [self setTarget:self];
    [self setAction:@selector(clearField)];
    [self setToolTip:WRD_CLEAR];

    if (![pathField stringValue]) {
        [self setHidden:YES];
    }

    return self;
}

- (void)clearField {
    [pathField setStringValue:@""];
    [self setHidden:YES];
}

- (void)drawRect:(NSRect)dirtyRect {
    NSColor *grayColor = [NSColor colorWithCalibratedRed: 0.667 green: 0.667 blue: 0.667 alpha: 1];

    NSBezierPath *ovalPath = [NSBezierPath bezierPathWithOvalInRect: NSMakeRect(1, 1, 14, 14)];
    [grayColor setFill];
    [ovalPath fill];

    NSBezierPath *rectanglePath = [NSBezierPath bezierPath];
    [rectanglePath moveToPoint: NSMakePoint(10.36, 4.07)];
    [rectanglePath lineToPoint: NSMakePoint(11.93, 5.64)];
    [rectanglePath lineToPoint: NSMakePoint(5.64, 11.93)];
    [rectanglePath lineToPoint: NSMakePoint(4.07, 10.36)];
    [rectanglePath lineToPoint: NSMakePoint(10.36, 4.07)];
    [rectanglePath closePath];
    [[NSColor whiteColor] setFill];
    [rectanglePath fill];

    NSBezierPath *rectangle2Path = [NSBezierPath bezierPath];
    [rectangle2Path moveToPoint: NSMakePoint(4.07, 5.64)];
    [rectangle2Path lineToPoint: NSMakePoint(5.64, 4.07)];
    [rectangle2Path lineToPoint: NSMakePoint(11.93, 10.36)];
    [rectangle2Path lineToPoint: NSMakePoint(10.36, 11.93)];
    [rectangle2Path lineToPoint: NSMakePoint(4.07, 5.64)];
    [rectangle2Path closePath];
    [[NSColor whiteColor] setFill];
    [rectangle2Path fill];
}

- (void) dealloc {
    [pathField release];
    [super dealloc];
}

- (BOOL)acceptsFirstResponder {
    return NO;
}

@end

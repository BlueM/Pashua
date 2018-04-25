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

#import "PshTextbox.h"

@implementation PshTextbox

+ (id)createWithAttributes:(NSDictionary *)attributes
                 xPosition:(int)x
                 yPosition:(int)y
         relativeXPosition:(int)relx
         relativeYPosition:(int)rely
                   xOffset:(float *)xOffset
                   yOffset:(float *)yOffset
                 forWindow:(id)window {

    unsigned int height = [[attributes objectForKey:@"height"] intValue];
    unsigned int width = UI_DEFAULT_WIDTH;
    id view, element, label;
    NSClipView *cv;
    NSTextView *tv;
    NSSize size;
    float fontSize;

    if ([[attributes objectForKey:@"width"] intValue]) {
        width = [[attributes objectForKey:@"width"] intValue];
    }

    if (height < 30) {
        height = 52;
    }

    if ([[attributes objectForKey:@"fontsize"] isEqualToString:@"small"]) {
        fontSize = [NSFont systemFontSizeForControlSize:NSSmallControlSize];
    } else if ([[attributes objectForKey:@"fontsize"] isEqualToString:@"mini"]) {
        fontSize = [NSFont systemFontSizeForControlSize:NSMiniControlSize];
    } else {
        fontSize = [NSFont systemFontSizeForControlSize:NSRegularControlSize];
    }

    // Get appropriate size for the container view
    size = [NSScrollView contentSizeForFrameSize:NSMakeSize(width, height)
                           hasHorizontalScroller:NO
                             hasVerticalScroller:YES
                                      borderType:NSBezelBorder];

    NSRect elementRect = NSMakeRect(0, 0, width, height);
    element = [[[NSScrollView alloc] initWithFrame:elementRect] autorelease];

    // Create the "helper" views
    NSRect contentRect = NSMakeRect(0, 0, size.width, size.height);
    cv = [[NSClipView alloc] initWithFrame:contentRect];
    tv = [[NSTextView alloc] initWithFrame:contentRect];

    // Set up the view hierarchy
    [cv setDocumentView:[tv autorelease]];
    [element setContentView:[cv autorelease]];

    // Set scroller
    [element setHasVerticalScroller:YES]; // Show vertical scroller ...
    if ([element respondsToSelector:@selector(setAutohidesScrollers:)]) {
        [element setAutohidesScrollers:YES]; // ... if needed ...
    }
    [[element verticalScroller] setControlSize:NSSmallControlSize]; // ... and make it small

    [element setBorderType:NSBezelBorder];

    if ([attributes objectForKey:@"default"]) {
        [tv setString:[[[attributes objectForKey:@"default"]
                componentsSeparatedByString:@"[return]"] componentsJoinedByString:@"\n"]];
    }

    [tv setRichText:NO];

    if ([attributes objectForKey:@"fonttype"] &&
        [[attributes objectForKey:@"fonttype"] isEqualToString:@"fixed"]) {
        // Monospaced font
        [tv setFont:[NSFont userFixedPitchFontOfSize:(int)(fontSize)]];
    } else {
        // Proportional font
        [tv setFont:[NSFont systemFontOfSize:fontSize]];
    }

    // Create label view, if needed
    if ([attributes objectForKey:@"label"]) {
        label = [ElementLabel labelWithString:[attributes objectForKey:@"label"]
                                       withFrame:NSMakeRect(0, height + UI_LABEL_VERTICAL_DISTANCE, 200, UI_TEXTFIELD_HEIGHT)];
        if (NSWidth([label frame]) > width) {
            width = NSWidth([label frame]);
        }
        height += NSHeight([label frame]) + UI_LABEL_VERTICAL_DISTANCE;
    } else {
        label = NULL;
    }

    if (x && y) {
        // Position at x/y coordinates
        view = [[ElementContainerView alloc] initWithFrame:NSMakeRect(x, y, width, height)];
    } else {
        // Automatic positioning
        view = [[ElementContainerView alloc] initWithFrame:NSMakeRect(UI_WINDOW_CONTENTPADDING + relx, *yOffset + rely, width, height)];
        *yOffset += NSHeight([view frame]) + UI_WINDOW_CONTENTPADDING + rely;
    }

    [view setElement:element];

    if ([attributes objectForKey:@"mandatory"]) {
        NSString *mandatoryConfig = [attributes objectForKey:@"mandatory"];
        [view setMandatory:[mandatoryConfig evaluatesToTrue]];
    }

    if ([attributes objectForKey:@"tooltip"]) {
        [element setToolTip:[attributes objectForKey:@"tooltip"]];
    }

    if ([attributes objectForKey:@"disabled"] &&
        1 == [[attributes objectForKey:@"disabled"] intValue]) {
        [tv setEditable:NO];
        [tv setSelectable:NO];
    }

    [view addSubview:element];

    if (label) {
        [view addSubview:label];
    }

    return [view autorelease];
}

@end

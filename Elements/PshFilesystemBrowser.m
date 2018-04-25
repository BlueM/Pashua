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

#import "PshFilesystemBrowser.h"

#define PADDING 3

@implementation PshFilesystemBrowser

+ (id)createWithAttributes:(NSDictionary *)attributes
                 xPosition:(int)x
                 yPosition:(int)y
         relativeXPosition:(int)relx
         relativeYPosition:(int)rely
                   xOffset:(float *)xOffset
                   yOffset:(float *)yOffset
                 forWindow:(id)window {

    unsigned int height = 0;
    unsigned int width = UI_DEFAULT_WIDTH;
    id view, element, label, chooseButton, clearButton;

    if ([[attributes objectForKey:@"width"] intValue]) {
        width = [[attributes objectForKey:@"width"] intValue];
    }

    chooseButton = [[[FSBrowserButton alloc] initWithFrame:NSMakeRect(0, 0, 200, UI_BUTTON_HEIGHT)] autorelease];
    [chooseButton setTitle:[NSString stringWithFormat:@" %@ ", WRD_CHOOSE_ELLIPS]];
    [chooseButton sizeToFit];

    // After having set the button to its final size, re-position it
    [chooseButton setFrameOrigin:NSMakePoint(
        (float)width - NSWidth([chooseButton frame]) + PADDING,
        NSMinY([chooseButton frame]) - UI_BUTTON_OVERSIZE)
     ];

    [chooseButton setTarget:chooseButton];
    [chooseButton setLabel:[attributes objectForKey:@"label"]];
    [chooseButton setAction:[self getSelector]];


    if ([attributes objectForKey:@"filetype"]) {
        [chooseButton setFiletypes:[attributes objectForKey:@"filetype"]];
    }

    NSRect fieldRect = NSMakeRect(
        0,
        0,
        (int)width - (int)NSWidth([chooseButton frame]) + PADDING,
        UI_TEXTFIELD_HEIGHT
    );
    element = [[[DragTextField alloc] initWithFrame:fieldRect
                                         withString:[attributes objectForKey:@"default"]
                                       forFiletypes:[attributes objectForKey:@"filetype"]
                                      isSaveBrowser:[self isSaveBrowser]] autorelease];

    height += UI_TEXTFIELD_HEIGHT;

    clearButton = [[[ClearButton alloc] initWithFrame:NSMakeRect(0, 0, UI_CLEARBUTTON_WIDTH, UI_CLEARBUTTON_WIDTH)
                                             forField:element] autorelease];
    [clearButton setFrameOrigin:NSMakePoint(
		(float)width - NSWidth([chooseButton frame]) - UI_CLEARBUTTON_WIDTH,
		((UI_BUTTON_HEIGHT - UI_CLEARBUTTON_WIDTH) / 2) - PADDING
	)];
    [element setClearButton:clearButton];

    [chooseButton setPathField:element];
    [chooseButton setClearButton:clearButton];

    // Create label view, if needed
    if ([attributes objectForKey:@"label"]) {
        NSRect labelRect = NSMakeRect(0, UI_TEXTFIELD_HEIGHT + UI_LABEL_VERTICAL_DISTANCE, 200, UI_TEXTFIELD_HEIGHT);
        label = [ElementLabel labelWithString:[attributes objectForKey:@"label"]
                                    withFrame:labelRect];
        if (NSWidth([label frame]) > width) {
            width = NSWidth([label frame]);
        }
        height += NSHeight([label frame]) + UI_LABEL_VERTICAL_DISTANCE;
    } else {
        label = NULL;
    }

    if (x && y) {
        // Position at x/y coordinates
        view = [[ElementContainerView alloc] initWithFrame:NSMakeRect(x, y, width, height + 1)];
    } else {
        // Automatic positioning
        view = [[ElementContainerView alloc] initWithFrame:NSMakeRect(
            UI_WINDOW_CONTENTPADDING + relx,
            *yOffset + rely,
            width,
            height + 1 // The +1 is needed for giving the focus ring enough room
        )];
        *yOffset += NSHeight([view frame]) + UI_WINDOW_CONTENTPADDING + rely;
    }

    [view setElement:element];

    if ([attributes objectForKey:@"mandatory"]) {
        NSString *mandatoryConfig = [attributes objectForKey:@"mandatory"];
        [view setMandatory:[mandatoryConfig evaluatesToTrue]];
    }

    if ([attributes objectForKey:@"placeholder"]) {
        [[element cell] setPlaceholderString:[attributes objectForKey:@"placeholder"]];
    }

    if ([attributes objectForKey:@"tooltip"]) {
        [chooseButton setToolTip:[attributes objectForKey:@"tooltip"]];
    }

    if ([attributes objectForKey:@"disabled"] &&
        1 == [[attributes objectForKey:@"disabled"] intValue]) {
        [element setEnabled:NO];
        [chooseButton setEnabled:NO];
    }

    [view addSubview:element];

    [view addSubview:chooseButton];

    [view addSubview:clearButton];

    if (label) {
        [view addSubview:label];
    }

    return [view autorelease];
}

+ (BOOL)isSaveBrowser {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

+ (SEL)getSelector {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must override %@ in a subclass", NSStringFromSelector(_cmd)]
                                 userInfo:nil];
}

@end

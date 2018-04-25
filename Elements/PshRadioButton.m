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

#import "PshRadioButton.h"

@implementation PshRadioButton

+ (id)createWithAttributes:(NSDictionary *)attributes
                 xPosition:(int)x
                 yPosition:(int)y
         relativeXPosition:(int)relx
         relativeYPosition:(int)rely
                   xOffset:(float *)xOffset
                   yOffset:(float *)yOffset
                 forWindow:(id)window {

    unsigned int height = 0;
    unsigned int width = 0;
    unsigned int i;
    id view, label;
    unsigned long optionsCount = [[attributes objectForKey:@"options"] count];

    // Raise an exception, if attribute "options" is not set
    if (!optionsCount) {
        [NSException raise:EXC_CONFIG
                    format:PHR_CFGLACKOPTNS, [attributes objectForKey:@"key"]];
    }

    // We need a prototype for the radio buttons inside the NSMatrix
    id prototype = [[NSButtonCell alloc] init];
    [prototype setButtonType:NSRadioButton];
    [prototype setTitle:@"Prototype"];

    NSMatrix *matrix = [
    	[[NSMatrix alloc]
			initWithFrame:NSMakeRect(0, 0, 500, UI_RADIOBUTTON_HEIGHT * optionsCount)
			mode:NSRadioModeMatrix
			prototype:prototype
			numberOfRows:optionsCount
			numberOfColumns:1
		]
		autorelease
	];

    [prototype release];

    [matrix setAllowsEmptySelection:YES];
    [matrix deselectAllCells];

    // Set titles of NSButtonCells inside the NSMatrix and optionally select the default item
    for (i = 0; i < optionsCount; i ++) {
        [[matrix cellAtRow:i column:0] setTitle:[[attributes objectForKey:@"options"] objectAtIndex:i]];
        if ([attributes objectForKey:@"default"] &&
            [[attributes objectForKey:@"default"] isEqualToString:[[attributes objectForKey:@"options"] objectAtIndex:i]]) {
            [matrix selectCellAtRow:i column:0];
        }
    }

    [matrix sizeToFit];

    width = NSWidth([matrix frame]);
    height = NSHeight([matrix frame]);

    // Create the label, if needed
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

    [view setElement:matrix];

    if ([attributes objectForKey:@"mandatory"]) {
        NSString *mandatoryConfig = [attributes objectForKey:@"mandatory"];
        [view setMandatory:[mandatoryConfig evaluatesToTrue]];
    }

    if ([attributes objectForKey:@"tooltip"]) {
        [matrix setToolTip:[attributes objectForKey:@"tooltip"]];
    }

    if ([attributes objectForKey:@"disabled"] &&
        1 == [[attributes objectForKey:@"disabled"] intValue]) {
        [matrix setEnabled:NO];
    }

    [view addSubview:matrix];

    if (label) {
        [view addSubview:label];
    }

    return [view autorelease];
}

@end

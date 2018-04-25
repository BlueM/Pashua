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

#import "PshComboBox.h"

@implementation PshComboBox

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
    id view, element, label;

    // Raise an exception, if attribute "options" is not set
    if (![[attributes objectForKey:@"options"] count]) {
        [NSException raise:EXC_CONFIG
                    format:PHR_CFGLACKOPTNS, [attributes objectForKey:@"key"]];
    }

    if ([[attributes objectForKey:@"width"] intValue]) {
        width = [[attributes objectForKey:@"width"] intValue];
    }

    NSRect elementRect = NSMakeRect(0, 0, width, HI_COMBO_HEIGHT);

    if (2 == [[attributes objectForKey:@"completion"] intValue]) {
        [NSComboBox setCellClass:[PshComboBoxCell class]];
    }

    element = [[[NSComboBox alloc] initWithFrame:elementRect] autorelease];
    height += HI_COMBO_HEIGHT;

    [element addItemsWithObjectValues:[attributes objectForKey:@"options"]];

    if ([attributes objectForKey:@"default"]) {
        [element setStringValue:[attributes objectForKey:@"default"]];
    }

    if (0 == [[attributes objectForKey:@"completion"] intValue]) {
        [element setCompletes:NO];
    } else {
        [element setCompletes:YES];
    }

    if (0 < [[attributes objectForKey:@"rows"] intValue]) {
        [element setNumberOfVisibleItems:[[attributes objectForKey:@"rows"] intValue]];
    }

    // Create label view
    if ([attributes objectForKey:@"label"]) {
        label = [ElementLabel labelWithString:[attributes objectForKey:@"label"]
                                       withFrame:NSMakeRect(0, HI_COMBO_HEIGHT + UI_LABEL_VERTICAL_DISTANCE, 200, UI_TEXTFIELD_HEIGHT)];
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

    if ([attributes objectForKey:@"placeholder"]) {
        [[element cell] setPlaceholderString:[attributes objectForKey:@"placeholder"]];
    }

    if ([attributes objectForKey:@"tooltip"]) {
        [element setToolTip:[attributes objectForKey:@"tooltip"]];
    }

    if ([attributes objectForKey:@"disabled"] &&
        1 == [[attributes objectForKey:@"disabled"] intValue]) {
        [element setEnabled:NO];
    }

    [view addSubview:element];

    if (label) {
        [view addSubview:label];
    }

    return [view autorelease];
}

@end

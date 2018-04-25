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

#import "ElementFactory.h"

@implementation ElementFactory

+ (id)createElementWithAttributes:(NSDictionary *)attributes
                         inWindow:(id)window
                          xOffset:(float *)xOffset
                          yOffset:(float *)yOffset {

    unsigned int x = [attributes objectForKey:@"x"] ? [[attributes objectForKey:@"x"] intValue] + UI_WINDOW_CONTENTPADDING : 0;
    unsigned int y = [attributes objectForKey:@"y"] ? [[attributes objectForKey:@"y"] intValue] + UI_WINDOW_CONTENTPADDING : 0;
    int relx = [[attributes objectForKey:@"relx"] intValue];
    int rely = [[attributes objectForKey:@"rely"] intValue];

    NSString *type = [attributes objectForKey:@"type"];

    // Raise an exception, if an absolute x XOR an absolute y position is set
    if ((x && !y) || (!x && y)) {
        [NSException raise:EXC_CONFIG format:PHR_CFGLACKXORY, [attributes objectForKey:@"key"]];
    }

    // Check for minimum "rely" value
    if (rely < (- UI_WINDOW_CONTENTPADDING)) {
        [NSException raise:EXC_CONFIG
                    format:PHR_CFGRELYTOOSMALL, [attributes objectForKey:@"key"]];
    }

    NSDictionary *elementClasses = @{
        @"-": [PshHorizontalLine class],
        @"button": [PshButton class],
        @"cancelbutton": [PshCancelButton class],
        @"checkbox": [PshCheckbox class],
        @"combobox": [PshComboBox class],
        @"date": [PshDate class],
        @"defaultbutton": [PshDefaultButton class],
        @"image": [PshImage class],
        @"openbrowser": [PshOpenBrowser class],
        @"password": [PshPasswordField class],
        @"popup": [PshPopup class],
        @"radiobutton": [PshRadioButton class],
        @"savebrowser": [PshSaveBrowser class],
        @"text": [PshText class],
        @"textbox": [PshTextbox class],
        @"textfield": [PshTextField class],
    };

    id class = [elementClasses objectForKey:type];

    if (class == nil) {
        if (type == nil) {
            // No type specified for this element
            [NSException raise:EXC_CONFIG format:PHR_CFGLACKTYPE, [attributes objectForKey:@"key"]];
        } else {
            // Invalid type specified for this element
            [NSException raise:EXC_CONFIG format:PHR_CFGINVLDTYPE, type, [attributes objectForKey:@"key"]];
        }
    }

    // Get the element -- which could be nil, e.g. for buttons
    // Reminder: the window in the next method call is needed to
    // manage a PshButtonContainer that behaves as a "singleton
    // per window", but not as a "global" singleton
    return [class createWithAttributes:attributes
                             xPosition:x
                             yPosition:y
                     relativeXPosition:relx
                     relativeYPosition:rely
                               xOffset:xOffset
                               yOffset:yOffset
                             forWindow:window];
}

@end

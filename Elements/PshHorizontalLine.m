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

#import "PshHorizontalLine.h"

@implementation PshHorizontalLine

+ (id)createWithAttributes:(NSDictionary *)attributes
                 xPosition:(int)x
                 yPosition:(int)y
         relativeXPosition:(int)relx
         relativeYPosition:(int)rely
                   xOffset:(float *)xOffset
                   yOffset:(float *)yOffset
                 forWindow:(id)window {

    id view, element;

    // Create the element. The width of 50 in the next line and the width of 100
    // in the view creation code further below are just dummy values -- the line
    // will automatically grow or shrink to fit the window width
    element = [[[PshHLine alloc] initWithFrame:NSMakeRect(0, 0, 50, 4)] autorelease];
    [element setBoxType:NSBoxSeparator];
    [element setTitlePosition:NSNoTitle];

    view = [[ElementContainerView alloc] initWithFrame:NSMakeRect(UI_WINDOW_CONTENTPADDING, *yOffset, 100, 4)];
    [view setHasReturnValue:NO];

    *yOffset += NSHeight([view frame]) + UI_WINDOW_CONTENTPADDING;

    [view addSubview:element];

    return [view autorelease];
}

@end

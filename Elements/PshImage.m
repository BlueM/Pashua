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

#import "PshImage.h"

@implementation PshImage

+ (id)createWithAttributes:(NSDictionary *)attributes
                 xPosition:(int)x
                 yPosition:(int)y
         relativeXPosition:(int)relx
         relativeYPosition:(int)rely
                   xOffset:(float *)xOffset
                   yOffset:(float *)yOffset
                 forWindow:(id)window {

    NSImage *img = [[[NSImage alloc] initByReferencingFile:[attributes objectForKey:@"path"]] autorelease];
    [img setSizeToPixelSize];
    unsigned int requiredImgWidth = [img size].width;
    unsigned int requiredImgHeight = [img size].height;
    CGFloat containerWidth, containerHeight;
    unsigned int framestyle;
    id view, element, label;

    if (![attributes objectForKey:@"path"]) {
        [NSException raise:EXC_CONFIG
                    format:PHR_CFGIMGNOPATH, [attributes objectForKey:@"key"]];
    }

    if ([img isValid]) {
        if ([[attributes objectForKey:@"border"] intValue]) {
            // Display border; increase width + height
            framestyle = NSImageFrameGrayBezel;
            requiredImgWidth += UI_IMG_BORDERPADDING;
            requiredImgHeight += UI_IMG_BORDERPADDING;
        } else {
            // Don't display border
            framestyle = NSImageFrameNone;
        }

        NSRect imgRect = [self calculateImageRectWithImageWidth:requiredImgWidth
                                                      andHeight:requiredImgHeight
                                                  forAttributes:attributes];
        element = [[[NSImageView alloc] initWithFrame:imgRect] autorelease];
        [element setImage:img];
        [element setImageFrameStyle:framestyle];

        if ([[attributes objectForKey:@"upscale"] boolValue]) {
            [element setImageScaling:NSImageScaleProportionallyUpOrDown];
        } else {
            [element setImageScaling:NSScaleProportionally];
        }
    } else {
        // Image is invalid. Instead, display a text field in bold type
        NSFont *font = [NSFont boldSystemFontOfSize:NSRegularControlSize];

        NSRect fieldRect = NSMakeRect(0, 0, 500, UI_TEXTFIELD_HEIGHT);
        element = [[[NSTextField alloc] initWithFrame:fieldRect] autorelease];
        [[element cell] setFont:font];
        [element setStringValue:PHR_IMGINVALID];
        [element setDrawsBackground:NO];
        [element setBordered:NO];
        [element sizeToFit];
        [element setSelectable:NO];
    }

    containerWidth = NSWidth([element frame]);
    containerHeight = NSHeight([element frame]);

    // Create label, if needed
    if ([attributes objectForKey:@"label"]) {
        label = [ElementLabel labelWithString:[attributes objectForKey:@"label"]
                                       withFrame:NSMakeRect(0, containerHeight + UI_LABEL_VERTICAL_DISTANCE, 200, UI_TEXTFIELD_HEIGHT)];
        if (NSWidth([label frame]) > containerWidth) {
            containerWidth = NSWidth([label frame]);
        }
        containerHeight += NSHeight([label frame]) + UI_LABEL_VERTICAL_DISTANCE;
    } else {
        label = NULL;
    }

    if (x && y) {
        // Position at x/y coordinates
        view = [[ElementContainerView alloc] initWithFrame:NSMakeRect(x, y, containerWidth, containerHeight)];
    } else {
        // Automatic positioning
        view = [[ElementContainerView alloc] initWithFrame:NSMakeRect(UI_WINDOW_CONTENTPADDING + relx, *yOffset + rely, containerWidth, containerHeight)];
        *yOffset += NSHeight([view frame]) + UI_WINDOW_CONTENTPADDING + rely;
    }

    [view setElement:element];
    [view setHasReturnValue:NO];

    if ([attributes objectForKey:@"tooltip"]) {
        [element setToolTip:[attributes objectForKey:@"tooltip"]];
    }

    [view addSubview:element];

    if (label) {
        [view addSubview:label];
    }

    return [view autorelease];
}

+ (NSRect)calculateImageRectWithImageWidth:(float)imageWidth
                                 andHeight:(float)imageHeight
                             forAttributes:(NSDictionary*)attributes {

    unsigned int width, height, maxWidth, maxHeight;
    float ratio = imageHeight / imageWidth;
    width = [[attributes objectForKey:@"width"] intValue];
    maxWidth = [[attributes objectForKey:@"maxwidth"] intValue];
    height = [[attributes objectForKey:@"height"] intValue];
    maxHeight = [[attributes objectForKey:@"maxheight"] intValue];

    if (width && maxWidth) {
        [NSException raise:EXC_CONFIG
                    format:@"You have specified both “width” and “maxwidth” for image “%@”. Please use only either of these properties.",
         [attributes objectForKey:@"key"]];
    }
    if (height && maxHeight) {
        [NSException raise:EXC_CONFIG
                    format:@"You have specified both “height” and “maxheight” for image “%@”. Please use only either of these properties.",
         [attributes objectForKey:@"key"]];
    }

    if (width || height) {
        if (width && !height) {
            height = width * ratio;
        } else if (height && !width) {
            width = height * ratio;
        }
        return NSMakeRect(0, 0, width, height);
    }

    // Set maxHeight and maxWidth according to configuration
    // values, taking the screen size into account
    float maxScreenWidth = NSWidth([[NSScreen mainScreen] visibleFrame]) - (UI_WINDOW_CONTENTPADDING * 2);
    if (maxWidth < 25 || maxWidth > maxScreenWidth) {
        maxWidth = maxScreenWidth;
    }

    float maxScreenHeight = NSHeight([[NSScreen mainScreen] visibleFrame])
    - (UI_WINDOW_CONTENTPADDING * 15); // This is only a guess -- we dont' have a clue how high the window will be.
    if (maxHeight < 25 || maxHeight > maxScreenHeight) {
        maxHeight = maxScreenHeight;
    }

    // Check whether image is too wide
    if (imageWidth > maxWidth) {
        imageHeight = imageHeight / ((float)imageWidth / maxWidth);
        imageWidth = maxWidth;
    }

    // Check whether image is too high
    if (imageHeight > maxHeight) {
        imageWidth = imageWidth / ((float)imageHeight / maxHeight);
        imageHeight = maxHeight;
    }

    return NSMakeRect(0, 0, imageWidth, imageHeight);
}

@end

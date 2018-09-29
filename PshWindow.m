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

#import "PshWindow.h"

@implementation PshWindow

+ (id)windowWithAttributes:(NSDictionary *)theAttributes
               andElements:(NSArray *)theElements
            resultEncoding:(NSStringEncoding)enc {

    PshWindow *window = [[PshWindow alloc] initWithAttributes:theAttributes
                                                  andElements:theElements
                                               resultEncoding:enc];
    [window makeKeyAndOrderFront:nil];
    return window;
}

- (NSStringEncoding)encoding {
    return encoding;
}

- (id)objects {
    return objects;
}

- (id)initWithAttributes:(NSDictionary *)theAttributes
             andElements:(NSArray *)theElements
          resultEncoding:(NSStringEncoding)enc {

    NSRect theRect = NSMakeRect(500, 400, 40, 40);
    unsigned int texturedStyleMask;

    encoding = enc;

    // Texturized / metal window
    if ([theAttributes objectForKey:@"appearance"] &&
        [[theAttributes objectForKey:@"appearance"] isEqualToString:@"metal"]) {
        texturedStyleMask = NSTexturedBackgroundWindowMask;
    } else {
        texturedStyleMask = 0;
    }

    if (!(self = [super initWithContentRect:theRect
                                styleMask:NSTitledWindowMask | NSClosableWindowMask |
                                          NSMiniaturizableWindowMask | texturedStyleMask
                                  backing:NSBackingStoreBuffered
                                    defer:NO])) {
        return nil;
    }

    objects = [[NSMutableDictionary alloc] initWithCapacity:[theElements count]];

    // Set the window level, taking attribute 'floating' into account
    if ([[theAttributes objectForKey:@"floating"] intValue]) {
        [self setLevel: NSStatusWindowLevel];
    } else {
        [self setLevel: NSNormalWindowLevel];
    }

    [self setTitle:[theAttributes objectForKey:@"title"] ? [theAttributes objectForKey:@"title"] : DEFAULT_TITLE];

    [self setAlphaValue:[theAttributes objectForKey:@"transparency"] ?
                        [[theAttributes objectForKey:@"transparency"] floatValue] : DEFAULT_ALPHA];

    // Add content view
    NSView *contentView = [[NSView alloc] initWithFrame:[self frame]];
    [self setContentView:contentView];
    [contentView release];

    NSString *appearance = [theAttributes objectForKey:@"appearance"];

    // Appearances
    if ([appearance isEqualToString:@"light"]) {
        // Light (default)
        self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameAqua];
    } else if ([appearance isEqualToString:@"dark"]) {
        // Dark
        self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    } else if ([appearance isEqualToString:@"light-vibrant"]) {
        //  Light-vibrant
        self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantLight];
    } else if ([appearance isEqualToString:@"dark-vibrant"]) {
        // Dark-vibrant
        self.appearance = [NSAppearance appearanceNamed:NSAppearanceNameVibrantDark];
    }
    
    // Vibrancy setup
    if ([appearance isEqualToString:@"light-vibrant"] ||
        [appearance isEqualToString:@"dark-vibrant"]) {
        NSVisualEffectView *vibrant=[[NSVisualEffectView alloc] initWithFrame:[self frame]];
        [vibrant setAutoresizingMask:NSViewWidthSizable|NSViewHeightSizable];
        [vibrant setBlendingMode: NSVisualEffectBlendingModeBehindWindow];
        [self setContentView:vibrant];
        [vibrant release];
        self.styleMask = self.styleMask | NSFullSizeContentViewWindowMask;
        
        if ([theAttributes objectForKey:@"transparency"]) {
            [NSException raise:EXC_CONFIG format:PHR_CFGVIBRANTCONFL];
        }
    }
    
    // With/Without titlebar
    if ([theAttributes objectForKey:@"titlebar"] &&
        [[theAttributes objectForKey:@"titlebar"] isEqualToString:@"0"]) {
        self.titlebarAppearsTransparent = TRUE;
    } else {
        self.titlebarAppearsTransparent = FALSE;
    }

    [self setupWindowWithElements:theElements];

    // Position the window
    if ([theAttributes objectForKey:@"autosavekey"] && ([theAttributes objectForKey:@"x"] || [theAttributes objectForKey:@"y"])) {
        [NSException raise:EXC_CONFIG format:PHR_CFGPOSATTRCONFL];
    }

    if ([theAttributes objectForKey:@"autosavekey"]) {
        [self setFrameAutosaveName:[theAttributes objectForKey:@"autosavekey"]];
    } else {
        [self center];
        if ([theAttributes objectForKey:@"x"]) {
            [self setFrameTopLeftPoint:NSMakePoint([[theAttributes objectForKey:@"x"] floatValue],
                                                   NSMaxY([self frame]))];
        }

        if ([theAttributes objectForKey:@"y"]) {
            float screenHeight = NSMaxY([[NSScreen mainScreen] frame]);
            [self setFrameOrigin:NSMakePoint(NSMinX([self frame]),
                                             screenHeight - [[theAttributes objectForKey:@"y"] floatValue]
                                             - NSHeight([self frame]))];
        }
    }

    [self setDelegate:self]; // For receiving the -windowWillClose: message

    // Save the "autoclosetime" setting
    autoCloseTime = [[theAttributes objectForKey:@"autoclosetime"] intValue];
    if (autoCloseTime) {
        [NSTimer scheduledTimerWithTimeInterval:autoCloseTime
                                         target:self
                                       selector:@selector(performClose:)
                                       userInfo:nil
                                        repeats:NO];
    }

    return self;
}

- (void)setupWindowWithElements:(NSArray *)theElements {
    int i;
    NSUInteger elementsCount = [theElements count];

    // Throw an exception if no elements are defined
    if (![theElements count]) {
        [NSException raise:EXC_CONFIG format:PHR_CFGNOELEMENTS];
    }

    // The most simple way to create the window is to add the buttons in the order in which they're defined,
    // and to add any other elements in reverse order. So first, we construct a temporary array holding all elements in that order
    NSMutableArray *elmnts = [[NSMutableArray alloc] initWithCapacity:elementsCount];
    for (i = 0; i < elementsCount; i ++) {
        NSString *type = [[theElements objectAtIndex:i] objectForKey:@"type"];
        if ([type isEqualToString:@"button"]) {
            [elmnts addObject:[theElements objectAtIndex:i]];
        } else {
            [elmnts insertObject:[theElements objectAtIndex:i] atIndex:0];
        }
    }

    // Set the horizontal and the vertical positioning offsets to their initial value
    xOffset = UI_WINDOW_CONTENTPADDING - 6;
    yOffset = UI_WINDOW_CONTENTPADDING + UI_BUTTON_HEIGHT + UI_WINDOW_CONTENTPADDING;

    [self setupDefaultButton];
    [self setupCancelButton];

    // Loop over elements, from last to first one. This is due to the fact that the Cocoa view
    // hierarchy starts in the *lower* left corner, but we want to get the elements from top down.
    for (i = 0; i < [elmnts count]; i++) {
        [self addElementWithAttributes:[elmnts objectAtIndex:i]];
    }

    [self finishCancelButton];
    [self finishDefaultButton];

    [elmnts release];
}

- (void)finishDefaultButton {
    // Resize and reposition the default button
    float width = [ButtonContainerView buttonWidthForTitle:[defaultButton title]];
    float contentWidth = NSWidth([[self contentView] frame]);

    if (xOffset + width > contentWidth) {
        // Button area is wider than content view >> enlarge content view
        [self setContentSize:NSMakeSize(
            xOffset + width + UI_WINDOW_CONTENTPADDING - UI_BUTTON_OVERSIZE,
            NSHeight([[self contentView] frame])
        )];
        [defaultButton setFrame:NSMakeRect(
            xOffset,
            UI_WINDOW_CONTENTPADDING - UI_BUTTON_OVERSIZE,
            width,
            UI_BUTTON_HEIGHT
        )];
    } else {
        // Content view is wider than button area >> move default button and
        // cancel button to the right side
        [defaultButton setFrame:NSMakeRect(
            contentWidth - UI_WINDOW_CONTENTPADDING - width + UI_BUTTON_OVERSIZE,
            UI_WINDOW_CONTENTPADDING - UI_BUTTON_OVERSIZE,
            width,
            UI_BUTTON_HEIGHT
        )];
        [cancelButton setFrameOrigin:NSMakePoint(
            NSMinX([defaultButton frame]) - NSWidth([cancelButton frame]),
            [defaultButton frame].origin.y
        )];
    }

    [[self contentView] setNeedsDisplay:YES];
}

- (void)finishCancelButton {
    if (nil == [cancelButton superview]) {
        // The cancel button is not in the window, nothing to do
        return;
    }
    float width = [ButtonContainerView buttonWidthForTitle:[cancelButton title]];
    [cancelButton setFrame:NSMakeRect(
        xOffset,
        UI_WINDOW_CONTENTPADDING - UI_BUTTON_OVERSIZE,
        width,
        UI_BUTTON_HEIGHT
    )];
    xOffset += width;
}

- (void)setupCancelButton {
    // Create cancel button -- we set it up, but initially don't display it
    cancelButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, 0, 120, UI_BUTTON_HEIGHT)];
    [cancelButton setButtonType:NSButtonTypeMomentaryLight];
    [cancelButton setBezelStyle:NSRoundedBezelStyle];
    [cancelButton setKeyEquivalent:@"\E"];
    [cancelButton setTitle:WRD_CANCEL];
    [cancelButton setAction:@selector(performClose:)];
    [cancelButton setTarget:self];
}

- (void)setupDefaultButton {
    defaultButton = [[NSButton alloc] initWithFrame:NSMakeRect(20, UI_WINDOW_CONTENTPADDING, 80, UI_BUTTON_HEIGHT)];
    [defaultButton setButtonType:NSButtonTypeMomentaryLight];
    [defaultButton setBezelStyle:NSRoundedBezelStyle];
    [defaultButton setKeyEquivalent:@"\r"];
    [defaultButton setTitle:WRD_OK];
    [defaultButton setAction:@selector(performSave:)];
    [[self contentView] addSubview:defaultButton];
    [defaultButton setTarget:self];
}

- (void)cleanup {
    // No more windows and Pashua shouldn't stay open >> terminate
    [self setDelegate:nil];
    [NSApp terminate:self];
}

- (void)addErrorIconNextToElement:(ElementContainerView *)view {
    NSRect viewRect = [view frame];

    AlertIcon *errorIcon = [[AlertIcon alloc] initWithX:(viewRect.origin.x + viewRect.size.width + 3)
                                                   andY:([view elementVerticalCenterYPosition] - [AlertIcon iconSize] / 2)];
    [[self contentView] addSubview:[errorIcon autorelease]];

    if ([[view element] acceptsFirstResponder]) {
        [self makeFirstResponder:[view element]];
    }
}

- (void)removeAllAlertIcons {
    NSView *subView;
    while ((subView = [[self contentView] findFirstSubviewOfType:@"AlertIcon"])) {
        [subView removeFromSuperview];
    }
}

- (void)performSave:(id)sender {

    NSEnumerator *enumerator = [objects keyEnumerator];
    id key;
    BOOL failures = NO;
    [self removeAllAlertIcons];

    while ((key = [enumerator nextObject])) {
        ElementContainerView *elementContainer = [objects objectForKey:key];
        if ([elementContainer failsMandatoryCheck]) {
            [self addErrorIconNextToElement:elementContainer];
            failures = YES;
        }
    }

    if (failures) {
        enumerator = [objects keyEnumerator];
        while ((key = [enumerator nextObject])) {
            ElementContainerView *elementContainer = [objects objectForKey:key];
            if (BUTTON_CLOSING_TAG == [[elementContainer element] tag]) {
                // Workaround for the issue described in <8B41E958-2714-42FB-958C-A891CEE88FE1@telfort.nl>
                // and <46D6724D-46BF-46BF-8560-C75A4C41C203@telfort.nl>
                // Summary: when a button (= custom closing button, i.e.: not default or cancel) is clicked, the
                // state is set, and this is retained if the window stays on the screen in case of “mandatory”
                // errors. Upon next click, the state switches from On to Off -- or the state is erroneously On,
                // even if another button is used to close the dialog
                [[elementContainer element] setState:0];
            }
        }
        return;
    }

    enumerator = [objects keyEnumerator];

    while ((key = [enumerator nextObject])) {

        ElementContainerView *elementContainer = [objects objectForKey:key];
        id value;

        if (![elementContainer hasReturnValue]) {
            continue;
        }

        if (nil == [elementContainer stringValue]) {
            value = @"";
        } else {
            value = [elementContainer stringValue];
        }

        if ([elementContainer failsMandatoryCheck]) {
            [self addErrorIconNextToElement:elementContainer];
        }

        printf("%s=%s\n", [key UTF8String], [value cStringUsingEncoding:encoding]);
    }

    // Add the cancelbutton
    if (cancelButtonkey) {
        printf("%s=0\n", [cancelButtonkey UTF8String]);
    }

    if (defaultButtonkey) {
        if ([sender isEqual:defaultButton]) {
            printf("%s=1\n", [defaultButtonkey UTF8String]);
        } else {
            printf("%s=0\n", [defaultButtonkey UTF8String]);
        }
    }

    [self setDelegate:nil]; // To prevent method -windowWillClose message will be called

    [self close];
    [self cleanup];
}

- (void)addElementWithAttributes:(NSDictionary *)attributes {

    ElementContainerView *view = [ElementFactory createElementWithAttributes:attributes
                                                                   inWindow:self
                                                                    xOffset:&xOffset
                                                                    yOffset:&yOffset];

    if (nil == view) {
        // Will be the case for buttons
        return;
    }

    [[self contentView] addSubview:view];

    // Increase window's content view width, if needed
    if ([view requiredWidth] > NSWidth([[self contentView] frame])) {
        [self setContentSize:NSMakeSize([view requiredWidth], NSHeight([[self contentView] frame]))];
    }

    // Increase window's content view height, if needed
    if ([view requiredHeight] > NSHeight([[self contentView] frame])) {
        [self setContentSize:NSMakeSize(NSWidth([[self contentView] frame]), [view requiredHeight])];
    }

    [objects setObject:view forKey:[attributes objectForKey:@"key"]];
}

- (void)dealloc {
    [defaultButton release];
    [cancelButton release];
    [objects release];
    [super dealloc];
}

#pragma mark - Delegate methods

- (void)windowWillClose:(NSNotification *)notification {

    // This method is called when
    //   - The cancel button (provided there is one) is clicked
    //   - The cancel button's key equivalent (Esc) is pressed
    //   - Cmd-W is pressed
    //   - The close button in the title bar is used
    // To work, the window must be set as its delegate

    if (nil != cancelButtonkey) {
        printf("%s=1\n", [cancelButtonkey UTF8String]);
    }

    [self cleanup];
}

@end

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

#import "DragTextField.h"

@implementation DragTextField

- (id)initWithFrame:(NSRect)r
         withString:value
       forFiletypes:(NSString *)theTypes
      isSaveBrowser:(BOOL)savebrowser {

    self = [super initWithFrame:r];

    [self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];

    [self setEditable:NO];

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: [[self cell] font], NSFontAttributeName, nil];
    NSSize ellipsisSize = [@"…" sizeWithAttributes:attributes];
    float ellipsisWidth    = ellipsisSize.width;
    float clearButtonWidth = UI_CLEARBUTTON_WIDTH + UI_SPACE;
    availableWidth = NSWidth(self.frame) - ellipsisWidth - clearButtonWidth;

    // Set textfield content
    filetypes = [[theTypes componentsSeparatedByString:@" "] retain];

    if (value) {
        self.stringValue = value;
    }

    isSaveBrowser = savebrowser ? YES : NO;
    allowsDrop = YES;

    return [self autorelease];
}

- (void) dealloc {
    [filetypes release];
    [super dealloc];
}

- (void)setClearButton:(ClearButton *)button {
    clearButton = button;
}

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender {
    if (!allowsDrop) {
        return NSDragOperationNone;
    }

    if (nil == [self draggedPath:sender]) {
        // Make sure this is a file we do accept
        return NSDragOperationNone;
    }

    return NSDragOperationLink;
}

- (NSString *)draggedPath:(id <NSDraggingInfo>)sender {

    NSPasteboard *draggingPasteBoard = [sender draggingPasteboard];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;

    // Make sure a filename can be extracted
    if (![draggingPasteBoard.types containsObject:@"NSFilenamesPboardType"]) {
        return nil;
    }

    // Make sure only 1 file is dropped
    if ([[draggingPasteBoard propertyListForType:NSFilenamesPboardType] count] > 1) {
        return nil;
    }

    // Get the dragged file
    NSString *filepath = [[draggingPasteBoard propertyListForType:NSFilenamesPboardType] objectAtIndex:0];

    // Make sure the file exists and get its type
    if (![fm fileExistsAtPath:filepath isDirectory:&isDir]) {
        return nil;
    }

    // If this is a directory, check if it can be used
    if (isDir) {
        if (isSaveBrowser) {
            // No directories for savebrowser
            return nil;
        }
        if (![filetypes count] && [filetypes containsObject:@"directory"]) {
            return nil; // Directory is not in the list of allowed types
        } else {
            return filepath;
        }
    }

    if (![filetypes count]) {
        // No filetypes required at all >> accept & return dragged path
        return filepath;
    }

    // Filetype check
    if ([[filepath pathExtension] isEqualToString:@""]) {
        // No extension >> Return
        return nil;
    }

    if (![filetypes containsObject:[filepath pathExtension]]) {
        // Filetype not in the list of accepted types
        return nil;
    }

    return filepath;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender {

    NSString *filepath = [self draggedPath:sender];

    // Make sure this is a file we do accept
    if (nil == filepath) {
        return NSDragOperationNone;
    }

    // Set field content
    [self setStringValue:filepath];

    [clearButton setHidden:NO];

    // Otherwise: OK
    return YES;
}

- (NSString *)stringValue {
    return [self toolTip];
}

- (void)setEnabled:(BOOL)flag {
    allowsDrop = flag;
    [super setEnabled:flag];
}

- (void)setStringValue:(NSString *)aString {

    unsigned int offset = 0;

    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys: [[self cell] font], NSFontAttributeName, nil];

    [self setToolTip:aString];

    while([[aString substringFromIndex:offset] sizeWithAttributes:attributes].width > availableWidth) {
        offset ++;
    }

    if (offset) {
        // Use shortened string
        [super setStringValue:[NSString stringWithFormat:@"…%@", [aString substringFromIndex:offset]]];
    } else {
        // Use unmodified string
        [super setStringValue:aString];
    }
}

@end

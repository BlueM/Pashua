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

#import "FSBrowserButton.h"

@implementation FSBrowserButton

- (id)initWithFrame:(NSRect)frameRect {

    self = [super initWithFrame:frameRect];

    // Default behaviour: may choose anything
    chooseDirectory = YES;
    chooseFiles = YES;

    // Set button appearance
    [self setButtonType:NSMomentaryPushButton];
    [self setBezelStyle:NSRoundedBezelStyle];

    // Init array of allowed filetypes
    filetypes = [[NSMutableArray alloc] initWithCapacity: 6];

    return self;
}

- (void) dealloc {
    [filetypes release];
    [super dealloc];
}

- (void)setPathField:(NSTextField *)textfield {
    pathField = textfield;
}

- (void)setClearButton:(ClearButton *)clearButtonRef {
    clearButton = clearButtonRef;
}

- (void)setLabel:(NSString *) theLabel {
    if (theLabel) {
        label = theLabel;
    } else {
        label = @"";
    }
}

- (void)setFiletypes:(NSString *) theTypes {

    // When this method is called, overwrite the initial
    // "allow anything" policy that's set upon initialization
    chooseDirectory = NO;
    chooseFiles     = NO;

    // Parse list of types
    NSArray *items = [NSArray arrayWithArray:[theTypes componentsSeparatedByString:@" "]];
    unsigned int i;

    for (i = 0; i < [items count]; i ++) {

        NSString *type = [NSString stringWithString:[items objectAtIndex:i]];

        if ([type isEqualToString:@"directory"]) {
            chooseDirectory = YES;
        } else if (![type isEqualToString:@""]) {
            [filetypes addObject:type];
        }
    }

    chooseFiles = [filetypes count] ? YES : NO;
}

- (void)chooseFSItem:(id)sender {

    NSString *defaultPath = nil;
    id panel = [NSOpenPanel openPanel];
    [panel setCanChooseDirectories:chooseDirectory ? YES : NO];
    [panel setCanChooseFiles:chooseFiles ? YES : NO];
    [panel setAllowsMultipleSelection:NO];
    [panel setTitle:label];

    if ([pathField stringValue]) {
        NSFileManager *fm = [NSFileManager defaultManager];
        defaultPath = [[NSString stringWithString:[pathField stringValue]] stringByResolvingSymlinksInPath];
        if (![fm fileExistsAtPath:defaultPath]) {
            defaultPath = nil;
        }
    }

    [panel beginSheetForDirectory:defaultPath
                              file:[defaultPath lastPathComponent]
                             types:[filetypes count] ? filetypes : nil
                    modalForWindow:[self window]
                     modalDelegate:self
                    didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
                       contextInfo:nil];
}

- (void)sheetDidEnd:(id)sheet returnCode:(int)rc contextInfo:(id)cinfo {
    if (NSOKButton == rc) {
        [pathField setStringValue:[sheet filename]];
        [clearButton setHidden:NO];
    }
}

- (void)click:(id) sender {
    [self performClick:(id) sender];
}

- (void)setFSItem:(id)sender {

    NSString *defaultDirectory;
    NSString *defaultFilename;
    id sPanel = [NSSavePanel savePanel];

    [sPanel setDelegate:self];
    [sPanel setTitle:label];

    if ([filetypes count]) {
        [sPanel setAllowedFileTypes:filetypes];
    }

    if ([pathField stringValue]) {
        NSString *defaultFilePath = [[pathField stringValue] stringByResolvingSymlinksInPath];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isDir;
        if ([fileManager fileExistsAtPath:defaultFilePath isDirectory:&isDir] && isDir) {
            defaultDirectory = [[defaultFilePath retain] autorelease];
            defaultFilename = @"";
        } else {
            defaultDirectory = [defaultFilePath stringByDeletingLastPathComponent];
            defaultFilename = defaultFilePath.lastPathComponent;
        }
    } else {
        defaultDirectory = @"~";
        defaultFilename = @"";
    }

    [sPanel beginSheetForDirectory:defaultDirectory
                              file:defaultFilename
                             types:[filetypes count] ? filetypes : nil
                    modalForWindow:[self window]
                     modalDelegate:self
                    didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:)
                       contextInfo:nil];
}

@end

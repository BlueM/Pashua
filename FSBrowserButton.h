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

#import <Cocoa/Cocoa.h>
#import "ClearButton.h"

@interface FSBrowserButton : NSButton {

    NSTextField *pathField;

    ClearButton *clearButton;

    // The label for the field, which must be saved here, too,
    // because it's used for the open dialog title
    NSString *label;

    // A string of item types that are allowed to be selected by this UI element
    NSMutableArray *filetypes;

    NSString *savetype;

    BOOL chooseDirectory;
    BOOL chooseFiles;
}

/**
 * Sets the path input field this button is associated with
 */
- (void)setPathField:(NSTextField *)textfield;

/**
 * Sets the button for clearing the field
 *
 * @param clearButton ClearButton instance to use
 */
- (void)setClearButton:(ClearButton *)clearButton;

/**
 * Sets up and invokes the sheet for selecting a filesystem item
 *
 * @param sender UI item which triggered the action
 */
- (void)chooseFSItem:(id) sender;

/**
 * Sets up and invokes the sheet for saving a filesystem item
 *
 * @param sender UI item which triggered the action
 */
- (void)setFSItem:(id)sender;

/**
 * Accessor for setting the tooltip
 *
 * @param theLabel The string that should be used as tooltip
 */
- (void)setLabel:(NSString *) theLabel;

/**
 * Accessor for setting the allowed types
 *
 * @param theTypes Space-separated list of file types
 */
- (void)setFiletypes:(NSString *)theTypes;

/**
 ...
 */
- (void)click:(id) sender;

@end

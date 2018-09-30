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
#import "PshCheckbox.h"
#import "PshComboBox.h"
#import "ElementFactory.h"
#import "PshHorizontalLine.h"
#import "PshPopup.h"
#import "PshRadioButton.h"
#import "PshTextField.h"
#import "ButtonContainerView.h"
#import "AlertIcon.h"
#import "NSView+CBAdditions.h"

@interface PshWindow : NSWindow <NSWindowDelegate> {

    NSMutableDictionary *objects; // The views that are added to the window. Keys are element names, values are PshElement instances
    NSString *cancelButtonkey;
    NSString *defaultButtonkey;
    NSStringEncoding encoding; // Encoding to return values in
    int contentViewExtraHeight;
    NSButton *defaultButton;
    NSButton *cancelButton;

    float xOffset; // Horizontal offset in the row of buttons at the bottom of the window
    float yOffset; // Vertical offset from the lower left window content area

    unsigned int autoCloseTime; // Number of seconds after which to close the
                                // window automatically as if the user had clicked the OK button
}

/**
 * @param theAttributes The window attributes as a dictionary
 * @param theElements An NSArray of NSDictionaries, each describing 1 element
 * @param enc The desired encoding for the dialog result
 */
+ (id)windowWithAttributes:(NSDictionary *)theAttributes
               andElements:(NSArray *)theElements
            resultEncoding:(NSStringEncoding)enc;

/**
 * @param theAttributes The window attributes as a dictionary
 * @param theElements An NSArray of NSDictionaries, each describing 1 element
 * @param enc The desired encoding for the dialog result
 */
- (id)initWithAttributes:(NSDictionary *)theAttributes
             andElements:(NSArray *)theElements
          resultEncoding:(NSStringEncoding)enc;

/**
 * Returns the encoding (deprecated)
 */
- (NSStringEncoding)encoding;

/**
 * ...
 */
- (id)objects;

/**
 * ...
 */
- (void)addElementWithAttributes:(NSDictionary *)attributes;

/**
 * ...
 */
- (void)performSave:(id)sender;

/**
 * ...
 */
- (void)cleanup;

/**
 * @param theElements An NSArray of NSDictionaries, each describing 1 element
 */
- (void)setupWindowWithElements:(NSArray *)theElements;

/**
 * ...
 */
- (void)setupDefaultButton;

/**
 * ...
 */
- (void)setupCancelButton;

/**
 * ...
 */
- (void)finishCancelButton;

/**
 ...
 */
- (void)finishDefaultButton;

#pragma mark - Delegate methods

- (void)windowWillClose:(NSNotification *)notification;

@end

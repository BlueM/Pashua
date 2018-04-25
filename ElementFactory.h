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
#import "PshButton.h"
#import "PshCancelButton.h"
#import "PshCheckbox.h"
#import "PshComboBox.h"
#import "PshDate.h"
#import "PshDefaultButton.h"
#import "PshHorizontalLine.h"
#import "PshImage.h"
#import "PshPasswordField.h"
#import "PshPopup.h"
#import "PshOpenBrowser.h"
#import "PshRadioButton.h"
#import "PshSaveBrowser.h"
#import "PshText.h"
#import "PshTextField.h"
#import "PshTextbox.h"

/**
 * Concrete factory that instantiates and returns element view classes
 *
 * Performs some data attribute pre-processing that is common for all classes providing views containing GUI elements and returns an instance of the class
 */
@interface ElementFactory : NSObject {

}

+ (id)createElementWithAttributes:(NSDictionary *)attributes
                         inWindow:(id)window
                          xOffset:(float *)xOffset
                          yOffset:(float *)yOffset;

@end

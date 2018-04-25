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
#import <stdlib.h>
#import "UIConstants.h"

@interface ElementContainerView : NSView {

    /* @var element The GUI element that contains the value, e.g. an NSTextField */
    id element;

    BOOL isMandatory;

    BOOL hasReturnValue;
}

/**
 * Returns whether the element has a return value
 *
 * There are elements that are purely decorative, such as a horizontal line and therefore do not have a return value.
 * @return Returns YES if the element has a return value, NO otherwise
 */
- (BOOL)hasReturnValue;

/**
 * Sets wether the element has a return value
 *
 * @param flag Pass YES to make the element return a value, NO otherwise
 */
- (void)setHasReturnValue:(BOOL)flag;

/**
 * Sets the element container’s element
 *
 * @param newElement The element, which should be an @c NSView
 * @todo Check if actually all element types pass an @c NSView
 */
- (void)setElement:(id)newElement;

- (id)element;

- (CGFloat)elementVerticalCenterYPosition;

- (BOOL)failsMandatoryCheck;

/**
 * @param mandatory Sets whether the element in this element view is mandatory
 */
- (void)setMandatory:(BOOL)mandatory;

/**
 * Returns the string value of the element container’s element
 *
 * @return String (or string) representation of the element’s value, determined by calling -stringValue on the element
 */
- (NSString *)stringValue;

/**
 * Returns the width needed for the content view of the window containing this view
 *
 * @return Height required for the view itself plus any “padding” to the left of the view
 */
- (float)requiredWidth;

/**
 * Returns the height needed for the content view of the window containing this view
 *
 * @return Height required for the view itself plus any “padding” below the view
 */
- (float)requiredHeight;

@end

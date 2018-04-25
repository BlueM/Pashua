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

#import "NSView+CBAdditions.h"

@implementation NSView (CBAdditions)

- (id)findFirstSubviewOfType:(NSString *)clname {

    unsigned int i;

    for (i = 0; i < [[self subviews] count]; i++) {
        id subview = [[self subviews] objectAtIndex:i];
        if ([clname isEqualToString:[subview className]]) {
            return subview;
        }
    }

    // Still here? Then we got no match --> descend 1 level "deeper"
    for (i = 0; i < [[self subviews] count]; i++) {
        id subview = [[self subviews] objectAtIndex:i];
        id subsubview = [subview findFirstSubviewOfType:clname];
        if (subsubview) {
            return subsubview;
        }
    }

    // Still here? Then we got no match --> Return nil
    return nil;
}

- (void)removeAllSubviews {
    NSEnumerator *enumerator = [[self subviews] objectEnumerator];
    id object;
    while (object = [enumerator nextObject]) {
        [object removeFromSuperview];
    }
}

- (void)removeSiblingViews {
    NSEnumerator *enumerator = [[[self superview] subviews] objectEnumerator];
    id object;
    while (object = [enumerator nextObject]) {
        if (self == object) {
            continue;
        }
        [object removeFromSuperviewWithoutNeedingDisplay];
    }
    [[self superview] setNeedsDisplay:YES];
}

- (void)unhideEveryWindowSubview {
    NSEnumerator *enumerator = [[[[self window] contentView] subviews] objectEnumerator];
    id object;
    while (object = [enumerator nextObject]) {
        [object setHidden:NO];
    }
}

@end

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

#import "AppController.h"

@implementation AppController

- (void)awakeFromNib {

    // Make app the frontmost one -- important when invoked from the shell
    [NSApp activateIgnoringOtherApps:YES];

    ConfigParser *cp = [self configParserWithLaunchArguments];

    @try {
        [PshWindow windowWithAttributes:[cp windowAttributes]
                            andElements:[cp elements]
                         resultEncoding:[cp encoding]];
    } @catch (id e) {
        [self terminateWithAlert:[e reason]];
    }
}

- (ConfigParser *)configParserWithLaunchArguments {

    ConfigParser *cp;

    NSMutableArray *arguments = [NSMutableArray arrayWithArray:[[NSProcessInfo processInfo] arguments]];

    if ([arguments count] > 1 &&
        [[arguments objectAtIndex:1] isEqualToString:@"-e"]) {
        if ([arguments objectAtIndex:2]) {
            [arguments removeObjectAtIndex:2];
        }
        [arguments removeObjectAtIndex:1];
        fprintf(stderr, "Pashua was called with the deprecated -e option, which has been ignored since 2014. Please do no longer use this option.\n");
    }

    NS_DURING
        cp = [ConfigParser configParserWithArguments:arguments];
    NS_HANDLER
        [self terminateWithAlert:[localException reason]];
    NS_ENDHANDLER

    return cp;
}

- (IBAction)showDocumentation:(id)sender {
    [[NSWorkspace sharedWorkspace]openFile:[[NSBundle mainBundle] pathForResource:@"Documentation" ofType:@"html"]];
}

- (void)terminateWithAlert:(NSString *)message {
    NSRunAlertPanel(WRD_ERROR, @"%@", @"OK", nil, nil, message);
    [NSApp terminate:self];
}

- (void)dealloc {
    [super dealloc];
}

@end

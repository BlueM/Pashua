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

#import "PshDate.h"

@implementation PshDate

+ (NSString *)elementClassName {
    return @"NSDatePicker";
}

+ (id)createWithAttributes:(NSDictionary *)attributes
                 xPosition:(int)x
                 yPosition:(int)y
         relativeXPosition:(int)relx
         relativeYPosition:(int)rely
                   xOffset:(float *)xOffset
                   yOffset:(float *)yOffset
                 forWindow:(id)window {

    unsigned int height = 0;
    unsigned int width = 0;
    unsigned int pickerHeight = 0;
    unsigned int mode = 0;
    BOOL textual = NO;
    BOOL date = YES;
    BOOL time = NO;
    id view, element, label;

    // Display mode and what to display
    if ([[attributes objectForKey:@"textual"] intValue]) {
        textual = YES;
    }
    if ([attributes objectForKey:@"date"] &&
        ![[attributes objectForKey:@"date"] intValue]) {
        date = NO;
    } else {
        mode += NSYearMonthDayDatePickerElementFlag;
    }
    if ([[attributes objectForKey:@"time"] intValue]) {
        time = YES;
        mode += NSHourMinuteDatePickerElementFlag;
    }

    if (0 == mode) {
        [NSException raise:EXC_CONFIG
                    format:@"You cannot suppress both date and time of a 'date' GUI element.\n\nPlease review your dialog configuration string."];
    }

    // Set the width
    if (textual) {
        width = 200;
        pickerHeight = UI_STEPPER_HEIGHT;
    } else {
        // No width defined, use default
        if (time && date) {
            width = UI_DATEPICKER_DATE_WIDTH + UI_WINDOW_CONTENTPADDING + UI_DATEPICKER_TIME_WIDTH;
            pickerHeight = UI_DATEPICKER_DATE_HEIGHT > UI_DATEPICKER_TIME_HEIGHT
                ? UI_DATEPICKER_DATE_HEIGHT : UI_DATEPICKER_TIME_HEIGHT;
        } else if (time) {
            width = UI_DATEPICKER_TIME_WIDTH;
            pickerHeight = UI_DATEPICKER_TIME_HEIGHT;
        } else {
            width = UI_DATEPICKER_DATE_WIDTH;
            pickerHeight = UI_DATEPICKER_DATE_HEIGHT;
        }
    }

    // Create the element
    NSRect fieldRect = NSMakeRect(0, 0, width, pickerHeight);
    element = [[[NSClassFromString([self elementClassName]) alloc] initWithFrame:fieldRect] autorelease];
    height += pickerHeight;

    [element setDatePickerMode:NSSingleDateMode];
    [element setDrawsBackground:YES];
    [element setDatePickerElements:mode];

    if (textual) {
        [element setDatePickerStyle:NSTextFieldAndStepperDatePickerStyle];
        [element sizeToFit];
    } else {
        [element setDatePickerStyle:NSClockAndCalendarDatePickerStyle];
    }

    // Set the default value
    if ([attributes objectForKey:@"default"]) {
        NSDate *date = [PshDate localDateFromString:[attributes objectForKey:@"default"]];
        if (date) {
            [element setDateValue:date];
        }
    } else {
        [element setDateValue:[NSDate date]];
    }

    // Label view
    if ([attributes objectForKey:@"label"]) {
        label = [ElementLabel labelWithString:[attributes objectForKey:@"label"]
                                       withFrame:NSMakeRect(0, pickerHeight + UI_LABEL_VERTICAL_DISTANCE, 200, UI_TEXTFIELD_HEIGHT)];
        if (NSWidth([label frame]) > width) {
            width = NSWidth([label frame]);
        }
        height += NSHeight([label frame]) + UI_LABEL_VERTICAL_DISTANCE;
    } else {
        label = NULL;
    }

    if (x && y) {
        // Position at x/y coordinates
        view = [[ElementContainerView alloc] initWithFrame:NSMakeRect(x, y, width, height)];
    } else {
        // Automatic positioning
        view = [[ElementContainerView alloc] initWithFrame:NSMakeRect(UI_WINDOW_CONTENTPADDING + relx, *yOffset + rely, width, height)];
        *yOffset += NSHeight([view frame]) + UI_WINDOW_CONTENTPADDING + rely;
    }

    [view setElement:element];

    if ([attributes objectForKey:@"tooltip"]) {
        [element setToolTip:[attributes objectForKey:@"tooltip"]];
    }

    if ([attributes objectForKey:@"disabled"] &&
        1 == [[attributes objectForKey:@"disabled"] intValue]) {
        [element setEnabled:NO];
    }

    [view addSubview:element];

    if (label) {
        [view addSubview:label];
    }

    return [view autorelease];
}

+ (NSDate *)localDateFromString:(NSString *)str {
    NSTimeZone *localTZ = [NSTimeZone localTimeZone];
    NSDate *gmtDate = [NSDate dateWithNaturalLanguageString:str];
    NSTimeInterval seconds = [localTZ secondsFromGMTForDate:gmtDate];
    NSDate *localDate = [gmtDate dateByAddingTimeInterval:(-1 * seconds)];
    return [[localDate retain] autorelease];
}

@end

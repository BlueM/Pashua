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

#ifndef Pashua_UIConstants_h
#define Pashua_UIConstants_h

#define UI_BUTTON_HEIGHT 28

// Minimum button width (measured on 10.8)
#define UI_BUTTON_MIN_WIDTH (84.0 + 2 * UI_BUTTON_OVERSIZE)

// Buttons are displayed by the system as if they were this larger.
// When positioning, this value must be subtracted.
// When setting the width, 2 * this value must be added (measured on 10.8)
#define UI_BUTTON_OVERSIZE 6.0

// 8 Is the visible value, which is a little too narrow for Pashua
#define UI_LABEL_VERTICAL_DISTANCE 8 + 2 - UI_BUTTON_OVERSIZE

// Horizontal distance of buttons in a panel (measured on 10.8)
#define UI_WINDOW_BUTTON_DISTANCE 12.0

// Distance from a window border to the content view (measured on 10.8)
#define UI_WINDOW_CONTENTPADDING 20.0

// Space between vertically stacked elements
#define UI_ELEMENTS_VERTICAL_DISTANCE 20

#define UI_DEFAULT_WIDTH 280

// Stepper heigth, e.g. the stepper for an NSDatePicker
#define UI_STEPPER_HEIGHT 24

#define UI_TEXTFIELD_HEIGHT 22

#define HI_POPUP_HEIGHT 25

#define HI_COMBO_HEIGHT 26

#define UI_RADIOBUTTON_HEIGHT 19

#define UI_CHECKBOX_HEIGHT 18

#define UI_CLEARBUTTON_WIDTH 16

#define UI_DATEPICKER_DATE_WIDTH 139

#define UI_DATEPICKER_DATE_HEIGHT 148

#define UI_DATEPICKER_TIME_WIDTH 122

#define UI_DATEPICKER_TIME_HEIGHT 123

#define UI_SPACE 12

#define UI_IMG_BORDERPADDING 14

#endif

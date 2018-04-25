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

@interface ConfigParser : NSObject {

    // Contains the keys of elements in the order in which they should appear in the dialog
    NSMutableArray *_elementsOrder;

    // Contains window attributes
    NSMutableDictionary *_window;

    // key=>NSDictionary pairs which describe the _elements' attributes
    NSMutableDictionary *_elements;

    // NSStringEncoding used in the configuration (if auto-detected, can be != UTF8)
    NSStringEncoding encoding;

    BOOL parseableAsUtf8;
}

- (NSArray *)elements;
- (NSDictionary *)windowAttributes;

/**
 * Returns the encoding used to read the configuration
 */
- (NSStringEncoding)encoding;

/**
 * Returns an auto-released ConfigParser which reads from stdin or the the given file, depending on argument 1
 *
 * @param arguments
 * @return Configuration parser instance
 */
+ (id)configParserWithArguments:(NSArray *)arguments;

/**
 * Saves the value of an element property
 *
 * @param value Configuration value
 * @param key Configuration "element.property" key
 * @return Returns YES on success, NO if the property name does not contain the separator character expected between element name and property name
 */
- (BOOL)saveValue:(NSString *)value forKey:(NSString *)key;

@end

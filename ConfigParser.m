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

#import "ConfigParser.h"

@implementation ConfigParser

#pragma mark - Class methods

+ (id)configParserWithArguments:(NSArray *)arguments {
    if ([arguments count] > 1 && [[arguments objectAtIndex:1] isEqualToString:@"-"]) {
        // Read from stdin
        ConfigParser *cp  = [[ConfigParser alloc] init];
        NSData *stdinData = [[NSFileHandle fileHandleWithStandardInput] readDataToEndOfFile];

        NSString *configString = [[NSString alloc] initWithData:stdinData encoding:NSUTF8StringEncoding];
        [cp setEncoding:NSUTF8StringEncoding];
        [cp parseString:[cp normalizeLineBreaks:configString]];
        [configString release];
        return [cp autorelease];
    }

    // Else: read from file
    ConfigParser *cp = [[ConfigParser alloc] init];
    [cp parseString:[cp readFile:[arguments count] > 1 ? [arguments objectAtIndex:1] : nil]];
    return [cp autorelease];
}

#pragma mark - Instance methods

- (NSArray *)elements {
    unsigned int i;
    NSMutableArray *md = [NSMutableArray arrayWithCapacity:[_elementsOrder count]];

    for (i = 0; i < [_elementsOrder count]; i ++) {
        NSString *element = [_elementsOrder objectAtIndex:i];
        [md addObject:[_elements objectForKey:element]];
    }

    return [NSArray arrayWithArray:md];
}

- (NSDictionary *)windowAttributes {
    return [NSDictionary dictionaryWithDictionary:_window];
}

- (NSStringEncoding)encoding {
    return encoding;
}

- (void)setEncoding:(NSStringEncoding)strEncoding {
    encoding = strEncoding;
}

- (void)parseString:(NSString *)config {
    NSArray *lines = [config componentsSeparatedByString:@"\n"];
    NSCharacterSet *whiteSpace = [NSCharacterSet whitespaceCharacterSet];
    unsigned int i;

    // Loop over lines and extract element names, properties and values
    for (i = 0; i < [lines count]; i ++) {

        NSString *line = [[lines objectAtIndex:i] stringByTrimmingCharactersInSet:whiteSpace];
        NSUInteger pos = [line rangeOfString:@"="].location;

        // Comment or empty line >> skip
        if ([line isEqualTo:@""] ||
            [[line substringToIndex:1] isEqualTo:@"#"]) {
            continue;
        }

        // Horizontal line / separator
        if ([line isEqualTo:@"-"]) {
            [_elementsOrder addObject:@"-"];
            [_elements setObject:[NSDictionary dictionaryWithObjectsAndKeys:@"-", @"key", @"-", @"type", nil]
                         forKey:@"-"];
            continue;
        }

        // If this line does not contain an equal sign, raise an exception
        if (pos == NSNotFound) {
            [NSException raise:EXC_CONFIG format:PHR_CFGSTRANGELINE, line];
        }

        // Find key and value
        if (YES != [self saveValue:[[line substringFromIndex:pos + 1] stringByTrimmingCharactersInSet:whiteSpace]
                            forKey:[[line substringToIndex:pos] stringByTrimmingCharactersInSet:whiteSpace]]) {
            // Error trying to save the values
            [NSException raise:EXC_CONFIG format:PHR_CFGSTRANGELINE, line];
        }
    }
}

- (BOOL)saveValue:(NSString *)value forKey:(NSString *)key {
    NSUInteger pos = [key rangeOfString:CFG_ATTRSEP].location;

    if (pos == NSNotFound) {
        // Line does not contain a separator character
        return NO;
    }

    NSString *name     = [key substringToIndex:pos];
    NSString *property = [key substringFromIndex:pos + 1];

    if ([name isEqualToString:CFG_GLOBAL]) {
        // Global attribute >> add to _window
        [_window setObject:value forKey:property];
        return YES;
    }

    if ([property isEqualToString:@"tooltip"]) {
        value = [value stringByReplacingOccurrencesOfString:@"\\n" withString:@"\n"];
    }

    if (nil == [_elements objectForKey:name]) {
        // 1st occurrence of this element
        [_elementsOrder addObject:name];
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:6];
        [dict setObject:name forKey:@"key"];
        [_elements setObject:dict forKey:name];
    }

    // Save the property
    // For any _elements that rely on value lists (radio buttons, ...) we have to
    // check for a property called "option", which must be stored in an NSMutableArray
    if ([property isEqualToString:@"option"]) {

        // Non-scalar property value, save in an NSMutableArray
        if (nil == [[_elements objectForKey:name] objectForKey:@"options"]) {
            // 1st option --> create the NSMutableArray
            [[_elements objectForKey:name]
                        setObject:[[[NSMutableArray alloc] initWithCapacity:4] autorelease] forKey:@"options"];
        }
        [[[_elements objectForKey:name] objectForKey:@"options"] addObject:value];
    } else {
        // Scalar property value
        [[_elements objectForKey:name] setObject:value
                                          forKey:property];
    }

    return YES;
}

- (NSString *)readFile:(NSString *)path {
    NSString *defaultConfig =
        [NSString stringWithFormat:PHR_CFGPATHMISSING,
                                    [[NSBundle mainBundle] pathForResource:@"dialog-bg" ofType:@"png"]];

    if (!path) {
        // No configuration file given
        return defaultConfig;
    }

    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        // The specified path to the config file does not exist at all
        DLog(@"Path: %@", path);
        if ([path length] > 5 &&
            [[path substringToIndex:5] isEqualToString:@"-psn_"]) {
            // Only the usual "App was launched by doubleclicking in the Finder"-argument, i.e.: no config file
            return defaultConfig;
        } else {
            // Otherwise: config file specified, but does not exist
            [NSException raise:EXC_CONFIG format:PHR_CFGPATHINVALID];
        }
    }

    if (![[NSFileManager defaultManager] isReadableFileAtPath:path]) {
        // The config file can not be read
        [NSException raise:EXC_CONFIG format:PHR_CFGPATHNOREAD];
    }

    NSStringEncoding usedEncoding;
    NSString *configuration = [NSString stringWithContentsOfFile:path
                                                    usedEncoding:&usedEncoding
                                                           error:NULL];

    if (nil == configuration) {
        [NSException raise:EXC_CONFIG format:PHR_CFGENCODING];
    }

    [self setEncoding:usedEncoding];

    return [self normalizeLineBreaks:configuration];
}

- (NSString *)normalizeLineBreaks:(NSString *)srcString {

    NSMutableString *string = [[NSMutableString alloc] initWithCapacity:[srcString length]];
    [string setString:srcString];

    [string replaceOccurrencesOfString:@"\r\n"
                            withString:@"\n"
                              options:NSLiteralSearch
                                range:NSMakeRange(0, [string length])];

    [string replaceOccurrencesOfString:@"\r"
                            withString:@"\n"
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];

    return [string autorelease];
}

#pragma mark - init/dealloc

- (id)init {
    self = [super init];
    _elementsOrder = [[NSMutableArray alloc] init];
    _elements = [[NSMutableDictionary alloc] init];
    _window = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)dealloc {
    [_elements release];
    [_elementsOrder release];
    [_window release];
    [super dealloc];
}

@end

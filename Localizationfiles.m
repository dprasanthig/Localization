//
//  Localizationfiles.m
//  Localization
//
//  Created by prasanthi on 1/21/15.
//  Copyright (c) 2015 prasanthi. All rights reserved.
//

#import "Localizationfiles.h"

#define LOCALIZATIONFILE_PREFERRED_LOCALE_KEY @"LOCALIZATIONFILE_PREFERRED_LOCALE_KEY"

@interface Localizationfile ()

@property (nonatomic, retain) NSDictionary *strings;
@property (nonatomic, retain) NSString *defaultLanguage;

@end

@implementation Localizationfile {
    NSString * _language;
}

// Singleton
// Taken from http://lukeredpath.co.uk/blog/a-note-on-objective-c-singletons.html
+ (Localizationfile *)sharedInstance
{
    __strong static id _sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark -
#pragma mark Loading

- (void)loadFromJSONFile:(NSString *)fileName defaultLanguage:(NSString *)defaultLanguage
{
    self.strings = nil;
    
    NSData * JSONData = [NSData dataWithContentsOfFile:fileName];
    
    self.strings = [NSJSONSerialization JSONObjectWithData:JSONData options:0 error:nil];
    
    self.defaultLanguage = defaultLanguage;
}

+ (void)loadFromJSONFile:(NSString *)fileName defaultLanguage:(NSString *)defaultLanguage
{
    [[self sharedInstance] loadFromJSONFile:fileName defaultLanguage:defaultLanguage];
}

#pragma mark -
#pragma mark Supported languages

- (NSArray *)supportedLanguages
{
    return [self.strings allKeys];
}

#pragma mark -
#pragma mark Language

- (NSString *)sanitizeLanguage:(NSString *)language
{
    // Is language supported?
    if ([self.supportedLanguages indexOfObject:language] == NSNotFound) {
        language = nil;
    }
    
    // Try to figure out language from locale
    if (!language) {
        NSArray *preferredLanguages = [NSLocale preferredLanguages];
        language = [preferredLanguages firstObjectCommonWithArray:self.supportedLanguages];
    }
    
    // In the worst case, return default setting
    if (language == nil) {
        language = self.defaultLanguage;
    }
    
    return language;
}

- (NSString *)language
{
    if (!_language) {
        NSString *preferredLanguage = [[NSUserDefaults standardUserDefaults] stringForKey:LOCALIZATIONFILE_PREFERRED_LOCALE_KEY];
        preferredLanguage = [self sanitizeLanguage:preferredLanguage];
        self.language = [preferredLanguage copy];
    }
    return _language;
}

- (void)setLanguage:(NSString *)language
{
    language = [self sanitizeLanguage:language];
    
    // Skip is the new setting is the same as the old one
    if (![language isEqual:_language]) {
        // Get rid of the current setting
        _language = nil;
        
        // Check if new setting is supported by localization
        if ([self.supportedLanguages indexOfObject:language] != NSNotFound) {
            _language = [language copy];
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:LocalizationfileLanguageDidChangeNotification object:nil]];
        }
        
        [[NSUserDefaults standardUserDefaults] setObject:_language forKey:LOCALIZATIONFILE_PREFERRED_LOCALE_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

#pragma mark -
#pragma mark Strings

- (NSString *)stringForKey:(NSString *)key language:(NSString *)language
{
    NSDictionary * langugeStrings = self.strings[language];
    NSString * string = langugeStrings[key];
#if DEBUG
    if (!string) {
        NSLog(@"Localizationfile: no string for key %@ in language %@", key, language);
    }
#endif
    return string;
}

- (NSString *)stringForKey:(NSString *)key
{
    return [self stringForKey:key language:self.language];
}

+ (NSString *)stringForKey:(NSString *)key
{
    return [[Localizationfile sharedInstance] stringForKey:key];
}

+ (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders
{
    return [[Localizationfile sharedInstance] stringForKey:key withPlaceholders:placeholders];
}

- (NSString *)stringForKey:(NSString *)localizationKey withPlaceholders:(NSDictionary *)placeholders
{
    __block NSString * result = [self stringForKey:localizationKey];
    [placeholders enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        if ([key isKindOfClass:NSString.class] && [obj isKindOfClass:NSString.class]) {
            result = [result stringByReplacingOccurrencesOfString:key withString:obj];
        }
    }];
    
    return result;
}

@end
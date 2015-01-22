//
//  Localizationfiles.h
//  Localization
//
//  Created by prasanthi on 1/21/15.
//  Copyright (c) 2015 prasanthi. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalizationfileLanguageDidChangeNotification @"LocalizationfileLanguageDidChangeNotification"

@interface Localizationfile : NSObject

@property (nonatomic, copy) NSString * language;
@property (nonatomic, readonly) NSArray * supportedLanguages;
@property (nonatomic, readonly) NSString * systemLanguage;

+ (NSString *)stringForKey:(NSString *)key;
+ (NSString *)stringForKey:(NSString *)key withPlaceholders:(NSDictionary *)placeholders;
+ (Localizationfile *)sharedInstance;

+ (void)loadFromJSONFile:(NSString *)fileName defaultLanguage:(NSString *)defaultLanguage;

@end

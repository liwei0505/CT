//
//  MarkupParser.m
//  CoreTextDemo
//
//  Created by lee on 2018/3/20.
//  Copyright © 2018年 mjsfax. All rights reserved.
//

#import "MarkupParser.h"

@implementation MarkupParser
- (instancetype)init {
    if (self = [super init]) {
        self.font = @"Arial";
        self.color = [UIColor blackColor];
        self.strokeColor = [UIColor whiteColor];
        self.strokeWidth = 0.0;
        self.images = [NSMutableArray array];
    }
    return self;
}

- (NSAttributedString *)attrStringFromMarkup:(NSString *)markup {
    NSMutableAttributedString *aString = [[NSMutableAttributedString alloc] initWithString:@""];
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:@"(.*?)(<[^>]+>|\\Z)" options:NSRegularExpressionCaseInsensitive|NSRegularExpressionDotMatchesLineSeparators error:nil];
    NSArray *chunks = [regex matchesInString:markup options:0 range:NSMakeRange(0, [markup length])];
    
    for (NSTextCheckingResult *b in chunks) {
        NSArray *parts = [[markup substringWithRange:b.range] componentsSeparatedByString:@"<"];
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)self.font, 24.0f, NULL);
        NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:(id)self.color.CGColor,kCTForegroundColorAttributeName,fontRef,kCTFontAttributeName,(id)self.strokeColor.CGColor,(NSString *)kCTStrokeColorAttributeName,(id)[NSNumber numberWithFloat:self.strokeWidth],(NSString *)kCTStrokeWidthAttributeName, nil];
        [aString appendAttributedString:[[NSAttributedString alloc] initWithString:[parts objectAtIndex:0] attributes:attrs]];
        CFRelease(fontRef);
        
        if ([parts count] > 1) {
            NSString *tag = (NSString *)[parts objectAtIndex:1];
            if ([tag hasPrefix:@"font"]) {
                //stroke color
                NSRegularExpression *scolorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=strokeColor=\")\\w+" options:0 error:NULL];
                [scolorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                   
                    if ([[tag substringWithRange:result.range] isEqualToString:@"none"]) {
                        self.strokeWidth = 0.0;
                    } else {
                        self.strokeWidth = -3.0;
                        SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color",[tag substringWithRange:result.range]]);
                        self.strokeColor = [UIColor performSelector:colorSel];
                    }
                    
                }];
                
                //color
                NSRegularExpression *colorRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=color=\")\\w+" options:0 error:NULL];
                [colorRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                   
                    SEL colorSel = NSSelectorFromString([NSString stringWithFormat:@"%@Color",[tag substringWithRange:result.range]]);
                    self.color = [UIColor performSelector:colorSel];
                    
                }];
                
                //face
                NSRegularExpression *faceRegex = [[NSRegularExpression alloc] initWithPattern:@"(?<=face=\")[^\"]+" options:0 error:NULL];
                [faceRegex enumerateMatchesInString:tag options:0 range:NSMakeRange(0, [tag length]) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
                   
                    self.font = [tag substringWithRange:result.range];
                }];
            }//end of font parsing
        }
    }
    
    
    return aString;
}

@end

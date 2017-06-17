//
//  MTCoreTextAttribute.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/11.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTCoreTextAttribute.h"

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface MTCoreTextAttribute ()

@end


@implementation MTCoreTextAttribute

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.attributeDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)setColor:(UIColor *)color {

    [self.attributeDic setObject:(id)color.CGColor forKey:(id)kCTForegroundColorAttributeName];
}
- (void)setFont:(UIFont *)font {
    [self.attributeDic setObject:(id)font forKey:(id)kCTFontAttributeName];
}

- (void)setUderlineWithType:(int)type andColor:(UIColor *)color {
    
    [self.attributeDic setObject:[NSNumber numberWithInt:type]
                          forKey:(id)kCTUnderlineStyleAttributeName];
    
    
}

- (void)shadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius {
    
    
}

- (id)mutableCopyWithZone:(NSZone *)zone {

    MTCoreTextAttribute *textAttr = [[self class] allocWithZone:zone];
    textAttr.attributeDic = [_attributeDic mutableCopy];
    return textAttr;
}




@end
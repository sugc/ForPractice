//
//  MTLabelAttribute.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/8.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTLabelAttribute.h"

#import <Foundation/Foundation.h>


@interface MTLabelAttribute ()

@end

@implementation MTLabelAttribute

- (BOOL)isInRang:(NSRange)range {
    
    return NSEqualRanges(self.range, range);
}

- (id)copyWithZone:(NSZone *)zone {
    
    MTLabelAttribute *copy = [[self class] allocWithZone:zone];
    copy.type = [_type copy];
    copy.normalAttribute = [_normalAttribute mutableCopy];
    copy.hightlightAttribute = [_hightlightAttribute mutableCopy];
    copy.isAddImage = _isAddImage;
    copy.text = _text;
    copy.isAddGif = _isAddGif;
    copy.isReplaced = _isReplaced;
    return copy;
}
@end
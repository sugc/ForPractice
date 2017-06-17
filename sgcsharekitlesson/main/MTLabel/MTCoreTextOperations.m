//
//  MTLabelOperations.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/10.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTCoreTextOperations.h"

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface MTCoreTextOperations ()

@end



@implementation MTCoreTextOperations

- (NSMutableAttributedString *)addImage:(UIImage *)image
                                inRange:(NSRange)range
                               withText:(NSMutableAttributedString *) text {
    
    NSString *imgName = @"link.png";
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc]
                                                        initWithString:@"1"];
    
    CTRunDelegateCallbacks imageCallBacks;
    imageCallBacks.version = kCTRunDelegateVersion1;
    imageCallBacks.dealloc = RunDelegateDeallocCallbacks;
    imageCallBacks.getAscent = getAsents;
    imageCallBacks.getDescent = getDescents;
    imageCallBacks.getWidth = RunDelegateGetWidths;
    
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallBacks, (__bridge void *)(imgName));
    
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName
                                  value:(__bridge id)runDelegate
                                  range:range];
    [imageAttributedString addAttribute:@"imageName"
                                  value:imgName
                                  range:range];
    CFRelease(runDelegate);
    
    [text appendAttributedString:imageAttributedString];
    NSMutableAttributedString *tributedString = [[NSMutableAttributedString alloc]
                                                 initWithString:@"2"];
    [text appendAttributedString:tributedString];

    return text;
}

void RunDelegateDeallocCallbacks(void *refCon) {
    
}

CGFloat getAsents(void *refCon) {
    
    return 30;
}

CGFloat getDescents(void *refCon) {
    
    return 0;
}

CGFloat RunDelegateGetWidths(void *refCon) {
    
    return 30;
}

@end
//
//  MTCoreTextAttribute.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/11.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTCoreTextAttribute : NSObject<NSMutableCopying>

@property (nonatomic, strong) NSMutableDictionary  *attributeDic;

- (void)setColor:(UIColor *)color;
- (void)setFont:(UIFont *)font;
- (void)setUderlineWithType:(int)type andColor:(UIColor *)color;
- (void)shadowWithColor:(nullable UIColor *)color offset:(CGSize)offset radius:(CGFloat)radius;

@end
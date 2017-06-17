//
//  UIView+Utils.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/12.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define MTScreenWidth   [UIScreen mainScreen].bounds.size.width
#define MTScreenHeight  [UIScreen mainScreen].bounds.size.height

@interface UIView (Uitls)


- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)left;
- (CGFloat)right;
- (CGFloat)top;
- (CGFloat)bottom;
- (void)setWidth:(CGFloat)width;
- (void)setHeight:(CGFloat)height;
- (void)setLeft:(CGFloat)left;
- (void)setRight:(CGFloat)right;
- (void)setTop:(CGFloat)top;
- (void)setBottom:(CGFloat)bottom;

@end

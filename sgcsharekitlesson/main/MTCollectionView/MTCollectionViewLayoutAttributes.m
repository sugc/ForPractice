//
//  MTCollectionViewAttributes.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/26.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTCollectionViewLayoutAttributes.h"


@interface MTCollectionViewLayoutAttributes ()

@end


@implementation MTCollectionViewLayoutAttributes

- (instancetype)init {
    if (self = [super init]) {
        self.anchorPoint = CGPointMake(0.5, 0.5);
        self.angle = 0;
    }
    return self;
}

- (void)setAngle:(CGFloat)angle {
    _angle = angle;
    self.zIndex = angle * 10000;
    self.transform = CGAffineTransformMakeRotation(angle);
}

- (id)copyWithZone:(NSZone *)zone{

    MTCollectionViewLayoutAttributes *copy = [[self class] allocWithZone:zone];
    copy = [super copyWithZone:zone];
    copy.anchorPoint = _anchorPoint;
    copy.angle = _angle;
    return copy;
}

@end
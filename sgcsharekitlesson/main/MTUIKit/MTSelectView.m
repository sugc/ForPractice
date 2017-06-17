//
//  selectView.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/28.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTSelectView.h"

#import <Foundation/Foundation.h>

#import "UIView+Utils.h"


@interface MTSelectView ()


@end


@implementation MTSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.pagingEnabled = YES;
        
    }
    
    return self;
}




@end
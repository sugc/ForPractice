//
//  UIView+Utils.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/12.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "UIView+Utils.h"

#import <Foundation/Foundation.h>

@implementation UIView (Utils)


- (CGFloat)width{
    return self.frame.size.width;
   
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGFloat)left{
    return self.frame.origin.x;
}

- (CGFloat)right{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)top{
    return self.frame.origin.y;
}

- (CGFloat)bottom{
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setWidth:(CGFloat)width{

    self.frame = CGRectMake(self.left, self.top, width, self.height);
}

- (void)setHeight:(CGFloat)height{
    
    self.frame = CGRectMake(self.left, self.top, self.width, height);

}

- (void)setLeft:(CGFloat)left{

    self.frame = CGRectMake(left, self.top, self.width, self.height);
}

- (void)setRight:(CGFloat)right{

    self.frame = CGRectMake(right - self.width, self.top, self.width, self.height);
}

- (void)setTop:(CGFloat)top{

        self.frame = CGRectMake(self.left, top, self.width, self.height);
}

- (void)setBottom:(CGFloat)bottom{
    
    self.frame = CGRectMake(self.left, bottom - self.height, self.width, self.height);
}



@end
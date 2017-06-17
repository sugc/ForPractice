//
//  MTCollectionViewCell.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/25.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTCollectionViewCell.h"
#import "MTCollectionViewLayoutAttributes.h"

@interface MTCollectionViewCell ()



@end


@implementation MTCollectionViewCell

- (instancetype)init{
    self = [super init];
    if (self) {
        
        self.frame = CGRectMake(0, 0, 100, 100);
        self.layer.cornerRadius = self.frame.size.width / 2.0;
        self.layer.masksToBounds = YES;
        
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self.contentView addSubview:self.imageView];
        _imageView.backgroundColor = [UIColor redColor];
        self.layer.cornerRadius = self.frame.size.width / 2.0;
        self.layer.masksToBounds = YES;
    }
    return self;
}

- (UIImageView *)imageView {
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        _imageView.backgroundColor = [UIColor redColor];
        
    }

    return _imageView;
}



- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    
    MTCollectionViewLayoutAttributes *attr = (MTCollectionViewLayoutAttributes *)layoutAttributes;
    
    
    self.layer.anchorPoint = attr.anchorPoint;
    CGFloat centerY = (attr.anchorPoint.y - 0.5) * CGRectGetHeight(self.bounds) + self.center.y;
    self.center = CGPointMake(self.center.x, centerY);
    
   }

@end



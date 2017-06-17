//
//  MTStripCollectionView.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/9/1.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTStripCollectionView.h"

#import "UIView+Utils.h"
#import "MTStripCollectionViewDelegate.h"

@interface MTStripCollectionView ()

@property (nonatomic, strong) MTStripCollectionViewDelegate *handler;

@end


@implementation MTStripCollectionView

- (void)didMoveToWindow {
    
    
    CGFloat offsetX =(  _imageStrArray.count * ( _cellSpan + _cellSize.width) - self.width) / 2;
    self.contentOffset = CGPointMake(offsetX, self.contentOffset.y);

}

- (id)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.delegate = self.handler;
        self.dataSource = self.handler;
    }
    return self;
}

- (MTStripCollectionViewDelegate *)handler {
    if (!_handler) {
        _handler = [[MTStripCollectionViewDelegate alloc] init];
    }
    return _handler;
}



@end
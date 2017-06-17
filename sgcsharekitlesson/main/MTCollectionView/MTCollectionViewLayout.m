//
//  MTCollectionViewLayout.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/25.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTCollectionViewLayout.h"

#import "UIView+Utils.h"
#import "MTCollectionViewLayoutAttributes.h"
#import "MTCircularCollectionView.h"

@interface MTCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *attrArray;
@property (nonatomic, assign) CGFloat angleAtExtreme;
@property (nonatomic, strong) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizerToLeft;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizerToRight;

@end


@implementation MTCollectionViewLayout

+ (Class)layoutAttributesClass{
    
    return [MTCollectionViewLayoutAttributes class] ;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}


- (void)prepareLayout {
//    [super prepareLayout];
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerX = self.collectionView.width / 2.0;
    _attrArray = [[NSMutableArray alloc] init];

    for (int i = 0; i < itemCount; i ++) {
        MTCollectionViewLayoutAttributes *attr =  [MTCollectionViewLayoutAttributes
                                                  layoutAttributesForCellWithIndexPath:
                                                  [NSIndexPath indexPathForItem:i
                                                                      inSection:0]];
        attr.angle = 2 * M_PI/itemCount * i + ((MTCircularCollectionView *)self.collectionView).angle ;
        attr.size = CGSizeMake(50, 50);
        attr.center = CGPointMake(centerX, attr.size.height / 2.0);
        CGFloat anchorPointY =  self.collectionView.width / 2 / attr.size.height;
        attr.anchorPoint = CGPointMake(0.5, anchorPointY);
        [_attrArray addObject:attr];
    }
    [self layoutAttributesForElementsInRect:self.collectionView.frame];
}




- (CGSize)collectionViewContentSize {
    
    return CGSizeMake(self.collectionView.width , self.collectionView.height);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return _attrArray;
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    

    return [_attrArray objectAtIndex:indexPath.row];
    
}


- (UIPanGestureRecognizer *)panGestureRecognizer {
    if (!_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(handlePan:)];
        [_panGestureRecognizer requireGestureRecognizerToFail:self.swipeGestureRecognizerToLeft];
        [_panGestureRecognizer requireGestureRecognizerToFail:self.swipeGestureRecognizerToRight];
    }
    return _panGestureRecognizer;
}


 
@end


















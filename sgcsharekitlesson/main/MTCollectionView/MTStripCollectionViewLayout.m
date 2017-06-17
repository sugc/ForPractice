//
//  MTStripCollectionViewLayout.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/31.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTStripCollectionViewLayout.h"

#import "UIView+Utils.h"
#import "MTStripCollectionView.h"

@interface MTStripCollectionViewLayout ()

@property (nonatomic, strong) NSMutableArray *attrArray;
@property (nonatomic, assign) CGFloat basicX;
@property (nonatomic, assign) CGFloat cellSpan;
@property (nonatomic, assign) CGSize cellSize;


@end




@implementation MTStripCollectionViewLayout

- (CGSize)cellSize {
    if (CGSizeEqualToSize(_cellSize, CGSizeZero)) {
        MTStripCollectionView *mtStrip = (MTStripCollectionView *)self.collectionView;
        _cellSize = mtStrip.cellSize;
    }
    return _cellSize;
}

- (CGFloat)cellSpan {
    if (_cellSpan == 0) {
        MTStripCollectionView *mtStrip = (MTStripCollectionView *)self.collectionView;
        _cellSpan = mtStrip.cellSpan;
    }
    return _cellSpan;
}

- (id)init {
    self = [super init];
    if (self) {
        _cellSize = CGSizeZero;
        _cellSpan = 0;
    }
    return self;
}
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (void)prepareLayout {
    

    
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    CGFloat centerX ;
    _attrArray = [[NSMutableArray alloc] init];
    
    CGFloat offsetCenterX = self.collectionView.contentOffset.x + self.collectionView.width / 2.0;
    for (int i = 0; i < itemCount; i ++) {
        UICollectionViewLayoutAttributes *attr =  [UICollectionViewLayoutAttributes
                                                   layoutAttributesForCellWithIndexPath:
                                                   [NSIndexPath indexPathForItem:i
                                                                       inSection:0]];
        attr.size = self.cellSize;
        centerX = (attr.size.width + self.cellSpan) /2 *(2 * i + 1);
        CGFloat ratio =  0.8 * (1 - fabs(centerX - offsetCenterX) / self.collectionView.width);
        
        attr.center = CGPointMake(centerX, (self.collectionView.height + attr.size.height) / 2.0);
        
        CGFloat transformY = - attr.size.height * ratio *0.5;

        CGAffineTransform trans = CGAffineTransformMakeTranslation(0 , transformY);
        
        attr.transform =  CGAffineTransformScale(trans,1 + ratio,1 + ratio);
        
        
        
        [_attrArray addObject:attr];
    }
    [self layoutAttributesForElementsInRect:self.collectionView.frame];
}




- (CGSize)collectionViewContentSize {
    
    NSInteger cellNum = [self.collectionView numberOfItemsInSection:0];
    
    return CGSizeMake( cellNum * (_cellSize.width + _cellSpan),
                      self.collectionView.height);
}

-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    return _attrArray;
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    return [_attrArray objectAtIndex:indexPath.row];
    
}

- (void)rotationImageArray {

}



@end

//
//  MTStripCollectionViewDelegate.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/9/1.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTStripCollectionViewDelegate.h"

#import "MTStripCollectionView.h"
#import "UIView+Utils.h"

@interface MTStripCollectionViewDelegate ()


@end


@implementation MTStripCollectionViewDelegate



- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    MTStripCollectionView *mtStrip = (MTStripCollectionView *)collectionView;
    return mtStrip.imageStrArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView
                                  dequeueReusableCellWithReuseIdentifier:@"stripCollectionView"
                                  forIndexPath:indexPath];
    MTStripCollectionView *mtStrip = (MTStripCollectionView *)collectionView;
    cell.backgroundColor = [UIColor redColor];
    UIImage *image = [UIImage
                      imageNamed:[mtStrip.imageStrArray
                                  objectAtIndex:indexPath.row]];
    
    UIImageView *imageView= [[UIImageView alloc] initWithFrame:cell.bounds];
    imageView.image = image;
    [cell.contentView addSubview:imageView];
    NSLog(@"cellWidth%f",cell.bounds.size.width);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
   
    MTStripCollectionView *mtStrip = (MTStripCollectionView *)scrollView;
    CGFloat basicW = mtStrip.cellSize.width + mtStrip.cellSpan ;;
    
    NSInteger trans = (NSInteger)(targetContentOffset->x) % (NSInteger)basicW;
    if (trans > (basicW / 2)) {
        trans = basicW - trans;
    }else {
        trans = -trans;
    }
    
    *targetContentOffset = CGPointMake(targetContentOffset->x + trans,
                                           targetContentOffset->y);

}
@end

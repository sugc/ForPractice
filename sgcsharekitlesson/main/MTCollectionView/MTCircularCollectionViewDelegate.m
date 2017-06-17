//
//  MTCircularCollectionViewDelegate.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/9/1.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTCircularCollectionViewDelegate.h"

#import "MTCollectionViewCell.h"

@interface MTCircularCollectionViewDelegate ()

@end


@implementation MTCircularCollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    
    return _imageStrArray.count;
}


- (BOOL)collectionView:(UICollectionView *)collectionView
shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView
didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MTCollectionViewCell *cell  = [collectionView
                                   dequeueReusableCellWithReuseIdentifier:@"collectionCell"
                                                             forIndexPath:indexPath];
    
    NSString *imageName = [_imageStrArray objectAtIndex:indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageName];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(50, 50);
}



@end
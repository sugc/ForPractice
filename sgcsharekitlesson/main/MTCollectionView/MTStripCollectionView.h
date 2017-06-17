//
//  MTStripCollectionView.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/9/1.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MTStripCollectionView : UICollectionView

@property (nonatomic, strong) NSMutableArray *imageStrArray;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGFloat cellSpan;

@end
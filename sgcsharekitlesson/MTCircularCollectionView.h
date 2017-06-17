//
//  MTCollectionView.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/26.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MTCircularCollectionView : UICollectionView

@property (nonatomic, assign) NSInteger *rotationSpeed;
@property (nonatomic, assign) CGFloat cellRadius;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat angle;

@end
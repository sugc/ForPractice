//
//  Header.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/9/1.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface MTCircularCollectionViewDelegate : NSObject <UICollectionViewDelegate,
                                                        UICollectionViewDataSource>

@property (nonatomic, strong) NSMutableArray *imageStrArray;

@end
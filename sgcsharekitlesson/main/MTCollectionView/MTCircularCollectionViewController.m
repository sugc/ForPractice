//
//  MTCollectionViewController.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/25.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTCircularCollectionViewController.h"

#import "MTCollectionViewLayout.h"
#import "MTCollectionViewCell.h"
#import "UIView+Utils.h"
#import "MTCircularCollectionView.h"
#import "MTStripCollectionViewDelegate.h"


@interface MTCircularCollectionViewController () <UICollectionViewDelegate,
                                          UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) MTCircularCollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *imageStrArray;
@property (nonatomic, assign) BOOL isRotation;
@property (nonatomic, assign) CGPoint lastPoint;

@end


@implementation MTCircularCollectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setData];
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.backBtn];
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)setData {

    _imageStrArray = [[NSMutableArray alloc] init];
    [_imageStrArray addObject:@"avatar1.jpg"];
    [_imageStrArray addObject:@"avatar2.jpeg"];
    [_imageStrArray addObject:@"avatar3.jpg"];
    [_imageStrArray addObject:@"avatar4.jpeg"];
    [_imageStrArray addObject:@"avatar5.jpg"];
    [_imageStrArray addObject:@"avatar6.jpg"];
    [_imageStrArray addObject:@"avatar7.jpeg"];
    [_imageStrArray addObject:@"test2.gif"];
}


- (UIButton *)backBtn {
    
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(5, 24, 50, 30);
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self
                     action:@selector(goBack)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)goBack{
    
    [self dismissViewControllerAnimated:NO completion:^(void){
        
    }];
    
}


@end

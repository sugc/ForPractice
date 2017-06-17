//
//  MTStripCollectionViewController.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/31.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTStripCollectionViewController.h"

#import "MTCollectionViewCell.h"
#import "MTStripCollectionViewLayout.h"
#import "MTStripCollectionViewDelegate.h"
#import "UIView+Utils.h"
#import "MTStripCollectionView.h"
#import "MTCircularCollectionView.h"
#import "MTCollectionViewLayout.h"
#import "MTCircularCollectionViewDelegate.h"

@interface MTStripCollectionViewController () <UICollectionViewDelegate,
                                                UICollectionViewDataSource>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) NSMutableArray *imageStrArray;
@property (nonatomic, strong) NSMutableArray *circularImageStrArray;
@property (nonatomic, strong) MTStripCollectionView *collectionView;
@property (nonatomic, strong) MTCircularCollectionView *circularCollection;
@property (nonatomic, strong) MTStripCollectionViewLayout *layout;
@property (nonatomic, strong) MTCircularCollectionViewDelegate *handler;

//seperate attributes
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGRect collectionViewFrame;

@property (nonatomic, strong) MTStripCollectionViewDelegate *collectionViewDelegate;


@end


@implementation MTStripCollectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUp];
    [self setData];
    
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.collectionView];
//    [self.view addSubview:self.circularCollection];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)setUp {
    _cellSize = CGSizeMake(32, 32);
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
    [_imageStrArray addObject:@"avatar1.jpg"];
    [_imageStrArray addObject:@"avatar2.jpeg"];
    [_imageStrArray addObject:@"avatar3.jpg"];
    [_imageStrArray addObject:@"avatar4.jpeg"];
    [_imageStrArray addObject:@"avatar5.jpg"];
    [_imageStrArray addObject:@"avatar6.jpg"];
    [_imageStrArray addObject:@"avatar7.jpeg"];
    [_imageStrArray addObject:@"test2.gif"];
    [_imageStrArray addObject:@"avatar1.jpg"];
    [_imageStrArray addObject:@"avatar2.jpeg"];
    [_imageStrArray addObject:@"avatar3.jpg"];
    [_imageStrArray addObject:@"avatar4.jpeg"];
    [_imageStrArray addObject:@"avatar5.jpg"];
    [_imageStrArray addObject:@"avatar6.jpg"];
    [_imageStrArray addObject:@"avatar7.jpeg"];
    [_imageStrArray addObject:@"test2.gif"];
    [_imageStrArray addObject:@"avatar1.jpg"];
    [_imageStrArray addObject:@"avatar2.jpeg"];
    [_imageStrArray addObject:@"avatar3.jpg"];
    [_imageStrArray addObject:@"avatar4.jpeg"];
    [_imageStrArray addObject:@"avatar5.jpg"];
    [_imageStrArray addObject:@"avatar6.jpg"];
    [_imageStrArray addObject:@"avatar7.jpeg"];
    [_imageStrArray addObject:@"test2.gif"];

    
    _circularImageStrArray = [[NSMutableArray alloc] init];
    [_circularImageStrArray addObject:@"avatar1.jpg"];
    [_circularImageStrArray addObject:@"avatar2.jpeg"];
    [_circularImageStrArray addObject:@"avatar3.jpg"];
    [_circularImageStrArray addObject:@"avatar4.jpeg"];
    [_circularImageStrArray addObject:@"avatar5.jpg"];
    [_circularImageStrArray addObject:@"avatar6.jpg"];
    [_circularImageStrArray addObject:@"avatar7.jpeg"];
    [_circularImageStrArray addObject:@"test2.gif"];
   
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

- (MTCircularCollectionView *)circularCollection {
    
    if (!_circularCollection) {
        
        _handler = [[MTCircularCollectionViewDelegate alloc] init];
        _handler.imageStrArray = _circularImageStrArray;
        UICollectionViewLayout *layout = [[MTCollectionViewLayout alloc] init];
        CGRect frame = CGRectMake(0, 100, MTScreenWidth, MTScreenWidth );
        _circularCollection = [[MTCircularCollectionView alloc] initWithFrame:frame
                                                     collectionViewLayout:layout];
        _circularCollection.backgroundColor = [UIColor grayColor];
        _circularCollection.radius = _collectionView.width / 2.0;
        _circularCollection.cellRadius = 25;
        
        [_circularCollection registerClass:[MTCollectionViewCell class]
            forCellWithReuseIdentifier:@"collectionCell"];
        [_circularCollection registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"headerId"];
        [_circularCollection registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"footerId"];
        
        _circularCollection.dataSource = _handler;
        _circularCollection.delegate = _handler;
    }
    return _circularCollection;

}

- (MTStripCollectionView *)collectionView {
    if (!_collectionView) {
        
        CGRect frame = CGRectMake(0, 400, MTScreenWidth , 100);
        _layout = [[MTStripCollectionViewLayout alloc] init];
        _collectionView = [[MTStripCollectionView alloc] initWithFrame:frame
                                             collectionViewLayout:_layout];
        
        _collectionView.contentOffset = CGPointMake(_collectionView.contentSize.width / 3,
                                                    _collectionView.contentOffset.y);
        
        _collectionView.cellSize = self.cellSize;
        _collectionView.cellSpan = 32;
    
        _collectionView.backgroundColor = [UIColor grayColor];
        _collectionView.imageStrArray = _imageStrArray;
        
        [_collectionView registerClass:[UICollectionViewCell class]
            forCellWithReuseIdentifier:@"stripCollectionView"];
        
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"head"];
        
        [_collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                   withReuseIdentifier:@"foot"];
       
    }
    return  _collectionView;
}
 

@end
//
//  MTPaitViewController.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/19.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTPaintViewController.h"

#import <Foundation/Foundation.h>

#import "MTPaintView.h"
#import "MTGrayFilterView.h"

@interface MTPaintViewController ()

@end


@implementation MTPaintViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.view.frame];
        MTPaintView *paintView = [[MTPaintView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor whiteColor];
//    MTGrayFilterView *grayFilterView = [[MTGrayFilterView alloc]
//                                        initWithFrame:[UIScreen mainScreen].bounds];
    [self.view addSubview:imageView];
    imageView.userInteractionEnabled = YES;
    [imageView addSubview:paintView];
    
}

@end
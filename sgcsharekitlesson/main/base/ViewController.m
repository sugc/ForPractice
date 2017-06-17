//
//  ViewController.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/12.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "ViewController.h"

#import "MTFacebookShareViewController.h"
#import "MTLabelDemo.h"
#import "MTGLESViewController.h"
#import "MTPaintViewController.h"
#import "MTGPUImageStillViewController.h"
#import "MTGPUImageStillCameraViewController.h"
#import "MTGPUImageVideoViewController.h"
#import "MTCircularCollectionViewController.h"
#import "MTStripCollectionViewController.h"


@interface ViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setData];
//    [self.view addSubview:self.facebookShareBtn];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.tableView];
    // Do any additional setup after loading the view, typically from a nib.
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setData{
    _dataArray = [[NSMutableArray alloc] init];
    [_dataArray addObject:@"分享到Facebook"];
    [_dataArray addObject:@"openGL"];
    [_dataArray addObject:@"GPUImageStillImage"];
    [_dataArray addObject:@"GPUImageStillCamera"];
    [_dataArray addObject:@"GPUImageVideoCamera"];
    [_dataArray addObject:@"MTLabelDemo"];
    [_dataArray addObject:@"MTCollectionView"];
    

}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(50, 24, [UIScreen mainScreen].bounds.size.width - 100, 50);
        _titleLabel.text = @"example";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor blackColor];
        
    }
    return  _titleLabel;
}



- (UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0,
                                      80,
                                      [UIScreen mainScreen].bounds.size.width,
                                      [UIScreen mainScreen].bounds.size.height - 80);
        
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    
    return _tableView;
}

- (void)shareToFacebook{
    
    MTFacebookShareViewController *facebookShareVC = [[MTFacebookShareViewController alloc] init];
    [self presentViewController:facebookShareVC animated:NO completion:^(void){
        
    }];
    
}

- (void)goToOpenGL{
    
//    MTPaintViewController *painVC = [[MTPaintViewController alloc] init];
     MTGLESViewController *painVC = [[MTGLESViewController alloc] init];
        [self presentViewController:painVC
                       animated:NO
                     completion:nil];
    
}

- (void)gotoGpuImageStillImage{
    
    MTGPUImageStillViewController *stillVC = [[MTGPUImageStillViewController alloc] init];
    [self presentViewController:stillVC animated:NO completion:nil];
}

- (void)gotoGpuImageStillCamera{
    
    MTGPUImageStillCameraViewController *stillCameraVC = [[MTGPUImageStillCameraViewController
                                                           alloc]
                                                          init];
    [self presentViewController:stillCameraVC animated:NO completion:nil];
}


- (void)gotoGpuImageVideoCamera{
    
    MTGPUImageVideoViewController *videoVC = [[MTGPUImageVideoViewController alloc] init];
    [self presentViewController:videoVC animated:NO completion:nil];
}

//*************UITableViewDelegate, UITableViewDataSource***************/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"shareTableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:@"shareTableViewCell"];
        cell.textLabel.text = [_dataArray objectAtIndex:indexPath.row];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
            [self shareToFacebook];
            break;
        case 1:
            [self goToOpenGL];
            break;
        case 2:
            [self gotoGpuImageStillImage];
            break;
        case 3:
            [self gotoGpuImageStillCamera];
            break;
        case 4:
            [self gotoGpuImageVideoCamera];
            break;
        case 5:{
            MTLabelDemo *demo = [[MTLabelDemo alloc] init];
            [self presentViewController:demo animated:NO completion:nil];
            break;
            }
        case 6:{
//            MTCircularCollectionViewController *collectionVC = [[MTCircularCollectionViewController
//                                                                 alloc]
//                                                                init];
            
            MTStripCollectionViewController *collectionVC = [[MTStripCollectionViewController
                                                                 alloc]
                                                                init];
            [self presentViewController:collectionVC animated:NO completion:NULL];

            break;
        }
        default:
            break;
    }

}


@end

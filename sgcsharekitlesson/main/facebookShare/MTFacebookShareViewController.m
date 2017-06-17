//
//  MTFacebookShareViewController.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/12.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTFacebookShareViewController.h"

#import <Foundation/Foundation.h>
#import <Social/Social.h>

#import "MTFacebookFBSKDShareViewController.h"
#import "MTFacebookSocialShareViewController.h"
#import "UIView+Utils.h"

@interface MTFacebookShareViewController()

@property (nonatomic, strong) UIButton *socialShareBtn;
@property (nonatomic, strong) UIButton *fbSDKShareBtn;
@property (nonatomic, strong) UIButton *backBtn;


@end

@implementation MTFacebookShareViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.socialShareBtn];
    [self.view addSubview:self.fbSDKShareBtn];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}
- (UIButton *)socialShareBtn{
    
    if (!_socialShareBtn) {
        _socialShareBtn = [[UIButton alloc] init];
        _socialShareBtn.frame = CGRectMake(50,
                                           70,
                                           MTScreenWidth - 100,
                                           40);
        [_socialShareBtn setTitle:@"social share" forState:UIControlStateNormal];
        _socialShareBtn.backgroundColor = [UIColor grayColor];
        [_socialShareBtn addTarget:self
                            action:@selector(socialShare)
                  forControlEvents:UIControlEventTouchUpInside];

    }
    return _socialShareBtn;
}

- (UIButton *)fbSDKShareBtn{

    if (!_fbSDKShareBtn) {
        _fbSDKShareBtn = [[UIButton alloc] init];
        _fbSDKShareBtn.frame = CGRectMake(self.socialShareBtn.left,
                                          self.socialShareBtn.bottom + 15,
                                          self.socialShareBtn.width,
                                          self.socialShareBtn.height);
        [_fbSDKShareBtn setTitle:@"fbSDK share" forState:UIControlStateNormal];
        _fbSDKShareBtn.backgroundColor = [UIColor grayColor];
        [_fbSDKShareBtn addTarget:self
                            action:@selector(fbSDKShare)
                  forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _fbSDKShareBtn;
}

- (UIButton *)backBtn{
    
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


- (void)socialShare{
    
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        
        MTFacebookSocialShareViewController *socialShareVC = [[MTFacebookSocialShareViewController
                                                               alloc ]
                                                              init];
        [self presentViewController:socialShareVC animated:NO completion:nil];
        
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"请先登录Facebook"
                                                        message:nil
                                                        preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"确定"
                                                               style:UIAlertActionStyleCancel
                                                             handler:nil];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:NO completion:nil];
    }
    
}

- (void)fbSDKShare{

    MTFacebookFBSKDShareViewController *fbShareVC = [[MTFacebookFBSKDShareViewController
                                                      alloc]
                                                     init];
    [self presentViewController:fbShareVC animated:NO completion:nil];
}

- (void)goBack{
    
    [self dismissViewControllerAnimated:NO completion:^(void){
        
    }];

}
@end
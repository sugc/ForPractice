//
//  MTFacebookSocialShare.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/12.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTFacebookSocialShareViewController.h"

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <Social/Social.h>

#import "UIView+Utils.h"

@interface  MTFacebookSocialShareViewController () <
    UINavigationControllerDelegate,
    UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *addImageBtn;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@end




@implementation MTFacebookSocialShareViewController

- (void)viewDidLoad{
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.backBtn];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.addImageBtn];
    [self.view addSubview:self.textView];
    [self.view addSubview:self.shareButton];
}

- (void)didReceiveMemoryWarning{
    
    [super didReceiveMemoryWarning];
}

- (UIButton *)backBtn{
    
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(5, 24, 50, 30);
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backBtn;
}

- (UILabel *)titleLabel{

    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.frame = CGRectMake(0, 24, MTScreenWidth, 50);
        _titleLabel.text = @"Facebook";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        
    }
    return _titleLabel;
}

- (UITextView *)textView{
    
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.frame = CGRectMake(0,
                                     self.imageView.bottom + 15,
                                     MTScreenWidth,
                                     100);
        _textView.backgroundColor = [UIColor grayColor];
    }
    return _textView;
}

- (UIImageView *)imageView{
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0,
                                      self.titleLabel.bottom + 15,
                                      MTScreenWidth,
                                      300);
        _imageView.backgroundColor = [UIColor grayColor];
    }
    
    return _imageView;
}

- (UIButton *)addImageBtn{
    
    if (!_addImageBtn) {
        _addImageBtn = [[UIButton alloc] init];
        _addImageBtn.frame = self.imageView.frame;
        [_addImageBtn setTitle:@"点击插入图片" forState:UIControlStateNormal];
        [_addImageBtn addTarget:self
                         action:@selector(addImage)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addImageBtn;
}

- (UIButton *)shareButton{

    if (!_shareButton) {
        _shareButton = [[UIButton alloc] init];
        _shareButton.frame = CGRectMake(0,
                                        self.textView.bottom,
                                        MTScreenWidth,
                                        MTScreenHeight - self.textView.bottom);
        [_shareButton setTitle:@"分享" forState:UIControlStateNormal];
        [_shareButton addTarget:self
                         action:@selector(share)
               forControlEvents:UIControlEventTouchUpInside];
        _shareButton.backgroundColor = [UIColor blueColor];
    }
    
    return _shareButton;
}

- (UIImagePickerController *)imagePicker{

    if (!_imagePicker) {
        
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagePicker.allowsEditing = YES;
        _imagePicker.delegate = self;

    }
    
    return _imagePicker;
}


- (void)goBack{
    
    [self dismissViewControllerAnimated:NO completion:nil];

}

- (void)addImage{
    
    [self presentViewController:self.imagePicker animated:NO completion:nil];
    
}

- (void)share{
    
    SLComposeViewController *facebookShareVC = [SLComposeViewController
                                                        composeViewControllerForServiceType:SLServiceTypeFacebook];
    [facebookShareVC addImage:self.imageView.image];
    [facebookShareVC setInitialText:self.textView.text];
    facebookShareVC.completionHandler = ^(SLComposeViewControllerResult result){
        if (result == SLComposeViewControllerResultDone) {
            
            
        }else
            if (result == SLComposeViewControllerResultCancelled) {
    
            }
    
    };
    
    [self presentViewController:facebookShareVC animated:NO completion:^(void){
                
    }];


}

//******************************UIImagePickerControllerDelegate*********************************/

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    if ([[info objectForKey:UIImagePickerControllerMediaType]
         isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.imageView setImage:image];
        
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    [self.addImageBtn setTitle:@"" forState:UIControlStateNormal];
}



@end
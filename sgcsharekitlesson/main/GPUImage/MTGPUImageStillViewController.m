//
//  GPUImageStillView.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/27.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTGPUImageStillViewController.h"

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>

#import <GPUImage.h>

#import "UIView+Utils.h"



@interface MTGPUImageStillViewController ()<UIImagePickerControllerDelegate,
                                            UINavigationControllerDelegate>

@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UIImage *originImage;
@property (nonatomic, strong)UISegmentedControl *segmentedControl;
@property (nonatomic, strong)GPUImagePicture *gpuPicture;
@property (nonatomic, strong)UIButton *goBackButton;

@end



@implementation MTGPUImageStillViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.segmentedControl];
    [self.view addSubview:self.goBackButton];

    
}

- (UIImageView *)imageView{

    if (!_imageView) {
        
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0, 0, MTScreenWidth, MTScreenHeight - 24 - 50);
        _imageView.userInteractionEnabled = YES;
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        UIButton *button = [[UIButton alloc] initWithFrame:_imageView.frame];
        [button addTarget:self
                   action:@selector(chooseImage)
         forControlEvents:UIControlEventTouchUpInside];
        
        [_imageView addSubview:button];
    }
    return _imageView;
}

- (UISegmentedControl *)segmentedControl{

    if (!_segmentedControl) {
        
        NSArray *arry = @[@"效果一", @"效果二"];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:arry];
        
        _segmentedControl.frame = CGRectMake(0,
                                             self.imageView.bottom + 10,
                                             MTScreenWidth,
                                             50);
        [_segmentedControl addTarget:self
                              action:@selector(clickSegment:)
                    forControlEvents:UIControlEventValueChanged];
        
    }
    
    return _segmentedControl;
}


- (void)chooseImage{

    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:NO completion:nil];
}

- (void)clickSegment:(UISegmentedControl *)Seg{

    [self filterWithIndex:Seg.selectedSegmentIndex];
}

- (void)filterWithIndex:(NSInteger )index{
    
    UIImage *inputImage = [UIImage imageNamed:@"1.jpg"];
    
    GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:inputImage];
    GPUImageOutput <GPUImageInput> *stillImageFilter;
    
    
    switch (index) {
        case 0:
            stillImageFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 1:
            stillImageFilter = [[GPUImageColorInvertFilter alloc] init];
            break;
        default:
            break;
    }
    GPUImageColorInvertFilter *filter2 = [[GPUImageColorInvertFilter alloc] init];
    
    [stillImageSource addTarget:stillImageFilter];
    [stillImageFilter addTarget:filter2];
    [stillImageSource processImage];
    [filter2 useNextFrameForImageCapture];
    UIImage *currentFilteredVideoFrame = [filter2 imageFromCurrentFramebuffer];
    self.imageView.image = currentFilteredVideoFrame;

    
    
}


- (UIButton *)goBackButton{
    
    if (!_goBackButton) {
        _goBackButton = [[UIButton alloc] init];
        _goBackButton.frame = CGRectMake(10,
                                         20,
                                         30,
                                         20);
        [_goBackButton setTitle:@"⬅️" forState:UIControlStateNormal];
        [_goBackButton addTarget:self
                          action:@selector(goBack)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBackButton;
}

- (void)goBack{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

//*******************************************ImagePickerViewControllerDelegate************/

- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{

    if ([[info objectForKey:UIImagePickerControllerMediaType]
         isEqualToString:(NSString *)kUTTypeImage]) {
        
        UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
        [self.imageView setImage:image];
        
    }
    
    [picker dismissViewControllerAnimated:NO completion:nil];
    
}


@end
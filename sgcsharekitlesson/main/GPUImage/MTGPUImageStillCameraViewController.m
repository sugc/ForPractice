//
//  MTGPUImageStillCameraViewController.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/28.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTGPUImageStillCameraViewController.h"

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

#import <GPUImage.h>

#import "UIView+Utils.h"
#import "MTContext.h"


@interface MTGPUImageStillCameraViewController ()

@property (nonatomic, strong)GPUImageStillCamera *stillCamera;
@property (nonatomic, strong)GPUImageView *captureView;
@property (nonatomic, strong)GPUImageOutput <GPUImageInput> *filter;
@property (nonatomic, strong)UIButton *goBackButton;
@property (nonatomic, strong)UIButton *captureButton;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)NSArray *filterArray;

@end


@implementation MTGPUImageStillCameraViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    [MTContext shareContext];
    [self.view addSubview:self.captureView];
    [self.view addSubview:self.goBackButton];
    [self addGamaFilter];
    [self.view addSubview:self.captureButton];
    _index = 0;
    [self setFilter];
    
}

- (void)viewDidAppear:(BOOL)animated{

    [super viewDidAppear:animated];
    [self.stillCamera startCameraCapture];
}

- (GPUImageStillCamera *)stillCamera{
    
    if (!_stillCamera) {
        _stillCamera = [[GPUImageStillCamera alloc]
                        initWithSessionPreset:AVCaptureSessionPreset640x480
                        cameraPosition:AVCaptureDevicePositionBack];
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
        
        
    }
    return _stillCamera;
}

- (void)setFilter{
    
    GPUImageFilter *filter = [[GPUImageFilter alloc] initWithFragmentShaderFromFile:@"fragmentss"];
    GPUImageColorInvertFilter *colorInvertFilter = [[GPUImageColorInvertFilter alloc] init];
    GPUImageBrightnessFilter *brightFilter = [[GPUImageBrightnessFilter alloc] init];
    GPUImageLevelsFilter *levelsFilter = [[GPUImageLevelsFilter alloc] init];
    GPUImageSharpenFilter *sharpenFilter = [[GPUImageSharpenFilter alloc] init];
    GPUImageSobelEdgeDetectionFilter *edgeFilter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    
    _filterArray = @[filter, colorInvertFilter, brightFilter, levelsFilter, sharpenFilter, edgeFilter];
    
}

- (GPUImageView *)captureView{
    
    if (!_captureView) {
        _captureView = [[GPUImageView alloc] init];
        _captureView.frame = CGRectMake(0, 0, MTScreenWidth, MTScreenHeight - 80);
        
        UISwipeGestureRecognizer *swipeGestureLeft = [[UISwipeGestureRecognizer alloc]
                                                      initWithTarget:self
                                                      action:@selector(swipe:)];
        [swipeGestureLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        UISwipeGestureRecognizer *swipeGestureRight = [[UISwipeGestureRecognizer alloc]
                                                       initWithTarget:self
                                                       action:@selector(swipe:)];
        [swipeGestureRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [_captureView addGestureRecognizer:swipeGestureLeft];
        [_captureView addGestureRecognizer:swipeGestureRight];


    }
    return _captureView;
}


- (void)swipe:(UISwipeGestureRecognizer *)gesture{
    if (gesture.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        if (_index == 0) {
            _index = _filterArray.count - 1;
        }else{
            _index --;
            
        }
    }
    
    if (gesture.direction == UISwipeGestureRecognizerDirectionRight) {
        
        if (_index < _filterArray.count - 1) {
            _index ++;
        }else{
            
            _index = 0;
        }
    }
    
    [self filterWithIndex:_index];
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

- (UIButton *)captureButton{
    
    if (!_captureButton) {
        _captureButton = [[UIButton alloc] init];
        _captureButton.frame = CGRectMake((MTScreenWidth - 50) / 2.0,
                                         (MTScreenHeight - 50 - 20),
                                         50,
                                         50);
        
        _captureButton.layer.cornerRadius = _captureButton.width / 2.0;
        _captureButton.layer.masksToBounds = YES;
        _captureButton.backgroundColor = [UIColor whiteColor];
        [_captureButton addTarget:self
                           action:@selector(capture)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureButton;
}

- (void)addGamaFilter{
    
    [self.stillCamera stopCameraCapture];
    [self.stillCamera removeAllTargets];
    _filter = [[GPUImageColorInvertFilter alloc] init];
    [self.stillCamera addTarget:_filter];
    [_filter addTarget:self.captureView];
    [self.stillCamera startCameraCapture];
}

- (void)capture{
    
    [self.stillCamera
     capturePhotoAsPNGProcessedUpToFilter:_filter
     withCompletionHandler:^(NSData *imageData, NSError *erro){

         ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
         
         [library writeImageDataToSavedPhotosAlbum:imageData metadata:self.stillCamera.currentCaptureMetadata completionBlock:^(NSURL *assetURL, NSError *erro){
             
             [library assetForURL:assetURL resultBlock:^(ALAsset *asset){
                 
                [library enumerateGroupsWithTypes:ALAssetsGroupAll
                                       usingBlock:^(ALAssetsGroup *group,BOOL *stop){
                                           
                     if ([[group valueForProperty:ALAssetsGroupPropertyName]
                          isEqualToString:@"sgcTest"]) {
                         
                         [group addAsset:asset];
                     }
                 } failureBlock:^(NSError *erro){
                     
                 }];
                 
             } failureBlock:^(NSError *erro){
                 
             }];
         }];
     }];
}

- (void)goBack{

    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)filterWithIndex:(NSInteger )index{
    
//     [self.stillCamera stopCameraCapture];
    [_filter removeAllTargets];
    [self.stillCamera removeAllTargets];
    
    _filter = [_filterArray objectAtIndex:index];
    
    [self.stillCamera addTarget:_filter];
    [_filter addTarget:self.captureView];
//    [self.stillCamera startCameraCapture];
}


@end
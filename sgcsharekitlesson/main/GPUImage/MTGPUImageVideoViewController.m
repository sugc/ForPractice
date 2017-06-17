//
//  MTGPUImageVideoViewController.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/28.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTGPUImageVideoViewController.h"

#import <Foundation/Foundation.h>

#import <GPUImage.h>
#import <MBProgressHUD.h>

#import "UIView+Utils.h"
#import "MTContext.h"
#import "MTMovieWriter.h"
#import "MTCompositionViewController.h"

@interface MTGPUImageVideoViewController ()<GPUImageVideoCameraDelegate>{

    CMTime last;
    CMTime _timeOffset;

}

@property (nonatomic, strong)GPUImageVideoCamera *videoCamera;
@property (nonatomic, strong)GPUImageView *captureView;
@property (nonatomic, strong)UIButton *goBackButton;
@property (nonatomic, strong)MTMovieWriter *movieWriter;
@property (nonatomic, strong)UIButton *captureButton;
@property (nonatomic, strong)UIButton *audioButton;
@property (nonatomic, strong)UIButton *compositionButton;
@property (nonatomic, assign)NSInteger isCapturing;
@property (nonatomic, assign)NSInteger isPause;
@property (nonatomic, assign)BOOL isAudioOn;
@property (nonatomic, assign)BOOL isDiscount;
@property (nonatomic, assign)NSInteger index;
@property (nonatomic, strong)NSArray *filterArray;
@property (nonatomic, strong)GPUImageOutput <GPUImageInput> *filter;

@end


@implementation MTGPUImageVideoViewController


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self.view addSubview:self.captureView];
    [self.view addSubview:self.goBackButton];
    [self.view addSubview:self.captureButton];
    [self.view addSubview:self.audioButton];
    [self.view addSubview:self.compositionButton];
    [self.videoCamera startCameraCapture];
    _timeOffset = CMTimeMake(0, 0);
    [self setFilter];
    _isCapturing = 0;
    _index = 0;
    _isPause = 0;
    _isDiscount = NO;
    _isAudioOn = YES;
    [self initCapture];
    
}

- (void)setFilter{
    
     GPUImageColorInvertFilter *colorInvertFilter = [[GPUImageColorInvertFilter alloc] init];
    GPUImageBrightnessFilter *brightFilter = [[GPUImageBrightnessFilter alloc] init];
    GPUImageLevelsFilter *levelsFilter = [[GPUImageLevelsFilter alloc] init];
    GPUImageSharpenFilter *sharpenFilter = [[GPUImageSharpenFilter alloc] init];
    GPUImageSobelEdgeDetectionFilter *edgeFilter = [[GPUImageSobelEdgeDetectionFilter alloc] init];
    
    _filterArray = @[colorInvertFilter, brightFilter, levelsFilter, sharpenFilter, edgeFilter];

}

- (GPUImageVideoCamera *)videoCamera{

    if (!_videoCamera) {
        _videoCamera = [[GPUImageVideoCamera alloc]
                        initWithSessionPreset:AVCaptureSessionPreset640x480
                        cameraPosition:AVCaptureDevicePositionBack];
        
         [_videoCamera addAudioInputsAndOutputs];
         _videoCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
       
        
    }
    return _videoCamera;
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

- (UIButton *)audioButton{
    
    if (!_audioButton) {
        _audioButton = [[UIButton alloc] init];
        _audioButton.frame = CGRectMake(20,
                                    self.captureButton.top + (self.captureButton.width - 30) /2.0,
                                        30,
                                        30);
        
        _audioButton.layer.cornerRadius = _audioButton.width / 2.0;
        _audioButton.layer.masksToBounds = YES;
        UIImage *image = [UIImage imageNamed:@"audio.png"];
        [_audioButton setImage:image forState:UIControlStateNormal];
        [_audioButton addTarget:self
                         action:@selector(switchAudio)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _audioButton;
}

- (UIButton *)compositionButton{
    
    if (!_compositionButton) {
        _compositionButton = [[UIButton alloc] init];
        _compositionButton.frame = CGRectMake(MTScreenWidth - 50,
                                    self.captureButton.top + (self.captureButton.width - 30) /2.0,
                                    30,
                                    30);
        
        _compositionButton.layer.cornerRadius = _compositionButton.width / 2.0;
        _compositionButton.layer.masksToBounds = YES;
        UIImage *image = [UIImage imageNamed:@"composition1.png"];
        [_compositionButton setImage:image forState:UIControlStateNormal];
        [_compositionButton addTarget:self
                         action:@selector(gotoComposition)
               forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _compositionButton;
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

- (void)gotoComposition{
    
    _isCapturing = 0;
    self.audioButton.enabled = YES;
    self.captureButton.backgroundColor = [UIColor whiteColor];
    NSString *pathToMovie = [NSHomeDirectory()
                             stringByAppendingPathComponent:@"Documents/Movie.m4v"];
    UISaveVideoAtPathToSavedPhotosAlbum(pathToMovie, nil, nil, nil);
    
    [_movieWriter finishRecordingWithCompletionHandler:^(void){
        
        dispatch_async(dispatch_get_main_queue(), ^(void){
            
            MTCompositionViewController *compositionVC = [[MTCompositionViewController alloc] init];
            [self presentViewController:compositionVC
                               animated:NO
                             completion:nil];

        });
       
    }];

}

- (void)capture{
    
    if (_isCapturing == 0) {
        
        _isCapturing = 1;
        self.audioButton.enabled = NO;
        self.captureButton.backgroundColor = [UIColor redColor];
        [self initCapture];
        [_movieWriter startRecording];
        
    }else{

        if (_isPause == 0) {
            
            self.captureButton.backgroundColor = [UIColor redColor];
            self.movieWriter.isPause = YES;
            _isPause = 1;
            
            
        }else{
            
            self.captureButton.backgroundColor = [UIColor whiteColor];
            self.movieWriter.isPause = NO;
            self.movieWriter.isDisCount = YES;
            _isPause = 0;
            
        }
    }
}



- (void)switchAudio{
    if (_isAudioOn) {
        
        _isAudioOn = NO;
        UIImage *image = [UIImage imageNamed:@"slient.jpg"];
        [_audioButton setImage:image forState:UIControlStateNormal];
       
    }else{
        
        self.videoCamera.audioEncodingTarget = _movieWriter;
        _isAudioOn = YES;
        UIImage *image = [UIImage imageNamed:@"audio.png"];
        [_audioButton setImage:image forState:UIControlStateNormal];
        
    }
}

- (void)initCapture{
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/Movie.m4v"];
    unlink([path UTF8String]);
    NSURL *url = [NSURL fileURLWithPath:path];
    
    _movieWriter = [[MTMovieWriter alloc] initWithMovieURL:url
                                                      size:CGSizeMake(360.0, 640.0)];
    [_movieWriter processAudioBuffer:NULL];
    
    if (_isAudioOn) {
         self.videoCamera.audioEncodingTarget = _movieWriter;
    }
    _movieWriter.hasAudioTrack = YES;
    _movieWriter.shouldPassthroughAudio = YES;
    
    [_movieWriter configure];
   
    [self filterWithIndex:_index];
}

- (void)filterWithIndex:(NSInteger )index{
    
    [self.videoCamera removeAllTargets];
    [_filter removeAllTargets];
    
    _filter = [_filterArray objectAtIndex:index];
    
    [self.videoCamera addTarget:_filter];
    [_filter addTarget:self.captureView];
    [_filter addTarget:_movieWriter];
    
}



@end
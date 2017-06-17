//
//  MTMusicSelectView.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/3.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTCompositionViewController.h"

#import <Foundation/Foundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVAsset.h>
#import <MediaPlayer/MediaPlayer.h>

#import <MBProgressHUD.h>

#import "MTMusicOperations.h"
#import "UIView+Utils.h"


@interface MTCompositionViewController ()<UITableViewDelegate,
                                        UITableViewDataSource,
                                        UINavigationControllerDelegate,
                                        UIImagePickerControllerDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImagePickerController *picker;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIButton *videoSelectButton;
@property (nonatomic, strong) UIButton *musicSelectButton;
@property (nonatomic, strong) UIButton *compositionButton;
@property (nonatomic, strong) UIButton *goBackButton;
@property (nonatomic, strong) UIButton *dsPlayerButton;
@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSURL *musicUrl;
@property (nonatomic, strong) NSURL *videoUrl;

@end



@implementation MTCompositionViewController

- (void)viewDidLoad{

    [super viewDidLoad];
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.videoSelectButton];
    [self.view addSubview:self.goBackButton];
    [self.view addSubview:self.musicSelectButton];
    [self.view addSubview:self.compositionButton];
    [self.view addSubview:self.tableView];
    _dataArray = [MTMusicOperations MusicArray];
    
    
}

- (UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.frame = CGRectMake(0,
                                      MTScreenHeight,
                                      MTScreenWidth,
                                      MTScreenHeight / 2.5);
        _tableView.backgroundColor = [UIColor grayColor];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UIImageView *)imageView{

    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.frame = CGRectMake(0,
                                      24,
                                      MTScreenWidth,
                                      MTScreenHeight / 3 * 2.5);
        _imageView.backgroundColor = [UIColor whiteColor];
        _imageView.userInteractionEnabled = YES;
    }
    return _imageView;
}

- (UIButton *)videoSelectButton{

    if (!_videoSelectButton) {
        _videoSelectButton = [[UIButton alloc] init];
        _videoSelectButton.frame = self.imageView.frame;
        [_videoSelectButton addTarget:self
                               action:@selector(selectVideo)
                     forControlEvents:UIControlEventTouchUpInside];
        
        [_videoSelectButton setTitle:@"点击添加视频" forState:UIControlStateNormal];
    }
    return _videoSelectButton;
}


- (UIButton *)musicSelectButton{
    
    if (!_musicSelectButton) {
        _musicSelectButton = [[UIButton alloc] init];
        _musicSelectButton.frame = CGRectMake(10,
                                              self.imageView.bottom + 5,
                                              MTScreenWidth / 2.0 - 20,
                                              MTScreenHeight - self.imageView.bottom - 10);
        [_musicSelectButton setTitle:@"选择背景音乐" forState:UIControlStateNormal];
        [_musicSelectButton addTarget:self
                               action:@selector(selectMusic)
                     forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _musicSelectButton;
}

- (UIButton *)compositionButton{
    
    if (!_compositionButton) {
        _compositionButton = [[UIButton alloc] init];
        _compositionButton.frame = CGRectMake(MTScreenWidth / 2 + 10,
                                              self.imageView.bottom + 5,
                                              MTScreenWidth / 2.0 - 20,
                                              MTScreenHeight - self.imageView.bottom - 10);
        [_compositionButton setTitle:@"合成" forState:UIControlStateNormal];
        [_compositionButton addTarget:self
                               action:@selector(compositions)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    return _compositionButton;
}

- (UIButton *)goBackButton{
    
    if (!_goBackButton) {
        _goBackButton = [[UIButton alloc] init];
        _goBackButton.frame = CGRectMake(10,
                                         24,
                                         30,
                                         30);
        [_goBackButton setTitle:@"⬅️" forState:UIControlStateNormal];
        [_goBackButton addTarget:self
                          action:@selector(goBack)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _goBackButton;
}

- (UIButton *)dsPlayerButton{
    
    if (!_dsPlayerButton) {
        _dsPlayerButton = [[UIButton alloc] init];
        _dsPlayerButton.frame = CGRectMake(10,
                                         24,
                                         30,
                                         30);
        [_dsPlayerButton setTitle:@"⬅️" forState:UIControlStateNormal];
        [_dsPlayerButton addTarget:self
                          action:@selector(disPlayer)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _dsPlayerButton;
}

- (MPMoviePlayerController *)moviePlayer{
    if (!_moviePlayer) {
        
        _moviePlayer = [[MPMoviePlayerController alloc] init];
        _moviePlayer.controlStyle = MPMovieControlStyleEmbedded;
        [_moviePlayer.view setFrame:self.view.frame];
        [_moviePlayer.view addSubview:self.dsPlayerButton];
    }
    
    return _moviePlayer;
}


- (void)goBack{
    
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)disPlayer{
    [self.moviePlayer.view removeFromSuperview];
    [self.moviePlayer stop];
}
- (UIImagePickerController *)picker{

    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        _picker.mediaTypes = @[(NSString *)kUTTypeVideo, (NSString *)kUTTypeMovie];
        _picker.delegate = self;
    }
    return _picker;
}

- (void)selectVideo{
   
    [self presentViewController:self.picker animated:NO completion:nil];
}

- (void)selectMusic{
    [UIView animateWithDuration:0.5 animations:^(void){
        self.tableView.frame = CGRectMake(self.tableView.left,
                                          MTScreenHeight - self.tableView.height,
                                          self.tableView.width,
                                          self.tableView.height);
    
    }];
}


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    
    NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
    _videoUrl = url;
   
    UIImage *image = [self getFirstFrameWithUrl:url];
    if (image) {
        self.imageView.image = image;
        [_videoSelectButton setTitle:@"" forState:UIControlStateNormal];
    }
    [picker dismissViewControllerAnimated:NO completion:nil];
}


- (UIImage *)getFirstFrameWithUrl:(NSURL *)url{
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url
                                                options:nil];
    AVAssetImageGenerator *generator = [AVAssetImageGenerator assetImageGeneratorWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    generator.maximumSize = CGSizeMake(self.imageView.width, self.imageView.height);
    NSError *error = nil;
    CGImageRef img = [generator copyCGImageAtTime:CMTimeMake(0, 10) actualTime:NULL error:&error];
    
    if (error) {
        return nil;
    }
    
    return [UIImage imageWithCGImage:img];
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:@"musicCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"musicCell"];
        
    }
    
    MPMediaItem *item = [_dataArray objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    return cell;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MPMediaItem *item = [_dataArray objectAtIndex:indexPath.row];
    _musicUrl = [item valueForProperty:MPMediaItemPropertyAssetURL];

    [UIView animateWithDuration:0.5 animations:^(void){
        self.tableView.frame = CGRectMake(self.tableView.left,
                                      MTScreenHeight,
                                      self.tableView.width,
                                      self.tableView.height);
    }];

}

- (void)compositions{
    if (_musicUrl == NULL || _videoUrl == NULL) {
        return;
    }
    NSLog(@"composition");
    AVMutableComposition *compsition = [AVMutableComposition composition];
    
    MBProgressHUD *hud=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode=MBProgressHUDAnimationZoom;//枚举类型不同的效果
    hud.labelText=@"loading";
    
    AVAsset *videoAsset = [AVAsset assetWithURL:_videoUrl];
    AVAsset *musicAsset = [AVAsset assetWithURL:_musicUrl];
    
    AVAssetTrack *videoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
    AVAssetTrack *audioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    AVAssetTrack *musicTrack = [[musicAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    
    AVMutableCompositionTrack *videoCompsitionTrack = [compsition
                                                    addMutableTrackWithMediaType:AVMediaTypeVideo
                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *audioCompsitionTrack = [compsition
                                                    addMutableTrackWithMediaType:AVMediaTypeAudio
                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    AVMutableCompositionTrack *musicCompsitionTrack = [compsition
                                                    addMutableTrackWithMediaType:AVMediaTypeAudio
                                                    preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //设置音量
    
    AVMutableAudioMixInputParameters *inputPar = [AVMutableAudioMixInputParameters
                                        audioMixInputParametersWithTrack:audioCompsitionTrack];
    AVMutableAudioMixInputParameters *inputPar2 = [AVMutableAudioMixInputParameters
                                            audioMixInputParametersWithTrack:musicCompsitionTrack];
    [inputPar setVolume:0.8 atTime:kCMTimeZero];
    [inputPar2 setVolume:0.05 atTime:kCMTimeZero];
    AVMutableAudioMix *mix = [[AVMutableAudioMix alloc] init];
    mix.inputParameters = [NSArray arrayWithObjects:inputPar,inputPar2,nil];
    
     CMTimeRange videoTimeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
    
    [videoCompsitionTrack insertTimeRange:videoTimeRange
                                  ofTrack:videoTrack
                                   atTime:kCMTimeZero
                                    error:nil];
    [audioCompsitionTrack insertTimeRange:videoTrack.timeRange
                                  ofTrack:audioTrack
                                   atTime:kCMTimeZero
                                    error:nil];
    [musicCompsitionTrack insertTimeRange:videoTimeRange
                                  ofTrack:musicTrack
                                   atTime:kCMTimeZero
                                    error:nil];
    NSString *documents = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSString *outPutFilePath = [documents stringByAppendingPathComponent:@"Moviel.m4v"];
    unlink([outPutFilePath UTF8String]);
    // 添加合成路径
    NSURL *outputFileUrl = [NSURL fileURLWithPath:outPutFilePath];
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:compsition           presetName:AVAssetExportPresetMediumQuality];
    
    exporter.outputURL = outputFileUrl;
    exporter.audioMix = mix;
    exporter.outputFileType = AVFileTypeMPEG4;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.error) {
            //...
            NSLog(@"erro%@",exporter.error.userInfo);
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
            });

        }else{
            //...
            NSLog(@"sucess");
            dispatch_async(dispatch_get_main_queue(), ^{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                UISaveVideoAtPathToSavedPhotosAlbum(outPutFilePath, self, nil, nil);
                
                self.moviePlayer.contentURL = outputFileUrl;
                [self.view addSubview:self.moviePlayer.view];
                [self.moviePlayer play];
                
            });
           
        }
    }];
    
}

@end
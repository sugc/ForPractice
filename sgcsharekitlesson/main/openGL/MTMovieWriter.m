//
//  MTMovieWriter.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/1.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTMovieWriter.h"

#import <Foundation/Foundation.h>

@interface MTMovieWriter (){

    CMTime _timeOffset ;
    CMTime _last;
    
}

@end

@implementation MTMovieWriter

- (void)configure{
    _timeOffset = CMTimeMake(0, 1);
    _isDisCount = NO;
    _isPause = NO;
    _isAudioOn = YES;
    _offSet = kCMTimeZero;
}

- (void)newFrameReadyAtTime:(CMTime)frameTime atIndex:(NSInteger)textureIndex{

    if (_isPause) {
        return;
    }
    
    if (_isDisCount) {
        _isDisCount = NO;
         _offSet = CMTimeSubtract(frameTime, _last);
        if (_offSet.value > 0) {
            _timeOffset = CMTimeAdd(_timeOffset, _offSet);
        }
    }
    
    _last = frameTime;
    frameTime = CMTimeSubtract(frameTime, _timeOffset);
    [super newFrameReadyAtTime:frameTime atIndex:textureIndex];

}

- (void)processAudioBuffer:(CMSampleBufferRef)audioBuffer
{
  
    if (_isPause) {
        return;
    }
    
    [super processAudioBuffer:audioBuffer];
}


@end









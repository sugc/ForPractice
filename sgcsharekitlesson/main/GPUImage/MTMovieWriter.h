//
//  MTMovieWriter.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/1.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import <GPUImageMovieWriter.h>

@interface MTMovieWriter : GPUImageMovieWriter

@property (nonatomic, assign)BOOL isPause;
@property (nonatomic, assign)BOOL isDisCount;
@property (nonatomic, assign)BOOL isAudioOn;
@property (nonatomic, assign) CMTime offSet;

- (void)configure;

@end




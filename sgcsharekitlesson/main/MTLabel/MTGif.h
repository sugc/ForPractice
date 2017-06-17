//
//  MTGif.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/17.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface MTGifImage : NSObject

@property (nonatomic, strong, readonly) NSArray *imageFrames;
@property (nonatomic, strong, readonly) NSArray *properties;
@property (nonatomic, strong, readonly) NSArray *delayTimes;
@property (nonatomic, assign) CGRect frame;

- (void)setImageInfoWithUrl:(NSString *)url;

@end

@interface MTGif : CALayer

@property (nonatomic, strong) MTGifImage *gifImage;

- (void)drawMTGif:(MTGifImage *)gifImage withConetx:(CGContextRef )context;
- (void)startAnnotation;
- (void)stopAnnotation;

@end
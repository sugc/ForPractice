//
//  MTGif.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/17.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTGif.h"

#import <Foundation/Foundation.h>
#import <ImageIO/ImageIO.h>

@interface MTGif()

//@property (nonatomic, strong) NSMutableArray *gifArray;
@property (nonatomic, assign) CGContextRef context;
@property (nonatomic, assign) NSInteger index;

@end


@implementation MTGif

- (instancetype)init {
    self = [super init];
    if (self) {
        _index = 0;
    }
    return self;
}




- (void)drawInContext:(CGContextRef)ctx {
    
    
    CGContextTranslateCTM(ctx , 0 ,self.frame.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    [CATransaction setDisableActions:NO];
    
    UIImage *image = [_gifImage.imageFrames objectAtIndex:_index];
    CGImageRef cgimage = image.CGImage;
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
    CGContextDrawImage(ctx, _gifImage.frame, cgimage);
    
}



- (void)drawRect:(CGRect)rect{
    
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx , 0 ,self.frame.size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    [CATransaction setDisableActions:NO];
    //    CGContextSetShouldAntialias(ctx, YES);
    //    CGContextSetInterpolationQuality(ctx, kCGInterpolationHigh);
    
    
    
    UIImage *image = [_gifImage.imageFrames objectAtIndex:_index];
    CGImageRef cgimage = image.CGImage;
    UIGraphicsBeginImageContext(CGSizeMake(self.frame.size.width, self.frame.size.height));
    CGContextDrawImage(ctx, _gifImage.frame, cgimage);
    

}

- (void)setAnittation {
    
    CADisplayLink* gameTimer;
    gameTimer = [CADisplayLink displayLinkWithTarget:self
                                            selector:@selector(updateDisplay:)];
    [gameTimer setFrameInterval: 20];
    [gameTimer addToRunLoop:[NSRunLoop currentRunLoop]
                    forMode:NSDefaultRunLoopMode];

}


- (void) updateDisplay:(CADisplayLink *)link {
    [self changeImage];
}

- (void)startAnnotation {
       [self setAnittation];
}


- (void)changeImage {
    _index ++;
    _index = _index % _gifImage.imageFrames.count;
    CGFloat delay = [[_gifImage.delayTimes objectAtIndex:_index] floatValue];
    [self setNeedsDisplay];

}
@end

@implementation MTGifImage

- (void)setImageInfoWithUrl:(NSString *)url {
    
    NSMutableArray *imageFrames = [[NSMutableArray alloc] init];
    //    NSMutableArray *properties = [[NSMutableArray alloc] init];
    NSMutableArray *delayTimes = [[NSMutableArray alloc] init];
    
    NSURL *filrUrl = [NSURL fileURLWithPath:url];
    CFURLRef cfUrl = (__bridge CFURLRef)filrUrl;
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(cfUrl, NULL);
    NSInteger count = CGImageSourceGetCount(gifSource);
    
    for (int i = 0; i < count; i++) {
        CGImageRef frame = CGImageSourceCreateImageAtIndex(gifSource,
                                                           i,
                                                           NULL);
        UIImage *image = [UIImage imageWithCGImage:frame];
        [imageFrames addObject:image];
        CGImageRelease(frame);
        
        NSDictionary *dic = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource,
                                                                                 i,
                                                                                 NULL));
        
        
        NSDictionary *gifDic =[dic valueForKey:(NSString *)kCGImagePropertyGIFDictionary];
        [delayTimes addObject:[gifDic objectForKey:(NSString *)kCGImagePropertyGIFDelayTime]];
        
    }
    
    NSDictionary *dic = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(gifSource,
                                                                             0,
                                                                             NULL));
    
    CGFloat gifWidth = (CGFloat)[[dic valueForKey:(NSString*)kCGImagePropertyPixelWidth]
                                 floatValue];
    
    CGFloat gifHeight = (CGFloat)[[dic valueForKey:(NSString*)kCGImagePropertyPixelHeight]
                                  floatValue];
    
    _frame = CGRectMake(0, 0, gifWidth, gifHeight);
    _imageFrames = imageFrames;
    _delayTimes = delayTimes;
}

@end
//
//  MTGifBrush.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/18.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTGifBrush.h"

#import <Foundation/Foundation.h>


@interface MTGifBrush ()

@property (nonatomic, strong, readwrite) NSMutableArray<MTGifAttribute *> *imagesourceArry;

@end


@implementation MTGifBrush


- (void)drawContext:(CGContextRef )ctx inRect:(CGRect )rect {
    if (!_imagesourceArry) {
        return;
    }
    
    for (int i = 0; i < _imagesourceArry.count; i ++) {
        
        MTGifAttribute *attr = [_imagesourceArry objectAtIndex:i];
        
        CGImageRef image =  (__bridge CGImageRef)[attr.imageFrames objectAtIndex:attr.index];
        UIView *view = attr.delegate;
        rect = attr.frame;
        CGFloat y = view.frame.size.height - rect.origin.y - rect.size.height;
        
        CGRect newRect = CGRectMake(rect.origin.x,
                                    y,
                                    rect.size.width,
                                    rect.size.height);
        CGContextDrawImage(ctx, newRect, image);
    }
}

- (NSMutableArray *)imagesourceArry{
    if (!_imagesourceArry) {
        _imagesourceArry = [[NSMutableArray alloc] init];
    }
    return _imagesourceArry;
}

- (void)addGif:(MTGifAttribute *)gif{
    [self.imagesourceArry addObject:gif];
}
@end


@implementation MTGifAttribute

- (instancetype)init{
    
    self = [super init];
    if (self) {
        _index = 0;
    }
    return self;
}

- (void)setImageInfoWithFilePath:(NSString *)path {
    
    
    NSURL *filrUrl = [NSURL fileURLWithPath:path];
    CFURLRef cfUrl = (__bridge CFURLRef)filrUrl;
    
    CGImageSourceRef gifSource = CGImageSourceCreateWithURL(cfUrl, NULL);
    [self setImageInfoWithCGImageSource:gifSource];
}

- (void)setImageInfoWithCGImageSource:(CGImageSourceRef)imageSource{
    
    NSMutableArray *imageFrames = [[NSMutableArray alloc] init];
    //NSMutableArray *properties = [[NSMutableArray alloc] init];
    NSMutableArray *delayTimes = [[NSMutableArray alloc] init];

    
    NSInteger count = CGImageSourceGetCount(imageSource);
    
    for (int i = 0; i < count; i++){
        CGImageRef frame = CGImageSourceCreateImageAtIndex(imageSource,
                                                           i,
                                                           NULL);
        
        [imageFrames addObject:(__bridge id)frame];
        CGImageRelease(frame);
        
        NSDictionary *dic = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imageSource,
                                                                                 i,
                                                                                 NULL));
        
        NSDictionary *gifDic =[dic valueForKey:(NSString *)kCGImagePropertyGIFDictionary];
        [delayTimes addObject:[gifDic objectForKey:(NSString *)kCGImagePropertyGIFDelayTime]];
        
    }
    
    NSDictionary *dic = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(imageSource,
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


- (void)startAnitation {
    [self changeImage];
}


- (void)changeImage {
    
    if ([self.delegate respondsToSelector:@selector(disPlayInRect:)]) {
        [self.delegate disPlayInRect:self.frame];
    }else{
    
        return;
    }

    _index ++;
    _index = _index % self.imageFrames.count;
    CGFloat delay = [[self.delayTimes objectAtIndex:_index] floatValue];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                       (int64_t)(delay * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
    
                           [self changeImage];
    
                       });
}

- (void)dealloc {
    self.delegate = NULL;
}

@end
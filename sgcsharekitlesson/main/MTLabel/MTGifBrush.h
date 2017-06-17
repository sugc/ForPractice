//
//  MTGifBrush.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/18.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <ImageIO/ImageIO.h>

@protocol MTGifProtocol <NSObject>

@required
- (void)disPlayInRect:(CGRect )rect;

@end

@interface MTGifAttribute : NSObject

@property (nonatomic, strong, readonly) NSArray *imageFrames;
@property (nonatomic, strong, readonly) NSArray *properties;
@property (nonatomic, strong, readonly) NSArray *delayTimes;

@property (nonatomic, weak, readwrite) UIView<MTGifProtocol> * delegate;
@property (nonatomic, assign, readwrite) CGRect frame;
//@property (nonatomic, copy) NSString *path;
@property (nonatomic, assign, readonly) NSInteger index;

- (void)setImageInfoWithFilePath:(NSString *)path;
- (void)setImageInfoWithCGImageSource:(CGImageSourceRef)imageSource;
- (void)startAnitation;

@end

@interface MTGifBrush : NSObject

@property (nonatomic, strong, readonly) NSMutableArray<MTGifAttribute *> *imagesourceArry;

- (void)drawContext:(CGContextRef )ctx inRect:(CGRect )rect;
- (CGImageRef )getImageInRect:(CGRect )rect;
- (void)addGif:(MTGifAttribute *)gif;
@end

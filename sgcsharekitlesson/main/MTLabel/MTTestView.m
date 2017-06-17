//
//  MTLabel.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/8.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTTestView.h"

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#import "MTLabelAttribute.h"
#import "UIView+Utils.h"
#import "MTCoreTextAttribute.h"
#import "MTGif.h"
#import "MTGifBrush.h"



typedef NS_ENUM(NSUInteger, MTLabelType) {
    MTLabelTypeUrl,
    MTLabelTypeEite,
    MTLabelTypeJ,
};

@interface MTTestView()<MTGifProtocol>{
    
    CTFrameRef _frameRef;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray *attributeArray;
@property (nonatomic, copy) NSMutableAttributedString *mString;
@property (nonatomic, strong) MTLabelAttribute *lastAttr;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, strong) MTGif *gif;
@property (nonatomic, strong) UIImageView *iview;
@property (nonatomic, strong) MTGifBrush *brush;


@end


@implementation MTTestView


- (instancetype)initWithText:(NSString *)text{
    
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        [self setText:text];
       
        _star = 0;
        
    }
    
    return self;
}

- (MTGifBrush *)brush{
    
    if (!_brush) {
        _brush = [[MTGifBrush alloc] init];
    }
    return  _brush;
}

- (void)disPlayInRect:(CGRect)rect{
//    CGRect rects = CGRectMake(, 0, 128, 128);
    [self setNeedsDisplayInRect:rect];
    
}

- (void)testGif {
    
    MTGifAttribute *attr = [[MTGifAttribute alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"gif"];
    [attr setImageInfoWithFilePath:path];
    attr.frame = CGRectMake(0, 0, 128, 128);
    attr.delegate = self;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:attr];
    
//    self.brush.imagesourceArry = array;
    [attr startAnitation];
    
    
}

- (void)didMoveToWindow{
    
    [super didMoveToWindow];
    
    [self testGif ];
    
    
}
- (void)setText:(NSString *)text{
    
    _text = text;
    
}


- (void)drawRect:(CGRect)rect{
    
//    [self drawLabel];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    UIImage *image = [UIImage imageNamed:@"effect0.png"];
    
    CGContextDrawImage(context, rect, image.CGImage);
    
    
    [self.brush drawContext:context inRect:rect];
}


@end

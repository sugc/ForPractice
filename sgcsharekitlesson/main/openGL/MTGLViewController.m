//
//  MTGLViewController.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/14.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTGLViewController.h"

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface MTGLViewController () <GLKViewDelegate>{

    
    
}

@property (nonatomic, strong) EAGLContext *context;
@property (nonatomic, strong) GLKBaseEffect *effect;

@end

GLfloat vertices[] = {
    -1, -1,//左下
    1, -1,//右下
    1, 1,//右上
    -1, 1,//左上
    
};

//static const GLfloat texCoords[] = {
//    0.0, 1.0,
//    1.0, 1.0,
//    0.0, 0.0,
//    1.0, 0.0
//};

@implementation MTGLViewController

- (void)viewDidLoad{
    
    
    [super viewDidLoad];
    [self initOpenGLView];
}


- (void)initOpenGLView{
    
    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    
    if (!_context) {
        NSLog(@"faild to create ES context");
    }
    
    GLKView *kView = (GLKView *)self.view;
    kView.context = _context;
    kView.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:_context];
    glEnable(GL_DEPTH_TEST);
    glEnable(GL_TEXTURE_2D);
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_SRC_COLOR);
    glClearColor(0.1, 0.2, 0.3, 1);
    
}

- (BOOL)prefersStatusBarHidden{

    return YES;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect{

    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //清除缓存为何颜色会发生改变
    
    self.effect = [[GLKBaseEffect alloc] init];
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 2, GL_FLOAT, GL_FALSE, 0, vertices);
    
    
    
    CGImageRef textureImage = [UIImage imageNamed:@"2.png"].CGImage;
    if (textureImage == nil) {
        NSLog(@"textture image is nil");
    }
    
    NSInteger textWidth = CGImageGetWidth(textureImage);
    NSInteger textHeight = CGImageGetHeight(textureImage);
    GLubyte *textData = (GLubyte *)malloc(textWidth * textHeight * 4);
    CGContextRef textureContext = CGBitmapContextCreate(textData,
                                                         textWidth,
                                                         textHeight,
                                                         8,
                                                         textWidth * 4,
                                                         CGImageGetColorSpace(textureImage),
                                                         kCGImageAlphaPremultipliedLast);
    
    CGContextDrawImage(textureContext,
                       CGRectMake(0, 0, textWidth, textHeight),
                       textureImage);
    GLuint texture[1];
    glGenTextures(1, &texture[0]);
    glBindTexture(GL_TEXTURE_2D, texture[0]);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    glTexImage2D(GL_TEXTURE_2D,
                 0,
                 GL_RGB,
                 textWidth,
                 textHeight,
                 0,
                 GL_RGB,
                 GL_UNSIGNED_BYTE,
                 textData);
    
    CGContextRelease(textureContext);
    
    glActiveTexture(GL_TEXTURE5);
   
    
    
    [self.effect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 4);

    glDisableVertexAttribArray(GLKVertexAttribPosition);
    
}

@end
//
//  MTPaintView.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/19.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTGrayFilterView.h"

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>
#import <GLKit/GLKit.h>
#import <OpenGLES/EAGL.h>
#import <AVFoundation/AVFoundation.h>

#import "MTShaderOperations.h"
#import "UIView+Utils.h"


@interface MTGrayFilterView (){
    
    EAGLContext *_eaglContext;
    CAEAGLLayer *_eaglLayer;
    GLuint _renderBuffer;
    GLuint _frameBuffer;
    GLuint _textureID;
    GLuint _program;
    
    GLuint _positionSlot;
    GLuint _textureSlot;
    GLuint _textureCoordsSlot;
    GLuint _textureSlotMask;
    GLuint _textureCoordsSlotMask;
    
    GLuint _paintPositionSlot;
    GLuint _paintColorSlot;
    
    
}

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGPoint middlePoint;
@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, strong) NSMutableArray *points;


@end


@implementation MTGrayFilterView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.multipleTouchEnabled = YES;
        [self becomeFirstResponder];
        [self setupOpenGL];
        [self setPaintShader];
        
    }
    
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch * t in touches) {
        CGPoint point = [t locationInView:self];
        _startPoint = _middlePoint = _endPoint = point;
        NSArray * array = [MTShaderOperations createBezierWithStartPoint:_startPoint
                                                          andMiddlePoint:_middlePoint
                                                             andEndPoint:_endPoint];
        [self drawArray:array];

    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    for (UITouch * t in touches) {
        CGPoint point = [t locationInView:self];
        _startPoint = _middlePoint;
        _middlePoint = _endPoint;
        _endPoint = point;
    }
    
    if (!CGPointEqualToPoint(_startPoint,CGPointZero)) {
        NSArray * array = [MTShaderOperations createBezierWithStartPoint:_startPoint
                                                          andMiddlePoint:_middlePoint
                                                             andEndPoint:_endPoint];
        [self drawArray:array];
    }

    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
        for (UITouch * t in touches) {
            CGPoint point = [t locationInView:self];
            _startPoint = _middlePoint;
            _middlePoint = _endPoint;
            _endPoint = point;
            if (!CGPointEqualToPoint(_startPoint,CGPointZero)) {
                NSArray * array = [MTShaderOperations createBezierWithStartPoint:_startPoint
                                                                  andMiddlePoint:_middlePoint
                                                                    andEndPoint:_endPoint];
                [self drawArray:array];
            }
        }
    
    _startPoint = _middlePoint = _endPoint = CGPointZero;
    
}

- (void)drawArray:(NSArray *) array{
    
        [self drawCGPointsViaOpenGLES:array inFrame:self.frame];
    
}

//*********************init openGL ES**************************************/

- (void)setupOpenGL{
    
    glEnableClientState(GL_VERTEX_ARRAY);
    [self setupContext];
    [self setupEaglLayer];
    [self deleteBuffers];
    [self setupBuffers];
    glClearColor(0.1f, 0.1f, 0.7f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    [self setTexture];
    [self render];
    
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
    
}



- (void)setupContext{
    
    _eaglContext = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    [EAGLContext setCurrentContext:_eaglContext];
    
}

- (void)setupEaglLayer{
    
    _eaglLayer = [CAEAGLLayer layer];
    _eaglLayer.frame = self.frame;
    _eaglLayer.opaque = YES;
    _eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:NO],kEAGLDrawablePropertyRetainedBacking,kEAGLColorFormatRGBA8,kEAGLDrawablePropertyColorFormat, nil];
    [self.layer addSublayer:_eaglLayer];
    
}

- (void)setupBuffers{
    
    glGenRenderbuffers(1, &_renderBuffer);
    glBindRenderbuffer(GL_RENDERBUFFER, _renderBuffer);
    [_eaglContext renderbufferStorage:GL_RENDERBUFFER fromDrawable:_eaglLayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    glFramebufferRenderbuffer(GL_FRAMEBUFFER,
                              GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER,
                              _renderBuffer);
    
}

- (void)setTexture{
    
    _program = [MTShaderOperations compileShaders:@"MTImageVertex"
                                   shaderFragment:@"MTImageFragment"];
    glUseProgram(_program);
    _positionSlot = glGetAttribLocation(_program, "Position");
    _textureSlot = glGetUniformLocation(_program, "Texture");
    _textureCoordsSlot = glGetAttribLocation(_program, "TextureCoords");
    
    
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    _textureID = [MTShaderOperations createTextureWithImage:image];
    
    
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    glUniform1i(_textureSlot, 5);
    
    
    
}

- (void)render{
    
    
    
    const GLfloat vertices[] = {
        -1, -1, 0,   //左下
        1,  -1, 0,   //右下
        -1, 1,  0,   //左上
        1,  1,  0 }; //右上
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);
    
    const GLfloat texCoords[] = {
        0, 0,//左下
        1, 0,//右下
        0, 1,//左上
        1, 1,//右上
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    const GLubyte indices[] = {
        0,1,2,
        1,2,3
    };
    
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, indices);
    [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)deleteBuffers{
    
    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    
    if (_renderBuffer) {
        glDeleteRenderbuffers(1, &_renderBuffer);
        _renderBuffer = 0;
    }
    
}

- (void)setupPaintOpenGL{
    
    
    [self setPaintShader];
}

- (void)setPaintShader{
    
    
//    UIImage *imageMask = [UIImage imageNamed:@"Radial.png"];
//    GLuint _textureIDMask = [MTShaderOperations createTextureWithImage:imageMask];
    
    _program = [MTShaderOperations compileShaders:@"MTGrayfilterVertex"
                                   shaderFragment:@"MTGrayFilterFragment"];
    
    glUseProgram(_program);
    _positionSlot = glGetAttribLocation(_program, "Position");
    _textureSlot = glGetUniformLocation(_program, "Texture");
    _textureCoordsSlot = glGetAttribLocation(_program, "TextureCoords");
    
    glActiveTexture(GL_TEXTURE5);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    glUniform1i(_textureSlot, 5);

    
}

//*************************************************************************/

- (void)drawCGPointsViaOpenGLES:(NSArray *)points inFrame:(CGRect)rect {
    
    
    
    CGFloat lineWidth = 5.0;
    
    for (NSValue *value in points) {
        CGPoint point = value.CGPointValue;
        GLfloat vertices[] = {
            -1 + 2 * (point.x - lineWidth) / rect.size.width, 1 - 2 * (point.y + lineWidth) / rect.size.height, 0.0f, // 左下
            -1 + 2 * (point.x + lineWidth) / rect.size.width, 1 - 2 * (point.y + lineWidth) / rect.size.height, 0.0f, // 右下
            -1 + 2 * (point.x - lineWidth) / rect.size.width, 1 - 2 * (point.y - lineWidth) / rect.size.height, 0.0f, // 左上
            -1 + 2 * (point.x + lineWidth) / rect.size.width, 1 - 2 * (point.y - lineWidth) / rect.size.height, 0.0f }; //右上
        
        
        //计算纹理坐标
        GLfloat texCoords[] = {
            (vertices[0] + 1) * 0.5, (vertices[1] + 1) * 0.5,//左下
            (vertices[3] + 1) * 0.5, (vertices[4] + 1) * 0.5,//右下
            (vertices[6] + 1) * 0.5, (vertices[7] + 1) * 0.5,//左上
            (vertices[9] + 1) * 0.5, (vertices[10] + 1) * 0.5,//右上
        };
        glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
        glEnableVertexAttribArray(_textureCoordsSlot);

        
        
        const GLubyte indices[] = {
            0, 1, 2, // 三角形0
            1, 2, 3  // 三角形1
        };
        
        glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
        glEnableVertexAttribArray(_positionSlot);
        
        
        glDrawElements(GL_TRIANGLE_STRIP, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, indices);

    }
   
   

       [_eaglContext presentRenderbuffer:GL_RENDERBUFFER];
    

}


- (UIImage *)createSubImageWithImage:(UIImage *)image andRectInFrame:(CGRect) rect{
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    
    CGFloat x = rect.origin.x / MTScreenWidth * imageWidth;
    CGFloat y = rect.origin.y / MTScreenHeight *imageHeight;
    CGFloat width = rect.size.width / MTScreenWidth * imageWidth;
    CGFloat height = rect.size.width / MTScreenHeight *imageHeight;
    
    CGRect cutFrame = CGRectMake(x, y, width, height);
    CGImageRef cgImageRef = image.CGImage;
    CGImageRef newImage = CGImageCreateWithImageInRect(cgImageRef, cutFrame);
    UIImage *returnImage = [UIImage imageWithCGImage:newImage];
    CGImageRelease(newImage);
    return returnImage;
}

@end






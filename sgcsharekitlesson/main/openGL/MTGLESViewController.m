//
//  MTGLESViewcontroller.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/18.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTGLESViewController.h"

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>


@interface MTGLESViewController (){

    EAGLContext *_context;
    CAEAGLLayer *_EALayer;
    GLuint _colorBufferRender;
    GLuint _frameBuffer;
    GLuint _glProgram;
    GLuint _positionSlot;
    GLuint _textureSlot;
    GLuint _textureCoordsSlot;
    GLuint _textureID;
    CGRect _frameCAEAGLLayer;
    
}

@end


@implementation MTGLESViewController


- (void)viewDidLoad{
    [super viewDidLoad];
    [self setupContext];
    [self setupEAGLLayer];
    
//    [self deleteBuffer];
    [self setupBuffer];
    glClearColor(0.5f, 0.5f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    glViewport(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [_context presentRenderbuffer:GL_RENDERBUFFER];
    
    //去除注释画出图片  panitViewController可以涂抹
//    [self compileShader];
//    [self setupTexture];

}

- (void)setupContext{

    _context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    if (!_context) {
        NSLog(@"init context erro");
    }
    
    [EAGLContext setCurrentContext:_context];
}

- (void)setupEAGLLayer{
    
    _EALayer = [CAEAGLLayer layer];
    _EALayer.frame = self.view.frame;
    _EALayer.opaque = YES;
    
    _EALayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithBool:NO],
                                   kEAGLDrawablePropertyRetainedBacking,
                                   kEAGLColorFormatRGBA8,
                                   kEAGLDrawablePropertyColorFormat,
                                   nil];
    [self.view.layer addSublayer:_EALayer];
    glEnable(GL_BLEND);
    glBlendFunc(GL_ONE, GL_ZERO);
}
- (void)deleteBuffer{
    
    if (_colorBufferRender) {
        glDeleteRenderbuffers(1, &_colorBufferRender);
        _colorBufferRender = 0;
    }


    if (_frameBuffer) {
        glDeleteFramebuffers(1, &_frameBuffer);
        _frameBuffer = 0;
    }
    
}

- (void)setupBuffer{
    
    glGenRenderbuffers(1, &_colorBufferRender);
    glBindRenderbuffer(GL_RENDERBUFFER, _colorBufferRender);
    [_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:_EALayer];
    
    glGenFramebuffers(1, &_frameBuffer);
    glBindFramebuffer(GL_FRAMEBUFFER, _frameBuffer);
    
    glFramebufferRenderbuffer(GL_FRAMEBUFFER,
                              GL_COLOR_ATTACHMENT0,
                              GL_RENDERBUFFER,
                              _colorBufferRender);
}

- (void)processShader{

    

}

- (void)compileShader{
    
    GLuint vertexShader= [self compileShader:@"MTShaderVertex" withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [self compileShader:@"MTShaderFragment"
                                       withType:GL_FRAGMENT_SHADER];
    _glProgram = glCreateProgram();
    glAttachShader(_glProgram, vertexShader);
    glAttachShader(_glProgram, fragmentShader);
    glLinkProgram(_glProgram);
    glUseProgram(_glProgram);
    
    _positionSlot = glGetAttribLocation(_glProgram, "Position");
    _textureSlot = glGetUniformLocation(_glProgram, "Texture");
    _textureCoordsSlot = glGetAttribLocation(_glProgram, "TextureCoords");
    
    
}

- (GLuint)compileShader:(NSString *)shaderName withType:(GLenum)type{
    
    NSString *shaderPath = [[NSBundle mainBundle] pathForResource:shaderName
                                                           ofType:@"glsl"];
    NSError *erro;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderPath
                                                       encoding:NSUTF8StringEncoding
                                                          error:&erro];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", erro.localizedDescription);
        exit(1);
    }

    int stringLength = (int)[shaderString length];
    const char *shaderStringUtf8 = [shaderString UTF8String];
    GLuint shaderHandle = glCreateShader(type);
    glShaderSource(shaderHandle, 1, &shaderStringUtf8,&stringLength);
    glCompileShader(shaderHandle);
    
    GLint compileSuccess;
    glGetShaderiv(shaderHandle, GL_COMPILE_STATUS, &compileSuccess);
    if (compileSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetShaderInfoLog(shaderHandle, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }

    
    return shaderHandle;
}


- (void)render{
    
    
    const GLfloat texCoords[] = {
        0, 0,//左下
        1, 0,//右下
        0, 1,//左上
        1, 1,//右上
    };
    glVertexAttribPointer(_textureCoordsSlot, 2, GL_FLOAT, GL_FALSE, 0, texCoords);
    glEnableVertexAttribArray(_textureCoordsSlot);
    
    
    const GLfloat vertices[] = {
        -1, -1, 0,   //左下
        1,  -1, 0,   //右下
        -1, 1,  0,   //左上
        1,  1,  0 }; //右上
    
    glVertexAttribPointer(_positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(_positionSlot);

   
    
    const GLubyte indices[] = {
        0,1,2,
        1,2,3
    };
    
    glDrawElements(GL_TRIANGLES, sizeof(indices)/sizeof(indices[0]), GL_UNSIGNED_BYTE, indices);

    [_context presentRenderbuffer:GL_RENDERBUFFER];
}

- (void)setupTexture{
    UIImage *image = [UIImage imageNamed:@"1.jpg"];
    _textureID = [self setupTexture:image];
    
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
//    
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
//    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);

    
    glActiveTexture(GL_TEXTURE3);
    glBindTexture(GL_TEXTURE_2D, _textureID);
    glUniform1i(_textureSlot, 3);
    [self render];
    
    
}

- (GLuint)setupTexture:(UIImage *)image {
    CGImageRef cgImageRef = [image CGImage];
    GLuint width = (GLuint)CGImageGetWidth(cgImageRef);
    GLuint height = (GLuint)CGImageGetHeight(cgImageRef);
    CGRect rect = CGRectMake(0, 0, width, height);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    void *imageData = malloc(width * height * 4);
    CGContextRef context = CGBitmapContextCreate(imageData, width, height, 8, width * 4, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGContextTranslateCTM(context, 0, height);
    CGContextScaleCTM(context, 1.0f, -1.0f);
    CGColorSpaceRelease(colorSpace);
    CGContextClearRect(context, rect);
    CGContextDrawImage(context, rect, cgImageRef);
    
    glEnable(GL_TEXTURE_2D);
    
    GLuint textureID;
    glGenTextures(1, &textureID);
    glBindTexture(GL_TEXTURE_2D, textureID);
    
   
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
    
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR);
    
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, imageData);
    
    CGContextRelease(context);
    free(imageData);
    
    return textureID;
}




@end

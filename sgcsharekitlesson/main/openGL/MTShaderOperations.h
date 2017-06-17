//
//  ShaderOperations.h
//  OpenGLDemo
//
//  Created by Chris Hu on 15/7/30.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/gl.h>
#import <OpenGLES/ES2/glext.h>

@interface MTShaderOperations : NSObject

+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType;

+ (GLuint)compileShaders:(NSString *)shaderVertex shaderFragment:(NSString *)shaderFragment;

+ (GLuint)createTextureWithImage:(UIImage *)image;

+ (NSArray *)createBezierWithPreviosPoint:(CGPoint)previous andCurrentPoint:(CGPoint) current;

+ (NSArray *)createBezierWithStartPoint:(CGPoint) star
                         andMiddlePoint:(CGPoint) middle
                            andEndPoint:(CGPoint) end;
@end

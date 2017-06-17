//
//  ShaderOperations.m
//  OpenGLDemo
//
//  Created by Chris Hu on 15/7/30.
//  Copyright (c) 2015年 Chris Hu. All rights reserved.
//

#import "MTShaderOperations.h"


@interface MTShaderOperations ()


@end



@implementation MTShaderOperations


+ (GLuint)compileShader:(NSString*)shaderName withType:(GLenum)shaderType {
    // 1 查找shader文件
    NSString* shaderPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"glsl"];
    NSError* error;
    NSString* shaderString = [NSString stringWithContentsOfFile:shaderPath encoding:NSUTF8StringEncoding error:&error];
    if (!shaderString) {
        NSLog(@"Error loading shader: %@", error.localizedDescription);
        exit(1);
    }
    
    // 2 创建一个代表shader的OpenGL对象, 指定vertex或fragment shader
    GLuint shaderHandle = glCreateShader(shaderType);
    
    // 3 获取shader的source
    const char* shaderStringUTF8 = [shaderString UTF8String];
    int shaderStringLength = (int)[shaderString length];
    glShaderSource(shaderHandle, 1, &shaderStringUTF8, &shaderStringLength);
    
    // 4 编译shader
    glCompileShader(shaderHandle);
    
    // 5 查询shader对象的信息
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

+ (GLuint)compileShaders:(NSString *)shaderVertex shaderFragment:(NSString *)shaderFragment {
    // 1 vertex和fragment两个shader都要编译
    GLuint vertexShader = [MTShaderOperations compileShader:shaderVertex withType:GL_VERTEX_SHADER];
    GLuint fragmentShader = [MTShaderOperations compileShader:shaderFragment withType:GL_FRAGMENT_SHADER];
    
    // 2 连接vertex和fragment shader成一个完整的program
    GLuint _glProgram = glCreateProgram();
    glAttachShader(_glProgram, vertexShader);
    glAttachShader(_glProgram, fragmentShader);
    
    // link program
    glLinkProgram(_glProgram);
    
    // 3 check link status
    GLint linkSuccess;
    glGetProgramiv(_glProgram, GL_LINK_STATUS, &linkSuccess);
    if (linkSuccess == GL_FALSE) {
        GLchar messages[256];
        glGetProgramInfoLog(_glProgram, sizeof(messages), 0, &messages[0]);
        NSString *messageString = [NSString stringWithUTF8String:messages];
        NSLog(@"%@", messageString);
        exit(1);
    }
    return _glProgram;
}

+ (GLuint)createTextureWithImage:(UIImage *)image{

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
    
    
    glBindTexture(GL_TEXTURE_2D, 0);
    CGContextRelease(context);
    free(imageData);
    
    return textureID;

}

+ (NSArray *)createBezierWithPreviosPoint:(CGPoint)previous andCurrentPoint:(CGPoint) current{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    float t = pow((pow(current.x - previous.x,2) + pow(current.y - previous.y,2)), 0.5);
    float add = 1 / t ;
        for (float i = 0; i < 1; i += add ) {
    
            float x = previous.x + (current.x - previous.x) * i;
            float y = previous.y + (current.y - previous.y) * i;
            CGPoint addPoint = CGPointMake(x, y);
            [array addObject:[NSValue valueWithCGPoint:addPoint]];
        }
    
    [array addObject:[NSValue valueWithCGPoint:current]];
    return array;
}

+ (NSArray *)createBezierWithStartPoint:(CGPoint) star
                         andMiddlePoint:(CGPoint) middle
                            andEndPoint:(CGPoint) end{
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    [array addObject:[NSValue valueWithCGPoint:star]];
    float t = pow(pow(middle.x - star.x, 2) + pow(middle.y - star.y, 2) +
                  pow(end.x - middle.x, 2) + pow(end.y - middle.y, 2) , 0.5);
    if (t > 0) {
        float add = (float)1 / t;
        
        for (float i = 0; i <= 1; i += add ) {
            
            float x = pow((1 - i), 2) * star.x + 2 * i *(1 - i) * middle.x + pow(i, 2) * end.x;
            float y = pow((1 - i), 2) * star.y + 2 * i *(1 - i) * middle.y + pow(i, 2) * end.y;
            CGPoint addPoint = CGPointMake(x, y);
            [array addObject:[NSValue valueWithCGPoint:addPoint]];
        }

    }
    
    return array;
}

@end

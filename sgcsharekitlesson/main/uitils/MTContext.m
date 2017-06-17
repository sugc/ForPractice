//
//  MTContext.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/28.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTContext.h"

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>

static ALAssetsGroup *sharedGroup;
static MTContext *shareContext;
@interface MTContext ()


@end

@implementation MTContext

+ (MTContext *)shareContext{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareContext = [[MTContext alloc] init];
        
    });
    return shareContext;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initConfiguration];
    }
    return self;
}

- (void)initConfiguration{
    
    ALAssetsLibrary *lib = [[ALAssetsLibrary alloc] init];
    __block BOOL isHaveAlbum = false;
    [lib enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop){
        if ([[group valueForProperty:ALAssetsGroupPropertyName] isEqualToString:@"sgcTest"]) {
            sharedGroup = group;
            isHaveAlbum = YES;
        }
        if (group == nil) {
            if (!isHaveAlbum) {
                [lib addAssetsGroupAlbumWithName:@"sgcTest" resultBlock:^(ALAssetsGroup *group){
                    sharedGroup = group;
                } failureBlock:^(NSError *erro){
                    
                }];
                
            }
            
        }
    } failureBlock:^(NSError *erro){
        
        
    }];
    
}

- (ALAssetsGroup *)shareGroup{
    
    return sharedGroup;
}

@end
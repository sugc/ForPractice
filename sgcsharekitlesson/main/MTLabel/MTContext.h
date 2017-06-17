//
//  MTContext.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/7/28.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ALAssetsGroup;

@interface MTContext : NSObject

+ (MTContext *)shareContext;
- (ALAssetsGroup *)shareGroup;
@end

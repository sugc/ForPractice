//
//  MTLabelAttribute.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/8.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import<Foundation/Foundation.h>

#import "MTCoreTextAttribute.h"

@interface MTLabelAttribute : NSObject<NSCopying>

- (BOOL)isInRang:(NSRange)range;

@property (nonatomic, copy) NSString *type;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) NSRange range;
@property (nonatomic, strong) MTCoreTextAttribute *normalAttribute;
@property (nonatomic, strong) MTCoreTextAttribute *hightlightAttribute;
@property (nonatomic, assign) BOOL isAddImage;
@property (nonatomic, assign) BOOL isAddGif;
@property (nonatomic, assign) BOOL isReplaced;

@end

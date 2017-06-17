//
//  MTLabelDemo.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/9.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTLabelDemo.h"

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#import "MTLabel.h"
#import "MTCoreTextAttribute.h"
#import "UIView+Utils.h"
#import "MTLabelAttribute.h"
#import "MTTestView.h"
#import "MTGifBrush.h"

@interface MTLabelDemo ()<MTLabelDelegate>

@property (nonatomic, strong) MTLabel *label;
@property (nonatomic, strong) UIButton *backBtn;

@end


@implementation MTLabelDemo

- (void)viewDidLoad {

    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    [self.view addSubview:self.backBtn];
    self.label.backgroundColor = [UIColor whiteColor];
    [self setAttribute];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (MTLabel *)label {

    if (!_label) {
        _label = [[MTLabel alloc] init];
        _label.frame = CGRectMake(0, 64, MTScreenWidth, MTScreenHeight - 64 );
        [_label setText:@"@umomo ewqeewqeq   1234weqweeqweqwe   @heheda #dasadwqecfdasdEW😢jSA#^^*# http://sdar"];
        _label.delegate = self;
    }
    
    return _label;
}

- (void)setAttribute {
    NSMutableDictionary *attributeDic = [[NSMutableDictionary alloc] init];
    

    {
        MTCoreTextAttribute *attributeNormal1 = [[MTCoreTextAttribute alloc] init];
        MTLabelAttribute *attribute1 = [[MTLabelAttribute alloc] init];
        attribute1.type = @"@[^ ]+ ";
    
        [attributeNormal1 setColor:[UIColor blueColor]];
        [attributeNormal1 setFont:[UIFont italicSystemFontOfSize:40]];
        MTCoreTextAttribute *attributeHightlight1 = [[MTCoreTextAttribute alloc] init];

        [attributeHightlight1 setColor:[UIColor grayColor]];
        [attributeHightlight1 setFont:[UIFont italicSystemFontOfSize:40]];
        
        attribute1.normalAttribute = attributeNormal1;
        attribute1.hightlightAttribute = attributeHightlight1;
        [attributeDic setObject:attribute1 forKey:@"@[^ ]+ "];
    }
    
    {
        MTCoreTextAttribute *attributeNormal2 = [[MTCoreTextAttribute alloc] init];
        MTLabelAttribute *attribute2 = [[MTLabelAttribute alloc] init];
        attribute2.type = @"#.+#";
        
        [attributeNormal2 setColor:[UIColor redColor]];
        [attributeNormal2 setFont:[UIFont italicSystemFontOfSize:30]];
        MTCoreTextAttribute *attributeHightlight2 = [[MTCoreTextAttribute alloc] init];
        [attributeHightlight2 setColor:[UIColor greenColor]];
        [attributeHightlight2 setFont:[UIFont italicSystemFontOfSize:30]];
        
        attribute2.normalAttribute = attributeNormal2;
        attribute2.hightlightAttribute = attributeHightlight2;
        [attributeDic setObject:attribute2 forKey:@"#.+#"];
        
    }
    
    {
        MTCoreTextAttribute *attributeNormal3 = [[MTCoreTextAttribute alloc] init];
        MTLabelAttribute *attribute3 = [[MTLabelAttribute alloc] init];
        attribute3.type = @"http://[^ ]+";
        attribute3.isAddImage = YES;
        attribute3.isReplaced = YES;
        [attributeNormal3 setColor:[UIColor greenColor]];
        [attributeNormal3 setFont:[UIFont italicSystemFontOfSize:30]];
        MTCoreTextAttribute *attributeHightlight3 = [[MTCoreTextAttribute alloc] init];
        [attributeHightlight3 setColor:[UIColor redColor]];
        [attributeHightlight3 setFont:[UIFont italicSystemFontOfSize:30]];
        
        attribute3.normalAttribute = attributeNormal3;
        attribute3.hightlightAttribute = attributeHightlight3;
        [attributeDic setObject:attribute3 forKey:@"http://[^ ]+"];
    }
    
    {
        MTCoreTextAttribute *attributeNormal4 = [[MTCoreTextAttribute alloc] init];
        MTLabelAttribute *attribute4 = [[MTLabelAttribute alloc] init];
        attribute4.type = @"1234";
        attribute4.isAddGif = YES;
        attribute4.isReplaced = YES;
        [attributeNormal4 setColor:[UIColor greenColor]];
        [attributeNormal4 setFont:[UIFont italicSystemFontOfSize:30]];
        MTCoreTextAttribute *attributeHightlight4 = [[MTCoreTextAttribute alloc] init];
        [attributeHightlight4 setColor:[UIColor blueColor]];
        [attributeHightlight4 setFont:[UIFont italicSystemFontOfSize:30]];
        
        attribute4.normalAttribute = attributeNormal4;
        attribute4.hightlightAttribute = attributeHightlight4;
        [attributeDic setObject:attribute4 forKey:@"1234"];
    }

    self.label.attributeDic = attributeDic;
    self.label->RunDelegateDeallocCallback = RunDelegateDeallocCallback;
    self.label->RunDelegateGetAsent = getAsent;
    self.label->RunDelegateGetDescent = getDescent;
    self.label->RunDelegateGetWidthCallBack = RunDelegateGetWidth;
}

- (void)clickWithAttibute:(MTLabelAttribute *)range andText:(NSString *)text {

    NSLog(@"%@",text);
}

- (UIImage *)getImageWithText:(NSString *) text{
    
    UIImage *image = [UIImage imageNamed:@"pia.png"];
    return image;
}

- (MTGifAttribute *)getGifAttributeWithString:(NSString *)string{
    
    MTGifAttribute *gif = [[MTGifAttribute alloc] init];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test1" ofType:@"gif"];
    [gif setImageInfoWithFilePath:path];
    
    return gif;
}

void RunDelegateDeallocCallback(void *refCon) {
    
}

CGFloat getAsent(void *refCon) {
    
//    NSString *imageName = (__bridge NSString *)(refCon);
//    NSString *imageName = @"test.gif";
//    return [UIImage imageNamed:imageName].size.height;
    return 100;

}

CGFloat getDescent(void *refCon) {
    
    return 0;
}

CGFloat RunDelegateGetWidth(void *refCon) {
    
//    NSString *imageName = (__bridge NSString *)(refCon);
//    NSString *imageName = @"test.gif";
//    return [UIImage imageNamed:imageName].size.width;
    return 100;
}

- (UIButton *)backBtn {
    
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        _backBtn.frame = CGRectMake(5, 24, 50, 30);
        [_backBtn setTitle:@"返回" forState:UIControlStateNormal];
        [_backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_backBtn addTarget:self
                     action:@selector(goBack)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (void)goBack{
    
    [self dismissViewControllerAnimated:NO completion:^(void){
        
    }];
    
}



@end
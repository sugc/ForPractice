//
//  MTLabel.h
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/8.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MTLabelAttribute;

@protocol MTLabelDelegate <NSObject>

@optional

- (void)clickWithAttibute:(MTLabelAttribute *)range andText:(NSString *)text;

- (UIImage *)getImageWithText:(NSString *) text;

@end

@interface MTTestView : UIView {
    
    // set CTRun Delegate method
@public void (*RunDelegateDeallocCallback) (void * refCon );
@public CGFloat (*RunDelegateGetAsent) (void *refCon);
@public CGFloat (*RunDelegateGetDescent) (void *refCon);
@public CGFloat (*RunDelegateGetWidthCallBack) (void *refCon);
    
}

// recognize an url if is on
@property (nonatomic, assign) BOOL isURLRecognitionOn;

// recognize a phone number if is on
@property (nonatomic, assign) BOOL isPhonenumberRecognitionOn;

// recognize an sentence with prefix @ if is on
@property (nonatomic, assign) BOOL isRollCallRecognitionOn;

// set regular expression here
@property (nonatomic, strong) NSMutableDictionary<NSString *, MTLabelAttribute *> *attributeDic;
@property (nonatomic, assign) id<MTLabelDelegate> delegate;

- (instancetype)initWithText:(NSString *)text;
- (void)setText:(NSString *)text;

@end
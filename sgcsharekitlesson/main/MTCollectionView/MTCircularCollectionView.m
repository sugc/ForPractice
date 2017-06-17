//
//  MTCollectionView.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/26.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//

#import "MTCircularCollectionView.h"

#import "UIView+Utils.h"

@interface MTCircularCollectionView ()

@property (nonatomic, assign) BOOL isRotation;
@property (nonatomic, assign) CGPoint lastPoint;
@property (nonatomic, assign) CGPoint currentPoint;
@property (nonatomic, assign) NSTimeInterval lastTime;
@property (nonatomic, assign) NSTimeInterval currentTime;
@property (nonatomic, assign) CGFloat transAngle;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end


@implementation MTCircularCollectionView


- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout {
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.angle = 0;
    }
    return self;
}
static int count = 0;
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    _currentPoint = [[touches anyObject] locationInView:self];
    _currentTime = [touches anyObject].timestamp;
    
    [self setIsRotationWithPoint:_currentPoint];
    if (touches.count > 1) {
        _isRotation = NO;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    if (_isRotation) {
        _lastPoint = _currentPoint;
        _currentPoint = [[touches anyObject] locationInView:self];
        _lastTime = _currentTime;
        _currentTime = [touches anyObject].timestamp;
        CGFloat transAngle = [self transAngle];
        
        _angle = _angle + transAngle;
        [self.collectionViewLayout invalidateLayout];
       
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    if (_isRotation) {
        _lastPoint = _currentPoint;
        _currentPoint = [[touches anyObject] locationInView:self];
        _lastTime = _currentTime;
        _currentTime = [touches anyObject].timestamp;
        CGFloat transAngle = [self transAngle];
        
        _angle = _angle + transAngle;
        [self.collectionViewLayout invalidateLayout];
        [self scroll];
        
    }
    
}

- (void)setIsRotationWithPoint:(CGPoint)point {
    
    CGFloat distanceX = point.x - self.radius;
    CGFloat distanceY = point.y - self.radius;
    
    CGFloat distance = pow((pow(distanceX, 2) + pow(distanceY, 2)), 0.5);
    
    if (distance > (self.radius - 2 * self.cellRadius)
        &&distance < self.radius) {
        _isRotation = YES;
    }else{
        _isRotation = NO;
    }
}

- (CGFloat)transAngle {
    
    //atan2
    CGPoint newCurrent = CGPointMake(_currentPoint.x - _radius, _radius - _currentPoint.y);
    CGPoint newLast = CGPointMake(_lastPoint.x - _radius, _radius - _lastPoint.y);
    
    CGFloat atanCurrent = atan2(newCurrent.y, newCurrent.x);
    CGFloat atanLast = atan2(newLast.y, newLast.x);
    
    _transAngle =  -(atanCurrent - atanLast);
    if (isnan(_transAngle)) {
        _transAngle = 0;
        return _transAngle ;
    }
    if (fabs(_transAngle) > M_PI) {
        _transAngle = (-_transAngle / fabs(_transAngle)) *( M_PI * 2 - fabs(_transAngle));
       
    }
    
    
    NSLog(@"%f",_transAngle);
    return  _transAngle;
    
}


CGFloat static decrement = 0.125;
NSInteger static repeatTimes;
CGFloat static speed ;
- (void)scroll {
    NSTimeInterval time = _currentTime - _lastTime;
    speed = _transAngle / time;
    repeatTimes = fabs(speed) / decrement;
    NSLog(@"transAngle%f",_transAngle);
    time = 0.05 / fabs(speed);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self scrollWithTimer:time];
    });
}

- (void)scrollWithTimer:(NSTimeInterval )timer{
    
    if (repeatTimes <= 0) {
        return;
    }
    NSTimeInterval time = 0.05 / fabs(speed);
    speed -= (fabs(speed) / speed) * decrement;
    _angle = _angle + (fabs(speed) / speed) * 0.05 ;
    repeatTimes --;
    [self.collectionViewLayout invalidateLayout];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [self scrollWithTimer:timer];
                });
}

- (void)rotationWithAngle:(CGFloat)angle {
       
}



@end


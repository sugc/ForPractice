//
//  MTLabel.m
//  sgcsharekitlesson
//
//  Created by zj－db0548 on 16/8/8.
//  Copyright © 2016年 zj－db0548. All rights reserved.
//
#import "MTLabel.h"

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

#import "MTLabelAttribute.h"
#import "UIView+Utils.h"
#import "MTCoreTextAttribute.h"
#import "MTGif.h"
#import "MTGifBrush.h"

typedef NS_ENUM(NSUInteger, MTLabelType) {
    MTLabelTypeUrl,
    MTLabelTypeEite,
    MTLabelTypeJ,
};

@interface MTLabel()<MTGifProtocol> {

    CTFrameRef _frameRef;
}

@property (nonatomic, copy) NSString *text;
@property (nonatomic, strong) NSArray *attributeArray;
@property (nonatomic, copy) NSMutableAttributedString *mString;
@property (nonatomic, strong) MTLabelAttribute *lastAttr;
@property (nonatomic, assign) NSInteger star;
@property (nonatomic, strong) MTGif *gif;
@property (nonatomic, strong) UIImageView *iview;
@property (nonatomic, strong) MTGifBrush *brush;
@property (nonatomic, assign) CGRect rect;

@end

@implementation MTLabel

- (instancetype)initWithText:(NSString *)text {
    
    self = [super init];
    self.backgroundColor = [UIColor whiteColor];
    if (self) {
        [self setText:text];
        
        _star = 0;
    }
    return self;
}

- (void)didMoveToWindow {
    
    [super didMoveToWindow];
    [self checkStatus];
    _attributeArray = [self scanningString];
    [self setLabelAttribute];

    
}


- (void)disPlayInRect:(CGRect)rect {
    
    [self setNeedsDisplayInRect:rect];
    
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context , 0 ,self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (CGRectEqualToRect(rect, self.bounds)) {
        [self drawLabelWithContext:context];
    }
    
    [self.brush drawContext:context inRect:rect];
}

- (void)drawLabelWithContext:(CGContextRef)context {
    
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString(
                                            (CFAttributedStringRef) _mString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGRect rects = CGRectMake(20 ,  0 ,self.bounds.size.width - 20 , self.bounds.size.height);
    CGPathAddRect(path, NULL , rects);
    
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter,
                                                CFRangeMake(0, 0),
                                                path,
                                                NULL);
    
    _frameRef = frame;
    CTFrameDraw(frame,context);
    [self drawImageWithContext:context];
    
    CGPathRelease(path);
    CFRelease(frameSetter);
}

- (void)drawImageWithContext:(CGContextRef)context {
    
    //draw image here
    CFArrayRef lines = CTFrameGetLines(_frameRef);
    CGPoint origins[CFArrayGetCount(lines)];
    CGMutablePathRef path = CTFrameGetPath(_frameRef);
    CGRect textFrame =  CGPathGetBoundingBox(path);
    
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), origins);
    
    int gifIndex = 0;
    for (int i = 0; i < CFArrayGetCount(lines); i ++) {
        
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        for (int k = 0; k < CFArrayGetCount(runs); k ++) {
            
            CTRunRef run = CFArrayGetValueAtIndex(runs, k);
            NSDictionary *attri = (NSDictionary *)CTRunGetAttributes(run);
            NSString *imageName = [attri objectForKey:@"imageName"];
            NSString *gifName = [attri objectForKey:@"gifName"];
            
            if (imageName || gifName) {
                CGFloat runAsent;
                CGFloat runDescent;
                CGPoint origin = origins[i];
                CGRect runRect;
                
                runRect.size.width = CTRunGetTypographicBounds(run,
                                                               CFRangeMake(0, 0),
                                                               &runAsent,
                                                               &runDescent,
                                                               NULL);
                CGFloat offset = CTLineGetOffsetForStringIndex(line,
                                                               CTRunGetStringRange(run).location,
                                                               NULL);
                runRect = CGRectMake(origin.x + offset + textFrame.origin.x,
                                     origin.y - runDescent + textFrame.origin.y,
                                     runRect.size.width,
                                     runAsent + runDescent);
                
                
                if (imageName) {
                    imageName = @"test2.gif";
                    UIImage *image = [UIImage imageNamed:imageName];
                    CGContextDrawImage(context, runRect, image.CGImage);
                }
                
                if (gifName) {
                    if (!CGRectEqualToRect(runRect, CGRectZero)) {
                        CGFloat y = self.frame.size.height - runRect.origin.y
                        - runRect.size.height;
                        CGRect newRect = CGRectMake(runRect.origin.x,
                                                    y,
                                                    runRect.size.width,
                                                    runRect.size.height);
                        [self.brush.imagesourceArry objectAtIndex:gifIndex].frame = newRect;
                        gifIndex ++;
                        
                    }
                }
            }
        }
    }
}


- (MTGifBrush *)brush {
    
    if (!_brush) {
        _brush = [[MTGifBrush alloc] init];
    }
    return  _brush;
}


- (void)checkStatus {
    
    if (_isRollCallRecognitionOn){
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
        [self.attributeDic setObject:attribute1 forKey:@"@[^ ]+ "];

    }
    
    if (_isURLRecognitionOn) {
        MTCoreTextAttribute *attributeNormal3 = [[MTCoreTextAttribute alloc] init];
        MTLabelAttribute *attribute3 = [[MTLabelAttribute alloc] init];
        attribute3.type = @"http://[^ ]+";
        attribute3.isAddImage = YES;
        
        [attributeNormal3 setColor:[UIColor greenColor]];
        [attributeNormal3 setFont:[UIFont italicSystemFontOfSize:30]];
        MTCoreTextAttribute *attributeHightlight3 = [[MTCoreTextAttribute alloc] init];
        [attributeHightlight3 setColor:[UIColor redColor]];
        [attributeHightlight3 setFont:[UIFont italicSystemFontOfSize:30]];
        
        attribute3.normalAttribute = attributeNormal3;
        attribute3.hightlightAttribute = attributeHightlight3;
        [_attributeDic setObject:attribute3 forKey:@"http://[^ ]+"];
    }
    
    if (_isPhonenumberRecognitionOn){
        MTCoreTextAttribute *attributeNormal2 = [[MTCoreTextAttribute alloc] init];
        MTLabelAttribute *attribute2 = [[MTLabelAttribute alloc] init];
        attribute2.type = @"[0-9]{11,13}";
        
        [attributeNormal2 setColor:[UIColor redColor]];
        [attributeNormal2 setFont:[UIFont italicSystemFontOfSize:30]];
        MTCoreTextAttribute *attributeHightlight2 = [[MTCoreTextAttribute alloc] init];
        [attributeHightlight2 setColor:[UIColor greenColor]];
        [attributeHightlight2 setFont:[UIFont italicSystemFontOfSize:30]];
        
        attribute2.normalAttribute = attributeNormal2;
        attribute2.hightlightAttribute = attributeHightlight2;
        [_attributeDic setObject:attribute2 forKey:@"[0-9]{11,13}"];

    }
}

- (NSArray *)scanningString {
    
    NSArray *preArray = [self pretreatment];
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *patternArray = [self.attributeDic allKeys];
    
    for (NSString *pattern in patternArray){
        NSRegularExpression *expression = [NSRegularExpression
                                           regularExpressionWithPattern:pattern
                                           options:NSRegularExpressionCaseInsensitive
                                           error:NULL];
        NSArray *matchArray = [expression matchesInString:self.text
                                                  options:0
                                                    range:NSMakeRange(0, self.text.length)];
        for(NSTextCheckingResult *result in matchArray){
            
            MTLabelAttribute *attribute = [[self.attributeDic objectForKey:pattern] copy];
             attribute.range = result.range;
            
            attribute.text = [self.text substringWithRange:result.range];
            [array addObject:attribute];
        }
    }
    
    [array addObjectsFromArray:preArray];
    return array;
}

- (NSArray *)pretreatment {
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    NSArray *patternArray = [self.attributeDic allKeys];
    for (NSString *pattern in patternArray) {
         MTLabelAttribute *attribute = [self.attributeDic objectForKey:pattern] ;
        if (attribute.isReplaced) {
            NSRegularExpression *expression = [NSRegularExpression
                                               regularExpressionWithPattern:pattern
                                               options:NSRegularExpressionCaseInsensitive
                                               error:NULL];
            
            NSTextCheckingResult *result = [expression firstMatchInString:self.text
                                                        options:0
                                                        range:NSMakeRange(0, self.text.length)];
            while (result) {
                //show me
                MTLabelAttribute *attributes = [[self.attributeDic objectForKey:pattern] copy];
                attributes.range = NSMakeRange(result.range.location, 1);
                attributes.text = [_text substringWithRange:result.range];
                _text = [_text stringByReplacingCharactersInRange:result.range
                                                       withString:@"1"];
                [attributes.normalAttribute setColor:[UIColor clearColor]];
                [attributes.hightlightAttribute setColor:[UIColor clearColor]];
                [self ajustRangeWithAttrArray:array
                                     andRange:result.range
                                    andRepStr:@"1"];
                [array addObject:attributes];
                
                //set gif here
                [self manageGifWithAttribute:attribute];
                
                result = [expression firstMatchInString:self.text
                                                options:0
                                                  range:NSMakeRange(0, self.text.length)];
            }
        }
    }
    return array;
}

- (void)ajustRangeWithAttrArray:(NSMutableArray <MTLabelAttribute *>*)array
                       andRange:(NSRange)range
                      andRepStr:(NSString *)str {
    
    for (MTLabelAttribute *attr in array) {
        if ( attr.range.location > range.location) {
            NSRange newRange = NSMakeRange(attr.range.location - range.length + str.length,
                                           attr.range.length);
            attr.range = newRange;
        }
    }
}

- (void)manageGifWithAttribute:(MTLabelAttribute *)attr {
    
    if (!attr.isAddGif) {
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(getGifAttributeWithString:)]) {
        MTGifAttribute *gifAttr = [self.delegate getGifAttributeWithString:attr.text];
        gifAttr.delegate = self;
        [gifAttr startAnitation];
        [self.brush.imagesourceArry addObject:gifAttr];
    }
}


- (void)setLabelAttribute {
    _mString = [[NSMutableAttributedString alloc] initWithString:_text];
    [_mString beginEditing];
//    [self setParagraphStyle];
    for (MTLabelAttribute *attributes in _attributeArray) {
    
        MTCoreTextAttribute *textAttribute = attributes.normalAttribute ;
        [textAttribute.attributeDic setObject:attributes.text forKey:@"MTText"];
        [_mString addAttributes:textAttribute.attributeDic range:attributes.range];
    }
    
    
    [self addImage];
    
    [_mString endEditing];
}

- (void)setParagraphStyle {

    CTTextAlignment alignment = kCTLeftTextAlignment;//kCTNaturalTextAlignment;
    CTParagraphStyleSetting alignmentStyle;
    alignmentStyle.spec=kCTParagraphStyleSpecifierAlignment;//指定为对齐属性
    alignmentStyle.valueSize=sizeof(alignment);
    alignmentStyle.value=&alignment;
    
    //首行缩进
    CGFloat fristlineindent = 24.0f;
    CTParagraphStyleSetting fristline;
    fristline.spec = kCTParagraphStyleSpecifierFirstLineHeadIndent;
    fristline.value = &fristlineindent;
    fristline.valueSize = sizeof(CGFloat);
    
    
    //段尾缩进
    CGFloat tailindent = 200.0f;
    CTParagraphStyleSetting tail;
    tail.spec = kCTParagraphStyleSpecifierTailIndent;
    tail.value = &tailindent;
    tail.valueSize = sizeof(float);
    
    //换行模式
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;
    //kCTLineBreakByWordWrapping;//换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    
    
    //行距
    CGFloat _linespace = 15.0f;
    CTParagraphStyleSetting lineSpaceSetting;
    lineSpaceSetting.spec = kCTParagraphStyleSpecifierLineSpacing;
    lineSpaceSetting.value = &_linespace;
    lineSpaceSetting.valueSize = sizeof(float);
    
    
    //组合设置
    CTParagraphStyleSetting settings[] = {
        alignmentStyle,
//        fristline,
        tail,
        lineBreakMode,
        
    };
    
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 3);
    
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)style forKey:(id)kCTParagraphStyleAttributeName ];
    
    // set attributes to attributed string
    [_mString addAttributes:attributes range:NSMakeRange(0, [_mString length])];

}

- (void)setAttributeWithType:(NSString *)type andAttribute:(MTLabelAttribute *)attr {
    
    MTCoreTextAttribute *textAttribute;
    if ([type isEqualToString:@"normal"]) {
        textAttribute = attr.normalAttribute;
    }else{
        textAttribute = attr.hightlightAttribute;
    }

    if (textAttribute){
        
        [_mString beginEditing];
        [_mString addAttributes:textAttribute.attributeDic range:attr.range];
        [_mString addAttribute:@"MTText" value:attr.text range:attr.range];
        [_mString endEditing];

        [self setNeedsDisplay];
    }
}


- (MTLabelAttribute *)getAttributeByLocation:(CGPoint) point{
    
    CGMutablePathRef path = CTFrameGetPath(_frameRef);
    CGRect textFrame =  CGPathGetBoundingBox(path);
    NSArray *lines = (NSArray *)CTFrameGetLines(_frameRef);
    CGPoint origins[lines.count];
    CTFrameGetLineOrigins(_frameRef, CFRangeMake(0, 0), origins);
    CTLineRef ref;
    
    int count = 0;
    
    if (point.y < (origins[lines.count - 1].y + textFrame.origin.y)) {
        return nil;
    }
    
    for (int i = 1; i < lines.count ; i ++) {
        
        CGFloat minY = origins[i].y + textFrame.origin.y;
        CGFloat maxY = origins[i - 1].y + textFrame.origin.y;
        if (point.y >= minY && point.y <=  maxY) {
            count = i ;
            break;
        }
    }
    
    ref = (__bridge CTLineRef)lines[count];
    CGPoint origin = origins[count];
    NSArray *ctRuns = (NSArray *)CTLineGetGlyphRuns(ref);

//    NSLog(@"%d",ctRuns.count);
    for (int k = 0; k < ctRuns.count; k ++) {
        CTRunRef runTest = (__bridge CTRunRef)([ctRuns objectAtIndex:k]);
        
        CGFloat offset = CTLineGetOffsetForStringIndex((CTLineRef)lines[count],
                                                       CTRunGetStringRange(runTest).location,
                                                       NULL) + textFrame.origin.x;

        CGPoint firstPoint = CGPointMake(origin.x + offset , origin.y + textFrame.origin.y);
        
        CGFloat ascent;
        CGFloat descent;
        CGFloat leading;
        
        CGFloat width =  CTRunGetTypographicBounds(runTest, CFRangeMake(0, 0),
                                                   &ascent,
                                                   &descent,
                                                   &leading);
        if ( point.x >= firstPoint.x
            &&point.x <= firstPoint.x + width
            &&point.y <= origin.y + ascent
            &&point.y >= origin.y ) {
            
            NSDictionary *dic = (NSDictionary *)CTRunGetAttributes(runTest);
            NSString *string = [dic objectForKey:@"MTText"];
            CFRange cfRange = CTRunGetStringRange(runTest);
            NSLog(@"{%d,%d}",cfRange.location,cfRange.length);

            if ([dic objectForKey:@"imageName"]) {
                return [self getAttributesWithRange:NSMakeRange(cfRange.location, cfRange.length)];
            }
            
            if ([dic objectForKey:@"gifName"]) {
                 return [self getAttributesWithRange:NSMakeRange(cfRange.location, cfRange.length)];
            }
            
            NSString *subString = [self.text substringWithRange:
                                   NSMakeRange(cfRange.location, cfRange.length)];
            
            NSRange range;
            NSRange subStringRange = [string rangeOfString:subString];
            
            range = NSMakeRange(cfRange.location - subStringRange.location, string.length);
            
            return [self getAttributesWithRange:range];
        }else{
            CFRange cfRange = CTRunGetStringRange(runTest);
            NSLog(@"{%d,%d}",cfRange.location,cfRange.length);
        }
        
    }
    return nil;
}

- (MTLabelAttribute *)getAttributesWithRange:(NSRange)range{

    for (MTLabelAttribute *attribute in self.attributeArray) {
        if ([attribute isInRang:range]) {
            return attribute;
        }
    }
    return nil;
}

- (void)addImage {
    
    for(MTLabelAttribute *attr in self.attributeArray){
        
        if (attr.isAddImage || attr.isAddGif) {
            CTRunDelegateCallbacks imageCallBacks;
            imageCallBacks.version = kCTRunDelegateVersion1;
            imageCallBacks.dealloc = RunDelegateDeallocCallback;
            imageCallBacks.getAscent = RunDelegateGetAsent;
            imageCallBacks.getDescent = RunDelegateGetDescent;
            imageCallBacks.getWidth = RunDelegateGetWidthCallBack;
            
            CTRunDelegateRef runDelegate = CTRunDelegateCreate(&imageCallBacks,
                                                               (__bridge void *)(attr.text));
            CTRunDelegateGetRefCon(runDelegate);
            [self.mString addAttribute:(NSString *)kCTRunDelegateAttributeName
                                          value:(__bridge id)runDelegate
                                          range:attr.range];
            if (attr.isAddImage) {
                [_mString addAttribute:@"imageName" value:attr.text range:attr.range];

            }else{
                [_mString addAttribute:@"gifName" value:attr.text range:attr.range];
            
            }
            CFRelease(runDelegate);
        }
    }
}

- (void)dealloc{
    
    self.delegate = NULL;
}

//*********************************************************************************************//
//touch event
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:self];
    CGPoint location = CGPointMake(point.x, self.bounds.size.height - point.y);
    
    MTLabelAttribute *attr = [self getAttributeByLocation:location];
    _lastAttr = attr;
    if (attr) {
        if ([self.delegate respondsToSelector:@selector(clickWithAttibute:andText:)]) {
            [self.delegate clickWithAttibute:attr andText:attr.text];
        }
        
        [self setAttributeWithType:@"hightlight" andAttribute:attr];
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self setAttributeWithType:@"normal" andAttribute:_lastAttr];
}


@end

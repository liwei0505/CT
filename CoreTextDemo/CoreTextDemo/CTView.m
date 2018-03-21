//
//  CTView.m
//  CoreTextDemo
//
//  Created by lee on 2018/3/20.
//  Copyright © 2018年 mjsfax. All rights reserved.
//

#import "CTView.h"
#import "MarkupParser.h"
#import "CTColumnView.h"

@interface CTView()
@property (strong, nonatomic) NSAttributedString *attString;
@property (copy, nonatomic) NSString *attriStr;
@end

@implementation CTView

- (void)dealloc {
    self.attString = nil;
    self.frames = nil;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
//    lb.text = @"输入下面的代码在你的视图上绘制一";
//    [self addSubview:lb];
    [self setup];
}

- (void)setup {
//    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.txt" ofType:nil];
//    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    self.attriStr = @"Overview<font color=\"red\">This collection of documents is the API reference for the Core Text framework.""<font color=\"black\">Core Text provides a modern, low-level programming interface for laying out text and handling fonts. The Core Text layout engine is designed for high performance, ease of use, and close integration with Core Foundation. The text layout API provides high-quality typesetting, including character-to-glyph conversion, with ligatures, kerning, and so on. The complementary Core Text font technology provides automatic font substitution (cascading), font descriptors and collections, easy access to font metrics and glyph data, and many other features.""with ligatures, kerning, and so on. The complementary Core Text font technology provides automatic font substitution (cascading), font descriptors and collections, easy access to font metrics and glyph data, and many other features.";
}

- (void)buildFrames {
    float frameXOffset = 20;//1
    float frameYOffset = 20;
    self.pagingEnabled = YES;
    self.delegate = self;
    self.frames = [NSMutableArray array];
    
    CGMutablePathRef path = CGPathCreateMutable();//创建一个路径和一个矩形边等于view的边框
    CGRect textFrame = CGRectInset(self.bounds, frameXOffset, frameYOffset);
    CGPathAddRect(path, NULL, textFrame);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attString);
    
    int textPos = 0;//当前文本的位置
    int columnIndex = 0;//计算创建了多少列
    
    while (textPos<[self.attString length]) {//
        CGPoint colOffset = CGPointMake((columnIndex+1)*frameXOffset+columnIndex*(textFrame.size.width/2), 20);
        //创建一个列边界，保存当前列的起点和尺寸
        CGRect colRect = CGRectMake(0, 0, textFrame.size.width/2-10, textFrame.size.height-40);
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddRect(path, NULL, colRect);
        
        CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(textPos, 0), path, NULL);
        CFRange frameRange = CTFrameGetVisibleStringRange(frame);//找出字符串的那些部分可以完全显示在框里，textPos每次以这个长度递增
        
        CTColumnView *content = [[CTColumnView alloc] initWithFrame:CGRectMake(0, 0, self.contentSize.width, self.contentSize.height)];
        content.backgroundColor = [UIColor clearColor];
        content.frame = CGRectMake(colOffset.x, colOffset.y, colRect.size.width, colRect.size.height);
        
        [content setCtFrame:frame];//创建CTColumnView
        [self.frames addObject:(__bridge id _Nonnull)(frame)];
        [self addSubview:content];
        
        textPos += frameRange.length;
        CFRelease(path);
        columnIndex++;
    }
    
    int totalPages = (columnIndex+1)/2;//7
    self.contentSize = CGSizeMake(totalPages*self.bounds.size.width, textFrame.size.height);
    
}

/*

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //旋转方向
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    //创建绘制文本的路径区域 ios只支持矩形
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.bounds);
    //CT中使用NSAttributedString
//    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:@"Hello core text world!" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16],NSForegroundColorAttributeName:[UIColor redColor]}];
    MarkupParser *p = [[MarkupParser alloc] init];
    //@"Hello <font color=\"red\">core text <font color=\"blue\">world!"
    NSAttributedString *attString = [p attrStringFromMarkup:self.attriStr];
    
    //CTFramesetterRef重要的类，管理字体引用和文本绘制帧；
    //通过所选文本范围与需要绘制到的矩形路径创建一个帧
    CTFramesetterRef frameSetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(0, [attString length]), path, NULL);
    //将frame描述到设备上下文
    CTFrameDraw(frame, context);
    //释放对象
    CFRelease(path);
    CFRelease(frameSetter);
    CFRelease(frame);
}

*/

@end

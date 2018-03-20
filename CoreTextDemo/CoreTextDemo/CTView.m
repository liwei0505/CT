//
//  CTView.m
//  CoreTextDemo
//
//  Created by lee on 2018/3/20.
//  Copyright © 2018年 mjsfax. All rights reserved.
//

#import "CTView.h"
#import "MarkupParser.h"

@interface CTView()
@property (copy, nonatomic) NSString *attriStr;
@end

@implementation CTView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
        lb.text = @"输入下面的代码在你的视图上绘制一";
        [self addSubview:lb];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
        lb.text = @"输入下面的代码在你的视图上绘制一";
        [self addSubview:lb];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
//    UILabel *lb = [[UILabel alloc] initWithFrame:CGRectMake(50, 100, 200, 50)];
//    lb.text = @"输入下面的代码在你的视图上绘制一";
//    [self addSubview:lb];
    [self setup];
}

- (void)setup {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"test.txt" ofType:nil];
    NSString *text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:NULL];
    self.attriStr = text;
}

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

@end

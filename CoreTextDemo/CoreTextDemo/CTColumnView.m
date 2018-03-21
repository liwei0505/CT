//
//  CTColumnView.m
//  CoreTextDemo
//
//  Created by lee on 2018/3/21.
//  Copyright © 2018年 mjsfax. All rights reserved.
//

#import "CTColumnView.h"
@interface CTColumnView()
@end

@implementation CTColumnView

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CTFrameDraw((CTFrameRef)self.ctFrame, context);
}

@end

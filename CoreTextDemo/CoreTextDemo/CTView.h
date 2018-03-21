//
//  CTView.h
//  CoreTextDemo
//
//  Created by lee on 2018/3/20.
//  Copyright © 2018年 mjsfax. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CTView : UIScrollView<UIScrollViewDelegate>
@property (assign, nonatomic) float frameXOffset;
@property (assign, nonatomic) float frameYOffset;
@property (strong, nonatomic) NSMutableArray *frames;
- (void)buildFrames;
@end

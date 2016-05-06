//
//  SXBarButton.m
//  81 - 网易新闻
//
//  Created by 董 尚先 on 15/4/9.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//

#import "SXBarButton.h"
#import "UIView+Frame.h"

@implementation SXBarButton

- (void)setHighlighted:(BOOL)highlighted
{
    // 目的就是重写取消高亮显示
}

- (void)layoutSubviews
{  //@需要根据实际情况微调一下imageView.width&height,titleLabel.font
    [super layoutSubviews];
//self.titleLabel.x = self.imageView.x;
    self.imageView.y = 5;
    self.imageView.width = 23;
    self.imageView.height = 23;
    self.imageView.x = (self.width - self.imageView.width)/2.0;//@1当按键为3个时，就是除以2
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.titleLabel.x = self.imageView.x - (self.titleLabel.width - self.imageView.width)/2.0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame) + 2;
    self.titleLabel.font=[UIFont systemFontOfSize:11];
    self.titleLabel.shadowColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
}

@end

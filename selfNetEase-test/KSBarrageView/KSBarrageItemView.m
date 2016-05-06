//
//  KSBarrageItemView.m
//  KwSing
//
//  Created by yuchenghai on 14/12/24.
//  Copyright (c) 2014年 kuwo.cn. All rights reserved.
//

#import "KSBarrageItemView.h"
#import "UIView+Sizes.h"

@implementation KSBarrageItemView {
    UIImageView *_avatarView;
    UILabel *_contentLabel;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 6, 1, 30)];
        [_contentLabel setFont:[UIFont systemFontOfSize:18]];
        [_contentLabel setTextColor:[UIColor redColor]];
        [_contentLabel setNumberOfLines:1];
        [self addSubview:_contentLabel];
        [self.layer setMasksToBounds:YES];
        [self.layer setCornerRadius:15];
        [self setClipsToBounds:YES];
    }
    return self;
}

- (void)setAvatarWithContent:(NSString *)content {

    if (content.length>15) {
        content=[content substringToIndex:15];
    }
    [_contentLabel setText:content];
    [_contentLabel sizeToFit];
    self.width = _contentLabel.width+43;
}

@end

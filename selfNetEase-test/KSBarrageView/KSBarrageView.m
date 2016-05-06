//
//  KSBarrageView.m
//  KwSing
//
//  Created by yuchenghai on 14/12/22.
//  Copyright (c) 2014年 kuwo.cn. All rights reserved.
//

#import "KSBarrageView.h"
#import "UIView+Sizes.h"
#import "KSBarrageItemView.h"

#define ITEMTAG 154

@implementation KSBarrageView {
    UIImageView *_avatarView;
    UIImageView *_giftView;
    
    NSTimer *_timer;
    NSInteger _curIndex;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {

        [self setClipsToBounds:YES];
        
        _curIndex = 0;
    }
    return self;
}

- (void)start {
    if (_dataArray && _dataArray.count > 0) {
        if (!_timer) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:0.7 target:self selector:@selector(postView) userInfo:nil repeats:YES];
        }
    }
}

- (void)stop {
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)postView {
    if (_dataArray && _dataArray.count > 0) {
        int indexPath = random()%(int)((self.frame.size.height)/30);
        int top = indexPath * 30;
        
        UIView *view = [self viewWithTag:indexPath + ITEMTAG];
        if (view && [view isKindOfClass:[KSBarrageItemView class]]) {
            return;
        }
        
        NSDictionary *dict = nil;
        if (_dataArray.count > _curIndex) {
            dict = _dataArray[_curIndex];
            _curIndex++;
        } else {
            _curIndex = 0;
            dict = _dataArray[_curIndex];
            _curIndex++;
        }
        
        for (KSBarrageItemView *view in self.subviews) {
            if ([view isKindOfClass:[KSBarrageItemView class]] && view.itemIndex == _curIndex-1) {
                return;
            }
        }
        
        KSBarrageItemView *item = [[KSBarrageItemView alloc] initWithFrame:CGRectMake([[UIScreen mainScreen] bounds].size.width, top, 10, 30)];
        
       // NSString *content = [dict objectForKey:@"b"];
        NSString *content = dict[@"1"][@"b"];
        [item setAvatarWithContent:content];

        item.itemIndex = _curIndex-1;
        item.tag = indexPath + ITEMTAG;
        [self addSubview:item];
        
        //CGFloat speed = 85.;
        CGFloat speed = 55.;
        speed += random()%20;
        CGFloat time = (item.width+[[UIScreen mainScreen] bounds].size.width) / speed;
        
        [UIView animateWithDuration:time delay:0.f options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut  animations:^{
            item.left = -item.width;
        } completion:^(BOOL finished) {
            [item removeFromSuperview];
        }];
        
    }
}

@end

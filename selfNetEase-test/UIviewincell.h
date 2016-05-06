//
//  UIviewincell.h
//  selfNetEase-test
//
//  Created by yihl on 3/29/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import <UIKit/UIKit.h>

@interface UIviewincell : UIView

-(void)setImage:(NSString *)string1 andLabel:(NSString *)string2;
+ (instancetype)viewWithNib;
@end

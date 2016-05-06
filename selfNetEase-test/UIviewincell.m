//
//  UIviewincell.m
//  selfNetEase-test
//
//  Created by yihl on 3/29/16.
//  Copyright © 2016 yihl. All rights reserved.
//

#import "UIviewincell.h"
@interface UIviewincell()
@property (strong, nonatomic) IBOutlet UIImageView *image;
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) NSString *string11;
@property (strong, nonatomic) NSString *string22;
@end
@implementation UIviewincell
-(void)setImage:(NSString *)string1 andLabel:(NSString *)string2{
   [_image sd_setImageWithURL:[NSURL URLWithString:string1]];
    _label.text=string2;
}

+ (instancetype)viewWithNib
{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"UIviewincell" owner:nil options:nil] lastObject];
}

@end

//
//  CommentModel.m
//  CommentLaout
//
//  Created by xiaohaibo on 11/29/15.
//  Copyright © 2015 xiao haibo. All rights reserved.
//
#import "Constant.h"
#import "CommentModel.h"

@implementation CommentModel

-(instancetype)initWithDict:(NSDictionary *)dic{
    
    if (self = [super init]) {
        NSString *string =dic[@"f"];
        NSRange rang =[string rangeOfString:@"&"];
        if (rang.location==NSNotFound) {
            self.address=dic[@"f"];
        }else{
             self.address =[string substringToIndex:rang.location];
        }
        self.comment =dic[@"b"];
        self.name=dic[@"n"];
        if (self.name==nil) {
            self.name=@"火星网友";
        }
        self.timeString =dic[@"t"];
        
    }
    return self;
    
}
- (CGSize)sizeWithConstrainedToSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: CommentFont};
    CGSize textSize         = [self.comment boundingRectWithSize:CGSizeMake(size.width, 0)
                                                 options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading
                                              attributes:attribute
                                                 context:nil].size;
    return textSize;
}
@end

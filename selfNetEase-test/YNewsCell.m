//
//  YNewsCell.m
//  selfNetEase-test
//
//  Created by yihl on 2/1/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "UIImageView+WebCache.h"
#import "YNewsCell.h"
@interface YNewsCell()
@property (strong, nonatomic) IBOutlet UIImageView *YImage1;
@property (strong, nonatomic) IBOutlet UIImageView *YImage2;
@property (strong, nonatomic) IBOutlet UIImageView *YImage3;
@property (strong, nonatomic) IBOutlet UILabel *YLabel1;
@property (strong, nonatomic) IBOutlet UILabel *YLabel2;
@property (strong, nonatomic) IBOutlet UILabel *YLabelReply;

@end

@implementation YNewsCell

-(void)getDataFromDic:(NSDictionary *)NewsDic{
    self.YLabel1.text=NewsDic[@"title"];
    self.YLabel2.text=NewsDic[@"digest"];
    [self.YImage1 sd_setImageWithURL:[NSURL URLWithString:NewsDic[@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
    if (NewsDic[@"imgextra"]) {
        [self.YImage2 sd_setImageWithURL:[NSURL URLWithString:NewsDic[@"imgextra"][0][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
        [self.YImage3 sd_setImageWithURL:[NSURL URLWithString:NewsDic[@"imgextra"][1][@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
    }
}

+(NSString *)getIndentiferfrom:(NSDictionary *)dic{
    if (dic[@"hasHead"] ) {
        return @"TopImageCell";
    }else if (dic[@"imgextra"]){
        return @"ImagesCell";
    }else{
        return @"NewsCell";
    }
}

+(CGFloat)getHeightfrom:(NSDictionary *)dic{
    if (dic[@"hasHead"] ) {
        return 235;
    }else if (dic[@"imgextra"]){
        return 124;
    }else{
        return 80;
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

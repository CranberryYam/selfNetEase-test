//
//  ReadingTableViewCell.m
//  selfNetEase-test
//
//  Created by yihl on 3/26/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "UIviewincell.h"
#import "UIImageView+WebCache.h"
#import "ReadingTableViewCell.h"
@interface ReadingTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *Yheadimage;
@property (strong, nonatomic) IBOutlet UILabel *Yheadlable;
@end
@implementation ReadingTableViewCell

-(void)getDataFromDic:(NSDictionary *)NewsDic{
    self.Yheadlable.text=NewsDic[@"title"];
    [self.Yheadimage sd_setImageWithURL:[NSURL URLWithString:NewsDic[@"imgsrc"]] placeholderImage:[UIImage imageNamed:@"302"]];
    if(NewsDic[@"ads"]){
        for (NSInteger i=0; i<4; i++) {
        UIviewincell* tv=(UIviewincell*)[self viewWithTag:i+30];
            [tv setImage:NewsDic[@"ads"][i][@"imgsrc"] andLabel:NewsDic[@"ads"][i][@"title"]];
         }
    }
}



- (void)awakeFromNib {
    for (NSInteger i = 0; i < 4; i++) {
        UIviewincell* tv=[UIviewincell viewWithNib];
        UIView* org = [self viewWithTag:i + 20];
        tv.frame = org.bounds;
        tv.tag = i + 30;
        [org addSubview:tv];
    }
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

@end

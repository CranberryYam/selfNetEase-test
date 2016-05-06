//
//  YNewsCell.h
//  selfNetEase-test
//
//  Created by yihl on 2/1/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "NSDictionary+NewsList.h"
#import <UIKit/UIKit.h>

@interface YNewsCell : UITableViewCell
+(CGFloat)getHeightfrom:(NSDictionary *)dic;
-(void)getDataFromDic:(NSDictionary *)NewsDic;
+(NSString *)getIndentiferfrom:(NSDictionary *)dic;

@end

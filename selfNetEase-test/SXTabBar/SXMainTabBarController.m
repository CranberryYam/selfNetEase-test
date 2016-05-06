//
//  SXMainTabBarController.m
//  81 - 网易新闻
//
//  Created by 董 尚先 on 15/4/9.
//  Copyright (c) 2015年 shangxianDante. All rights reserved.
//
#import "YHTTPClient.h"
#import "SXMainTabBarController.h"
#import "SXBarButton.h"
#import "SXTabBar.h"
#import "UIView+Frame.h"

#define YadImagefilePath [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)objectAtIndex:0]stringByAppendingString:@"/adImage.png"]

@interface SXMainTabBarController ()<SXTabBarDelegate>
@property (strong,nonatomic) UIImageView *imageView;
@end

@implementation SXMainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
   [self askAdImageUrl];
    SXTabBar *tabBar = [[SXTabBar alloc]init];
    tabBar.frame = self.tabBar.bounds;
    tabBar.backgroundColor = [UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1];
 
    [self.tabBar addSubview:tabBar];
 
    tabBar.delegate = self;
    
    [tabBar addImageView];
    
    [tabBar addBarButtonWithNorName:@"tabbar_icon_news_normal.png" andDisName:@"tabbar_icon_news_highlight.png" andTitle:NSLocalizedString(@"news", @"")];//@3为每个按钮配置图片和文字
    [tabBar addBarButtonWithNorName:@"tabbar_icon_reader_normal.png" andDisName:@"tabbar_icon_reader_highlight.png" andTitle:NSLocalizedString(@"reading", @"")];
    [tabBar addBarButtonWithNorName:@"tabbar_icon_media_normal" andDisName:@"tabbar_icon_media_highlight" andTitle:NSLocalizedString(@"video", @"")];
    [tabBar addBarButtonWithNorName:@"tabbar_icon_found_normal" andDisName:@"tabbar_icon_found_highlight" andTitle:NSLocalizedString(@"discover", @"")];
    [tabBar addBarButtonWithNorName:@"tabbar_icon_me_normal" andDisName:@"tabbar_icon_me_highlight" andTitle:NSLocalizedString(@"me", @"")];
    
    self.selectedIndex = 0;
}

#pragma mark - ******************** SXTabBarDelegate代理方法
- (void)ChangSelIndexForm:(NSInteger)from to:(NSInteger)to
{
    self.selectedIndex = to;
}

-(void)askAdImageUrl{
    UIImageView *imageView=[[UIImageView alloc] initWithFrame:[[UIScreen mainScreen]bounds]];
    [self.view addSubview:imageView];
    imageView.image=[UIImage imageNamed:@"700.png"];
    NSInteger now = [[[NSDate alloc] init] timeIntervalSince1970];
    NSString *adPath = [NSString stringWithFormat:@"http://g1.163.com/madr?app=7A16FBB6&platform=ios&category=startup&location=1&timestamp=%ld",(long)now];
    [[YHTTPClient sharedYHTTPClient] GET:adPath parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        NSString *adImagePath=responseObject[@"ads"][0][@"res_url"][0];
        [self downloadImage:adImagePath];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
    imageView.image=[UIImage imageWithData:[NSData dataWithContentsOfFile:YadImagefilePath]];
    
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [imageView removeFromSuperview];
    });
}

-(void)downloadImage:(NSString *)imageUrl{
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:imageUrl]];
    NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if (data) {
            [data writeToFile:YadImagefilePath atomically:YES];
        }
    }];
    [task resume];
}


@end

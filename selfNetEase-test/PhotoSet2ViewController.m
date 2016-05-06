//
//  PhotoSet2ViewController.m
//  selfNetEase-test
//
//  Created by yihl on 2/27/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "YHTTPClient.h"
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "PhotoSet2ViewController.h"

@interface PhotoSet2ViewController ()<UIScrollViewDelegate>
- (IBAction)backButton:(id)sender;
- (IBAction)commentButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
- (IBAction)downloadButton:(id)sender;
- (IBAction)shareButton:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *url;
@property (strong,nonatomic) NSArray *imageArray;
@end

@implementation PhotoSet2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)loadData{
    NSString *one  = self.imageDic[@"photosetID"];
    NSString *two = [one substringFromIndex:4];
    NSArray *three = [two componentsSeparatedByString:@"|"];
    self.url = [NSString stringWithFormat:@"http://c.m.163.com/photo/api/set/%@/%@.json",[three firstObject],[three lastObject]];
    [[YHTTPClient sharedYHTTPClient] GET:self.url parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        //NSLog(@"imgres is %@",responseObject);
        self.imageArray=responseObject[@"photos"];
        [self buildScrollView];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
}

-(void)buildScrollView{
    self.scrollView.backgroundColor=[UIColor blackColor];
    //CGFloat contentSizeWidth=self.imageArray.count*self.scrollView.frame.size.width;
    CGFloat contentSizeWidth=self.imageArray.count*self.scrollView.frame.size.width;
    self.scrollView.contentSize=CGSizeMake(contentSizeWidth, 0);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.delegate=self;
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    imageview.contentMode=UIViewContentModeCenter;
    imageview.contentMode=UIViewContentModeScaleAspectFit;
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageArray[0][@"imgurl"]] placeholderImage:[UIImage imageNamed:@""]];
    [self.scrollView addSubview:imageview];
    NSString *countNum = [NSString stringWithFormat:@"%d/%ld",1,self.imageArray.count];
    self.pageLabel.text=countNum;
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index=(self.scrollView.contentOffset.x/self.scrollView.frame.size.width);
    if (index<self.imageArray.count) {
        UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(index*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
        imageview.contentMode=UIViewContentModeCenter;
        imageview.contentMode=UIViewContentModeScaleAspectFit;
        [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageArray[index][@"imgurl"]] placeholderImage:[UIImage imageNamed:@" "]];
        [self.scrollView addSubview:imageview];
        NSString *countNum = [NSString stringWithFormat:@"%ld/%ld",index+1,self.imageArray.count];
        self.pageLabel.text=countNum;
  }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden = NO;

}

- (IBAction)commentButton:(id)sender {
}
- (IBAction)downloadButton:(id)sender {
}

- (IBAction)shareButton:(id)sender {
}
@end

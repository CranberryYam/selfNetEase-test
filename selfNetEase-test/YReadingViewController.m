//
//  YReadingViewController.m
//  selfNetEase-test
//
//  Created by yihl on 3/26/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "YReadingTableViewController.h"
#import "YReadingViewController.h"

@interface YReadingViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@end

@implementation YReadingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSubViewControllerAndScrollview];
}

-(void)addSubViewControllerAndScrollview{
    for (int i=0; i<1; i++) {
        YReadingTableViewController *controller=[[UIStoryboard storyboardWithName:@"READING" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"reading"];
        //YReadingViewController *controller=[[YReadingViewController alloc]init];
        [self addChildViewController:controller];
    }
    
    CGFloat contentSizeWidth=self.childViewControllers.count*[UIScreen mainScreen].bounds.size.width;
    self.scrollView.contentSize=CGSizeMake(contentSizeWidth, 0);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.delegate=self;
    self.childViewControllers[0].view.frame=self.scrollView.bounds;
    [self.scrollView addSubview:self.childViewControllers[0].view];
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

@end

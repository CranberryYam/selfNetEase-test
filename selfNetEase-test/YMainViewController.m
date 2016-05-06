//
//  YMainViewController.m
//  selfNetEase-test
//
//  Created by yihl on 2/5/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "YNewTableViewController.h"
#import "MenuHrizontal.h"
#import "YMainViewController.h"

@interface YMainViewController ()<MenuHrizontalDelegate,UIScrollViewDelegate>
@property (strong, nonatomic) NSArray *NewsList;
@property (strong, nonatomic) IBOutlet MenuHrizontal *menuBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation YMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NewsList=[NSArray arrayWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"NewsURLs" ofType:@"plist"] ];
    [self addMenubar];
    [self addSubViewControllerAndScrollview];
    
}
#pragma mark- MenuBar
-(void)addMenubar{
    NSArray *vButtonItemArray = @[@{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:NSLocalizedString(@"headline", @""),
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:@"NBA",
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:NSLocalizedString(@"cellphone", @""),
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:NSLocalizedString(@"technology", @""),
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:NSLocalizedString(@"entertainment", @""),
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:NSLocalizedString(@"fashion", @""),
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                  @{NOMALKEY: @"normal",
                                    HEIGHTKEY:@"helight",
                                    TITLEKEY:NSLocalizedString(@"movie", @""),
                                    TITLEWIDTH:[NSNumber numberWithFloat:60]
                                    },
                                        ];
    [self.menuBar createMenuItems:vButtonItemArray];
    self.menuBar.delegate=self;
    [self.menuBar clickButtonAtIndex:0];
}
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex{
    [self.scrollView setContentOffset:CGPointMake(aIndex*self.scrollView.frame.size.width, 0) animated:YES];
}
#pragma mark- SubViewController&Scrollview
-(void)addSubViewControllerAndScrollview{
    for (int i=0; i<self.NewsList.count; i++) {
        YNewTableViewController *controller=[[UIStoryboard storyboardWithName:@"NEWS" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"NEWS"];
        controller.urlString=self.NewsList[i][@"urlString"];
        controller.title=self.NewsList[i][@"title"];
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

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index=(self.scrollView.contentOffset.x/self.scrollView.frame.size.width);
    if (index<=7) {
        self.childViewControllers[index].view.frame=CGRectMake(index*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:self.childViewControllers[index].view];
        [self.menuBar clickButtonAtIndex:index];
    }
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self scrollViewDidEndScrollingAnimation:scrollView];
}

/*-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
  
    NSInteger index=(self.scrollView.contentOffset.x/self.scrollView.frame.size.width)+1;
        if (index<=7) {
    self.childViewControllers[index].view.frame=CGRectMake(index*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [self.scrollView addSubview:self.childViewControllers[index].view];
    }
}*/



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

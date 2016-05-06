//
//  CommentViewController.m
//  selfNetEase-test
//
//  Created by yihl on 3/4/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "YHTTPClient.h"
#import "CommentViewController.h"
#import "LayoutContainerView.h"
#import "CommentModel.h"
@interface CommentViewController ()<UITableViewDelegate,UITableViewDataSource>
- (IBAction)backButton:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableview;
@property (strong,nonatomic) NSMutableArray *dataSource;
@end

@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.tableview.delegate=self;
    self.tableview.dataSource=self;
}

- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)loadData{
    NSString *adPath=[NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/%@/%@/0/10/10/2/2", self.boardid,self.docID];
    NSLog(@"%@",adPath);
    [[YHTTPClient sharedYHTTPClient] GET:adPath parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        NSLog(@"enter");
        [self addDataSourea:responseObject[@"hotPosts"]];
        [self.tableview reloadData];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
}

-(void)addDataSourea:(NSArray *)Dic{
    _dataSource=[[NSMutableArray alloc]init];
    for (NSDictionary *dic in Dic) {
        NSMutableArray *arr =[[NSMutableArray alloc] init];
        NSArray *allkey =[dic allKeys];
        for (int i=1; i<=(int)allkey.count; i++) {
            NSString *index=[[NSString alloc]initWithFormat:@"%d",i];
            //NSLog(@"index is %@",index);
            NSDictionary *dict =dic[index];
            CommentModel *model =[[CommentModel alloc] initWithDict:dict];
            model.floor = index;
            [arr addObject:model];
        }
        [_dataSource addObject:arr];

    }
}

#pragma mark -- tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LayoutContainerView * container =[[LayoutContainerView alloc] initWithModelArray:_dataSource[indexPath.row]];
    return container.frame.size.height;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *ce=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    ce.selectionStyle = UITableViewCellSelectionStyleNone;
    LayoutContainerView * container =[[LayoutContainerView alloc] initWithModelArray:_dataSource[indexPath.row]];
    [ce.contentView addSubview:container];
    return ce;
    
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
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden=YES;
}
@end

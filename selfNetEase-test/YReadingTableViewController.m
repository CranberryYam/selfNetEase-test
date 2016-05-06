//
//  YReadingTableViewController.m
//  selfNetEase-test
//
//  Created by yihl on 3/26/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "ReadingTableViewCell.h"
#import "MJRefresh.h"
#import "YHTTPClient.h"
#import "YReadingTableViewController.h"

@interface YReadingTableViewController ()
@property (strong,nonatomic) NSMutableArray *NewsArray;
@end

@implementation YReadingTableViewController

- (void)viewDidLoad {
    [self.tableView endUpdates];
    [super viewDidLoad];
    self.NewsArray=[[NSMutableArray alloc]init];
    [self.tableView registerNib:[UINib nibWithNibName:@"ReadingTableViewCell" bundle:nil] forCellReuseIdentifier:@"YReadingFour"];
    [self loadData];
    [self setRresher];
}

-(void)setRresher{
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

-(void)loadData{
    NSString *wholeUrl=[NSString stringWithFormat:@"http://c.m.163.com//nc/article/%@/0-20.html",@"headline/T1348647853363"];
    [[YHTTPClient sharedYHTTPClient] GET:wholeUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        NSString *key = [responseObject.keyEnumerator nextObject];
        self.NewsArray = responseObject[key];
        //NSLog(@"self.NewsArray is %@",self.NewsArray);
       [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
    }];
}

-(void)loadMoreData{
    NSString *allUrlstring = [NSString stringWithFormat:@"http://c.m.163.com//nc/article/%@/%d-20.html",@"headline/T1348647853363",(int)(self.NewsArray.count - self.NewsArray.count%10)];
    [[YHTTPClient sharedYHTTPClient] GET:allUrlstring parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        NSString *key = [responseObject.keyEnumerator nextObject];
        NSMutableArray *NewsArrayMore=responseObject[key];

        NSMutableArray *array=[[NSMutableArray alloc]init];
        [array addObjectsFromArray:self.NewsArray];
        [array addObjectsFromArray:NewsArrayMore];
        
        self.NewsArray=array;
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"newstable %@", error);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.NewsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ReadingTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"YReadingFour"];
 [cell getDataFromDic:self.NewsArray[indexPath.row]];
    return cell;
}
#pragma mark - Table View delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.NewsArray[indexPath.row][@"ads"]) {
         return 480;
    }else{
        return 138
        ;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

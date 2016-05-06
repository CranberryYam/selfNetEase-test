//
//  YNewTableViewController.m
//  
//
//  Created by yihl on 2/1/16.
//
//
#import "MJRefresh.h"
#import "YNewsCell.h"
#import "YHTTPClient.h"
#import "YNewTableViewController.h"
#import "YWebviewViewController.h"
#import "PhotoSet2ViewController.h"

@interface YNewTableViewController ()
@property (nonatomic, strong) NSMutableArray *NewsArray;
@end

@implementation YNewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.NewsArray=[[NSMutableArray alloc]init];
    [self loadData];
    self.tableView.mj_header=[MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    self.tableView.mj_footer=[MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}


-(void)loadData{
    NSString *wholeUrl=[NSString stringWithFormat:@"http://c.m.163.com//nc/article/%@/0-20.html",self.urlString];
    [[YHTTPClient sharedYHTTPClient] GET:wholeUrl parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        NSString *key = [responseObject.keyEnumerator nextObject];
        self.NewsArray = responseObject[key];
         [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"%@",error);
    }];
}

-(void)loadMoreData{
    NSString *allUrlstring = [NSString stringWithFormat:@"http://c.m.163.com//nc/article/%@/%d-20.html",self.urlString,(int)(self.NewsArray.count - self.NewsArray.count%10)];
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
    return [self.NewsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellidentifier=[YNewsCell getIndentiferfrom:self.NewsArray[indexPath.row]];
    YNewsCell *cell=[tableView dequeueReusableCellWithIdentifier:cellidentifier];
    [cell getDataFromDic:self.NewsArray[indexPath.row]];
    return cell;
}
#pragma mark - Table View delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [YNewsCell getHeightfrom:self.NewsArray[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //scrollView.contentInset.top=(CGFloat)50;
    //self.navigationController.navigationBar.transform=CGAffineTransformMakeTranslation(0,-scrollView.contentOffset.y/5);
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSInteger x=self.tableView.indexPathForSelectedRow.row;
    if ([segue.destinationViewController isKindOfClass:[PhotoSet2ViewController class]]) {
    PhotoSet2ViewController *pc=[segue destinationViewController];
        pc.imageDic=self.NewsArray[x];
    }
   if ([segue.destinationViewController isKindOfClass:[YWebviewViewController class]]) {
        YWebviewViewController *webviewController=[segue destinationViewController];
        webviewController.docID=self.NewsArray[x][@"docid"];
       webviewController.boardid=self.NewsArray[x][@"boardid"];
    }

        // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


@end

//
//  YWebviewViewController.m
//  selfNetEase-test
//
//  Created by yihl on 2/18/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "KSBarrageView.h"
#import "CommentViewController.h"
#import "PhotoSetViewController.h"
#import "YHTTPClient.h"
#import "YWebviewViewController.h"

@interface YWebviewViewController ()<UIWebViewDelegate>
@property (strong, nonatomic) NSDictionary *content;
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) NSMutableArray *ImageArray;
@property (strong, nonatomic) NSArray *comment;
- (IBAction)backButton:(id)sender;
@end

@implementation YWebviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
    self.webView.delegate=self;
    self.webView.scrollView.bounces=NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)loadData{
    NSString *adPath=[NSString stringWithFormat:@"http://c.m.163.com/nc/article/%@/full.html", self.docID];
    //NSLog(@"self.docID is %@", self.docID);
    [[YHTTPClient sharedYHTTPClient] GET:adPath parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        self.content=responseObject[self.docID];
        //NSLog(@"response is %@", responseObject[self.docID]);
        [self showInWebView];
        [self loadCommentData];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"error is %@", error);
    }];
}

-(void)loadCommentData{
    NSString *adPath=[NSString stringWithFormat:@"http://comment.api.163.com/api/json/post/list/new/hot/%@/%@/0/10/10/2/2", self.boardid,self.docID];
    //NSLog(@"%@",adPath);
    [[YHTTPClient sharedYHTTPClient] GET:adPath parameters:nil progress:nil success:^(NSURLSessionDataTask *task, NSDictionary *responseObject){
        //NSLog(@"enter");
        self.comment=responseObject[@"hotPosts"];
        //NSLog(@"self.comment is %@",self.comment);
        [self addDanmu];
    }failure:^(NSURLSessionDataTask *task, NSError *error){
        
    }];
}

-(void)addDanmu{
    KSBarrageView *barrageView = [[KSBarrageView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 100)];
    barrageView.userInteractionEnabled=NO;
    [self.webView addSubview:barrageView];    
    [barrageView setDataArray:self.comment];
    [barrageView start];
}

- (void)showInWebView
{
    NSMutableString *html = [NSMutableString string];
    [html appendString:@"<html>"];
    [html appendString:@"<head>"];
    [html appendFormat:@"<link rel=\"stylesheet\" href=\"%@\">", [[NSBundle mainBundle] URLForResource:@"SXDetails.css" withExtension:nil]];
    [html appendString:@"</head>"];
    [html appendString:@"<body>"];
    [html appendString:[self buildBody]];
    [html appendString:@"</body>"];
    [html appendString:@"</html>"];
    [self.webView loadHTMLString:html baseURL:nil];
}

-(NSMutableString *)buildBody{
    NSMutableString *body=[NSMutableString string];
    [body appendFormat:@"<div class=\"title\">%@</div>", self.content[@"title"]];
    [body appendFormat:@"<div class=\"time\">%@</div>", self.content[@"ptime"]];
    [body appendString: self.content[@"body"]];
    //self.ImageArray=[[NSMutableArray alloc]init];
    for(NSDictionary *imgDic in self.content[@"img"]){
        //[self.ImageArray addObject:imgDic[@"src"]];
        NSMutableString *imgHtml=[NSMutableString string];
        [imgHtml appendString:@"<div class=\"img-parent\">"];
        NSArray *pixel = [imgDic[@"pixel"] componentsSeparatedByString:@"*"];
        CGFloat width = [[pixel firstObject]floatValue];
        CGFloat height = [[pixel lastObject]floatValue];
        // 判断是否超过最大宽度
        CGFloat maxWidth = self.webView.frame.size.width-10;
        if (width > maxWidth) {
            height = maxWidth / width * height;//等比缩小
            width = maxWidth;
        }
        NSString *onload=@"this.onclick = function() {"
                          " window.location.href = 'sx:src=' +this.src;"
                          "};";
        [imgHtml appendFormat:@"<img onload=\"%@\" width=\"%f\" height=\"%f\" src=\"%@\">",onload,width,height,imgDic[@"src"]];
        [imgHtml appendString:@"</div"];
        [body replaceOccurrencesOfString:imgDic[@"ref"] withString:imgHtml options:NSDiacriticInsensitiveSearch range:NSMakeRange(0, body.length)];
    }
    return body;
}

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *url=request.URL.absoluteString;
    NSRange range=[url rangeOfString:@"sx:src="];
    if (range.location != NSNotFound) {
        //NSInteger finishLocation=range.location+range.length;
        //NSString *imageURL=[url substringFromIndex:finishLocation];
        //[self savePicturesToAlbum:imageURL];
        //[self.navigationController pushViewController:[[UIStoryboard storyboardWithName:@"NEWS" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"PhotoSet"] animated:YES];
        [self performSegueWithIdentifier:@"WebToPhoto" sender:self];
        //NSLog(@"ImageArray is %@", self.ImageArray);
        return NO;
    }
    return YES;
    }

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[PhotoSetViewController class]]) {
        PhotoSetViewController *pc=segue.destinationViewController;
        pc.imageArray=self.content[@"img"];
    }
    if ([segue.destinationViewController isKindOfClass:[CommentViewController class]]) {
        CommentViewController *cc=segue.destinationViewController;
        cc.boardid=self.boardid;
        cc.docID=self.docID;
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


-(void)savePicturesToAlbum:(NSString *)imageUrl{
    //NSLog(@"src is **********%@", imageUrl);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        /*NSString *path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager *myFileManager=[NSFileManager defaultManager];
        NSDirectoryEnumerator *myDirectoryEnumerator;
        myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
        NSLog(@"用enumeratorAtPath:显示目录%@的内容：",path);
        while((path=[myDirectoryEnumerator nextObject])!=nil)
        { NSLog(@"%@",path); }*/
        
        /*NSURLCache *cache =[NSURLCache sharedURLCache];
        //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
        NSURLRequest *request= [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0f];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        UIImage *image = [UIImage imageWithData:imgData];*/
        
       /* NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];*/
        
       /* NSMutableURLRequest *request=[[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:imageUrl]];
        NSURLSession *session=[NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        NSURLSessionTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            NSLog(@"error is %@", error);
            
            UIImageView *imageview=[[UIImageView alloc]init];
            imageview.backgroundColor=[UIColor blueColor];
            UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
            [win addSubview:imageview];
            CGRect selfFram=imageview.frame;
            selfFram.origin=CGPointMake(0, 200);
            selfFram.size=CGSizeMake(200, 200);
            imageview.frame=selfFram;
            imageview.image=[UIImage imageWithData:data];
            
            //UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        
        
        }];
        [task resume];*/
        
        
        NSString *path=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSFileManager *myFileManager=[NSFileManager defaultManager];
        NSDirectoryEnumerator *myDirectoryEnumerator;
        myDirectoryEnumerator=[myFileManager enumeratorAtPath:path];
        NSLog(@"用enumeratorAtPath:显示目录%@的内容：",path);
        while((path=[myDirectoryEnumerator nextObject])!=nil)
        { NSLog(@"%@",path); }
        
        NSURLCache *cache =[NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
        NSData *imgData = [cache cachedResponseForRequest:request].data;
        UIImage *image = [UIImage imageWithData:imgData];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);

           }]];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)image:(UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    NSLog(@"SAVE IMAGE COMPLETE");
    if(error != nil) {
        NSLog(@"ERROR SAVING:%@",[error localizedDescription]);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden=NO;
}
@end

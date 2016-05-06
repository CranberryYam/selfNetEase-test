//
//  PhotoSetViewController.m
//  selfNetEase-test
//
//  Created by yihl on 2/24/16.
//  Copyright © 2016 yihl. All rights reserved.
//
#import "SDImageCache.h"
#import "UIImageView+WebCache.h"
#import "PhotoSetViewController.h"

@interface PhotoSetViewController ()<UIScrollViewDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *pageLabel;
- (IBAction)downloadButtonAction:(id)sender;

@end

@implementation PhotoSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //NSLog(@"self.imageArray is %@", self.imageArray);
    [self buildScrollView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    self.tabBarController.tabBar.hidden = YES;
}

-(void)buildScrollView{
    [self.scrollView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(quitViewController)]];
    self.scrollView.backgroundColor=[UIColor blackColor];
    CGFloat contentSizeWidth=self.imageArray.count*self.scrollView.frame.size.width;
    self.scrollView.contentSize=CGSizeMake(contentSizeWidth, 0);
    self.scrollView.pagingEnabled=YES;
    self.scrollView.showsHorizontalScrollIndicator=NO;
    self.scrollView.delegate=self;
    NSArray *pixel = [self.imageArray[0][@"pixel"] componentsSeparatedByString:@"*"];
    CGFloat width = [[pixel firstObject]floatValue];
    CGFloat height = [[pixel lastObject]floatValue];
    CGFloat secondWidth = self.scrollView.frame.size.width;
        height = secondWidth / width * height;
        width = secondWidth;
    UIImageView *imageview=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height)];
    imageview.contentMode=UIViewContentModeCenter;
    imageview.contentMode=UIViewContentModeScaleAspectFit;
    [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageArray[0][@"src"]] placeholderImage:[UIImage imageNamed:@"302.png"]];
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
        [imageview sd_setImageWithURL:[NSURL URLWithString:self.imageArray[index][@"src"]] placeholderImage:[UIImage imageNamed:@"302.png"]];
        [self.scrollView addSubview:imageview];
        NSString *countNum = [NSString stringWithFormat:@"%ld/%ld",index+1,self.imageArray.count];
        self.pageLabel.text=countNum;
    }
}

-(void)quitViewController{
    [self.navigationController popViewControllerAnimated:YES];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    self.tabBarController.tabBar.hidden=NO;
}

- (void)savePictureToAlbum:(NSString *)src
{   NSLog(@"src is **********%@", src);
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定要保存到相册吗？" preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSURLCache *cache =[NSURLCache sharedURLCache];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:src]];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)downloadButtonAction:(id)sender {
    NSInteger index=(self.scrollView.contentOffset.x/self.scrollView.frame.size.width);
    if (index<self.imageArray.count) {
        SDImageCache *cache=[SDImageCache sharedImageCache];
        if([cache diskImageExistsWithKey:self.imageArray[index][@"src"]]){
            NSString *path=[cache defaultCachePathForKey:self.imageArray[index][@"src"]];
            NSData *data=[NSData dataWithContentsOfFile:path];
            UIImage *image=[UIImage imageWithData:data];
           /* UIImageView *rightItem=[[UIImageView alloc]initWithImage:image];
            rightItem.backgroundColor=[UIColor greenColor];
            UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
            [win addSubview:rightItem];
            CGRect selfFram=rightItem.frame;
            selfFram.origin=CGPointMake(100, 100);
            selfFram.size=CGSizeMake(100, 100);
            rightItem.frame=selfFram;*/
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
          
        }

       //[self savePictureToAlbum:self.imageArray[index][@"src"]];
    }
}
@end

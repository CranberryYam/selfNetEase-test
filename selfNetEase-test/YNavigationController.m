//
//  YNavigationController.m
//  SearchView-test
//
//  Created by yihl on 3/14/16.
//  Copyright © 2016 yihl. All rights reserved.
//

#import "YNavigationController.h"

@interface YNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation YNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.interactivePopGestureRecognizer.delegate = self;
    [self changeNavBar];
    [self addWholeScreenPopGesture];
}

-(void)changeNavBar{
    //self.navigationBar.backgroundColor=[UIColor redColor];
}

-(void)addWholeScreenPopGesture{
    //id target=self.navigationController.interactivePopGestureRecognizer.delegate;
    id target = self.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:@selector(handleNavigationTransition:)];
    pan.delegate = self;
   [self.view addGestureRecognizer:pan];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}



- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer*)gestureRecognizer
{
    
    if (self.childViewControllers.count == 1) {
        return false;
    }
    return true;
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

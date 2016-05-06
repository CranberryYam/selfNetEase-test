//
//  MenuHrizontal.h
//  ShowProduct
//
//  Created by lin on 14-5-22.
//  Copyright (c) 2014年 @"". All rights reserved.
//

#import <UIKit/UIKit.h>

#define NOMALKEY   @"normalKey"
#define HEIGHTKEY  @"helightKey"
#define TITLEKEY   @"titleKey"
#define TITLEWIDTH @"titleWidth"
#define TOTALWIDTH @"totalWidth"

@protocol MenuHrizontalDelegate <NSObject>
@optional
-(void)didMenuHrizontalClickedButtonAtIndex:(NSInteger)aIndex;//Purpose: when clicked button changes, let views under Menu change at the same time
@end

@interface MenuHrizontal : UIView
{
    NSMutableArray        *mButtonArray;
    NSMutableArray        *mItemInfoArray;
    UIScrollView          *mScrollView;
    float                 mTotalWidth;
}

@property (nonatomic,assign) id <MenuHrizontalDelegate> delegate;

#pragma mark 初始化菜单
- (id)initWithFrame:(CGRect)frame ButtonItems:(NSArray *)aItemsArray;
-(void)createMenuItems:(NSArray *)aItemsArray;
#pragma mark 选中某个button
-(void)clickButtonAtIndex:(NSInteger)aIndex;//Purpose: when HomeView firstly use Menu, set the first button of Menu was chosed
#pragma mark 改变第几个button为选中状态，不发送delegate
-(void)changeButtonStateAtIndex:(NSInteger)aIndex;//Purpose: when swipe views under Menu, chosed button (not by clicking the button directly) changed at the same time

@end

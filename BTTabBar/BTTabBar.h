//
//  BTTabBar.h
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-14.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTTabBarItem.h"
@protocol BTTabBarDelegate <NSObject>

-(void)clickTabBarItem:(BTTabBarItem *)sender;

@end


@interface BTTabBar : UIView



@property(nonatomic,copy)   NSArray             *items;

@property(nonatomic,assign) BTTabBarItem        *selectedItem;

@property (nonatomic, assign) id <BTTabBarDelegate> tabBarDelegate;

//滑动选择按钮
- (void)clickItemAtIndex:(NSInteger)index;

@end

//
//  BTTabBarController.h
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-10.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BTTabBar.h"
@interface BTTabBarController : UIViewController

@property (nonatomic, retain) NSArray *tabBarItemModelArray;


@property(nonatomic,readonly) BTTabBar *tabBar;
@property (nonatomic, readonly, assign) UIViewController *selectedViewController;
@property(nonatomic) NSUInteger selectedIndex;



+(BTTabBarController *)sharedTabBarController;

-(void)setBadgeValue:(NSString *)value atIndex:(NSUInteger)index;

//-(void)setSelectedViewControllerAtIndex:(UIViewController *)selectedViewController

@end
//四、UITabBarController的Rotation
//　　UITabBarController默认只支持竖屏，当设备方向放生变化时候，它会查询viewControllers中包含的所有ViewController，仅当所有的viewController都支持该方向时，UITabBarController才会发生旋转，否则默认的竖向。
//　　此处需要注意当UITabBarController支持旋转，而且发生旋转的时候，只有当前显示的viewController会接收到旋转的消息。
//
//  ViewController.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-10.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "ViewController.h"
#import "BTTabBarController.h"
#import "BTNavigationController.h"
#import "BTOneViewController.h"
#import "BTTwoViewController.h"
@interface ViewController ()<UITabBarControllerDelegate>
{
    BTTabBarController *tabCtl;
}
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    tabCtl = [[BTTabBarController alloc] init];
    //   tabCtl.delegate = self;
    
    BTOneViewController *one = [[BTOneViewController alloc] init];
    UINavigationController *nav1 = [[UINavigationController alloc] initWithRootViewController:one];
    UITabBarItem *item = [[UITabBarItem alloc] initWithTitle:@"one" image:[UIImage imageNamed:@"tabbar_home"] tag:0];
    //[[UITabBarItem alloc] initWithTitle:@"one" image:[UIImage imageNamed:@"tabbar_home"] selectedImage:[UIImage imageNamed:@"tabbar_home_selected"]];
    item.badgeValue = @"3";
    nav1.tabBarItem = item;
    nav1.delegate = tabCtl;
    
    
    
    BTTwoViewController *two = [[BTTwoViewController alloc] init];
    UINavigationController *nav2 = [[UINavigationController alloc] initWithRootViewController:two];
    item = [[UITabBarItem alloc] initWithTitle:@"two" image:[UIImage imageNamed:@"tabbar_profile"] tag:1];
    //[[UITabBarItem alloc] initWithTitle:@"two" image:[UIImage imageNamed:@"tabbar_profile"] selectedImage:[UIImage imageNamed:@"tabbar_profile_selected"]];
    nav2.tabBarItem = item;
    nav2.delegate = tabCtl;
    
  //  tabCtl.childViewControllers = @[nav1,nav2];
    
    
    [self.view addSubview:tabCtl.view];


}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
 }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

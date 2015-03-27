//
//  AppDelegate.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-10.
//  Copyright (c) 2014年 ___FULLUSERNAME___. All rights reserved.
//

#import "AppDelegate.h"
#import "BTBaseViewController.h"
#import "BTTabBarItemModel.h"
#import "BTTabBarController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    
    BTTabBarController *tab = [BTTabBarController sharedTabBarController];
    BTTabBarItemModel *model1  = [BTTabBarItemModel tabBarItemModelTitle:@"第一个" controllerName:@"BTTwoViewController" imageName:@"tabbar_home" selectedImageName:@"tabbar_home_selected"];
    
    BTTabBarItemModel *model2  = [BTTabBarItemModel tabBarItemModelTitle:@"第2个" controllerName:@"BTOneViewController" imageName:@"tabbar_profile" selectedImageName:@"tabbar_profile_selected"];
    
    BTTabBarItemModel *model3  = [BTTabBarItemModel tabBarItemModelTitle:@"第3个" controllerName:@"BTBaseViewController" imageName:@"tabbar_message_center" selectedImageName:@"tabbar_message_center_highlighted"];
    tab.tabBarItemModelArray = @[model1,model2];
    
    //    BTBaseViewController *ctl = [[BTBaseViewController alloc] init];
    self.window.rootViewController = tab;

    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end

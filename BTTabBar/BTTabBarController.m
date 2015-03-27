//
//  BTTabBarController.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-10.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTTabBarController.h"
#import "BTTabBarItemModel.h"
#import "BTNavigationController.h"
@interface BTTabBarController ()<UINavigationControllerDelegate,BTTabBarDelegate>

@end

@implementation BTTabBarController

+(BTTabBarController *)sharedTabBarController
{
    static BTTabBarController *tabBarController = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tabBarController = [[BTTabBarController alloc] init];
    });
    return tabBarController;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    
    _tabBar = [[BTTabBar alloc] init];
    _tabBar.tabBarDelegate = self;
    [self.view addSubview:self.tabBar];
    
    [self initlizeTabbarControllerData];
    
    [_tabBar clickItemAtIndex:0];
}

-(void)initlizeTabbarControllerData
{
    NSMutableArray *tabbarItems = [NSMutableArray arrayWithCapacity:_tabBarItemModelArray.count];
    int i=0;
    for(BTTabBarItemModel *model in _tabBarItemModelArray)
    {
        BTTabBarItem *item = [BTTabBarItem tabBarItemTitle:model.title image:[UIImage imageNamed:model.imageName] selectedImage:[UIImage imageNamed:model.selectedImageName] tag:i++];
        [tabbarItems addObject:item];
        
        
        Class ctlClass = NSClassFromString(model.controllerName);
        BTBaseViewController *ctl = [[ctlClass alloc] init];
        BTNavigationController *nav = [[BTNavigationController alloc] initWithRootViewController:ctl];;
        [self addChildViewController:nav];
    }
    
    _tabBar.items = tabbarItems;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGRect rect = self.tabBar.frame;
    rect.origin.y = self.view.frame.size.height - rect.size.height;
    self.tabBar.frame = rect;
    
    [self.view bringSubviewToFront:self.tabBar];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



//设置badgeValue
-(void)setBadgeValue:(NSString *)value atIndex:(NSUInteger)index
{
    BTTabBarItem *item = [_tabBar.items objectAtIndex:index];
    [item setBadgeValue:value];
}


#pragma  mark -- BTTabBarDelegate

-(void)clickTabBarItem:(BTTabBarItem *)sender
{
    [self showChildViewAtIndex:sender.tag];
}


-(void)showChildViewAtIndex:(NSInteger)index
{
    UIViewController *childViewController = [self.childViewControllers objectAtIndex:index];
    
    //这里需要特别注意，因为在ios7以上self.view.frame.origin.y = 0。但在ios7以下，self.view.frame.origin.y = 20.
    //如下写法导致，如果是ios7以上，保持与默认不变。但在ios7以下，frame就是applicationFrame大小
    childViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:childViewController.view];
    
    _selectedViewController = childViewController;
    _selectedIndex = index;
    
    UIView *rootView = [childViewController.view viewWithTag:kRootViewTag];
    [rootView addSubview:self.tabBar];
}



#pragma mark -- UINavigationControllerDelegate


- (void)hideTabBar {
    
    if (self.tabBar.hidden) {
        return ;
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect tabFrame = self.tabBar.frame;
        tabFrame.origin.y += tabFrame.size.height;
        self.tabBar.frame = tabFrame;
        
    } completion:^(BOOL finished) {
        self.tabBar.hidden = YES;
    }];
}

- (void)showTabBar {

    if (!self.tabBar.hidden) {
        return;
    }
    self.tabBar.hidden = NO;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        
        CGRect tabFrame = self.tabBar.frame;
        tabFrame.origin.y -= tabFrame.size.height;
        self.tabBar.frame = tabFrame;
        
    } completion:^(BOOL finished) {
        
    }];
    
}


////在点击了导航条的rightBarButtonItem时，实现隐藏标签的功能
//- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
//{
//    if (viewController.hidesBottomBarWhenPushed) {
//        [leveyTabBarController hidesTabBar:YES animated:YES];
//    }else
//    {
//        [leveyTabBarController hidesTabBar:NO animated:YES];
//    }
//}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

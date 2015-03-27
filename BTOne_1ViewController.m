//
//  BTOne_1ViewController.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-10.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTOne_1ViewController.h"
#import "BTOne_2ViewController.h"
@interface BTOne_1ViewController ()
{
    UIImageView *img ;
}
@end

@implementation BTOne_1ViewController

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

    
    UIBarButtonItem *addItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:nil];
    
    UIBarButtonItem *saveItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:nil];
    
    UIBarButtonItem *editItem=[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:nil];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(0, 0, 100, 20);
    [btn1 setTitle:@"UILayoutContainerView" forState:UIControlStateNormal];
    UIBarButtonItem *btnitem1 = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    
    
    
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(0, 0, 100, 20);
    [btn2 setTitle:@"UILayoutContainerView" forState:UIControlStateNormal];
    UIBarButtonItem *btnitem2 = [[UIBarButtonItem alloc] initWithCustomView:btn2];
    
    
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(0, 0, 100, 20);
    [btn3 setTitle:@"UILayoutContainerView" forState:UIControlStateNormal];
    UIBarButtonItem *btnitem3 = [[UIBarButtonItem alloc] initWithCustomView:btn3];
    
    
    
    NSArray *items=[NSArray arrayWithObjects:addItem,saveItem,editItem,btnitem1,btnitem2,btnitem3,nil];
    
    UIToolbar *toolBar=[[UIToolbar alloc]initWithFrame:CGRectMake(0,self.view.frame.size.height-49,320,20)] ;
    
    toolBar.barStyle=UIBarButtonItemStylePlain;
    toolBar.items = items;
    
    [self.view addSubview:toolBar];
    
    
    
    
    
    CGRect barRect = self.btNavigationBar.frame;
    
    CGRect rect = CGRectMake(0,barRect.origin.y + barRect.size.height , barRect.size.width, self.view.frame.size.height - barRect.origin.y - barRect.size.height );
    
    img = [[UIImageView alloc] initWithFrame:rect];
    img.image = [UIImage imageNamed:@"GLIP2"];
    [self.view addSubview:img];
    
    
    NSLog(@"frame:%@  \n  %@\n",self.view,img);
    
    
    
    
    UITabBar *tabbar = [[UITabBar alloc] initWithFrame:CGRectMake(0, 200, 320, 20)];
    UITabBarItem *one = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    UITabBarItem *two = [[ UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemHistory tag:1];
    tabbar.delegate = self;
    [tabbar setItems:@[one,two]];
    
    [self.view addSubview:tabbar];
    
    // Do any additional setup after loading the view.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item // called when a new view is selected by the user (but not programatically)
{
    if (item.tag == 0) {
        item.badgeValue = @"0";
    }else{
        item.badgeValue = @"10";
    }
    
    
//    UIView *bar = self.navigationController.navigationBar;
//    [UIView animateWithDuration:0.25 animations:^{
//        bar.frame = CGRectMake(0, -44, 320, 44);
//    } completion:^(BOOL finished) {
//        img.frame = CGRectMake(0, 20, 320, self.view.frame.size.height - 20);
//    }];
//    
    
    BTOne_2ViewController *two = [[BTOne_2ViewController alloc] init];
    [self.navigationController pushViewController:two animated:YES];
    
    
    
}
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    self.tabBarController.tabBar.hidden = YES;
//}

-(void)viewDidAppear:(BOOL)animated
{
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        
//        
//        UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 44)];   //设置导航栏界面
//        
//        UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"登录"];  //初始化并设置title
//        UIBarButtonItem *rightBarbutton = [[UIBarButtonItem alloc] initWithTitle:@"注册" style:UIBarButtonItemStyleBordered target:self action:@selector(signin)];
//        
//        navigationItem.rightBarButtonItem = rightBarbutton;
//        
//        [navigationBar pushNavigationItem:navigationItem animated:YES];
//        
//        [self.view addSubview:navigationBar];
//        
//
//        
//    });
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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

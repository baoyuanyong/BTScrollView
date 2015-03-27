//
//  BTTwoViewController.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-10.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTTwoViewController.h"
#import "TestViewController.h"
#import "BTTabBarController.h"
@interface BTTwoViewController ()

@end

@implementation BTTwoViewController

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
    
    self.navTitle = @"two";
    
    self.btNavigationBar.leftBarButtonItem = nil;
    
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(100, 100, 50, 50);
//    [btn setTitle:@"next" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
//    self.btNavigationBar.rightBarButtonItem = btn;
//    self.btNavigationBar.backgroundColor = [UIColor grayColor];
//    
//    self.view.backgroundColor = [UIColor whiteColor];

    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(100, 100, 150, 50);
    [btn setTitle:@"显示图片墙" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn];
}


-(void)click
{
    
    BTTabBarController *tabCtl = [BTTabBarController sharedTabBarController];
    [tabCtl setBadgeValue:@"5" atIndex:1];
    
    
    
    TestViewController *ctl = [[TestViewController alloc] init];
    [self.btNavigationController pushViewController:ctl animated:YES];
    [ctl release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
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

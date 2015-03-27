//
//  BTBaseViewController.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-14.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTBaseViewController.h"
#import "BTTabBarItem.h"
#import "BTTabBar.h"
#define kStatusBarViewTag  1001

@interface BTBaseViewController ()

@end

@implementation BTBaseViewController

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
    
    if (isIOS7) {
        UIView *statusBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenBound.size.width, 20)];
        [self.view addSubview:statusBarView];
        statusBarView.tag = kStatusBarViewTag;
        statusBarView.backgroundColor = [UIColor whiteColor];
        [statusBarView release];
    }

    self.showNavigationBar = YES;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *backNormal = [UIImage imageNamed:@"GLN_navBut_返回"];
    UIImage *backHighlighted = [UIImage imageNamed:@"GLN_navBut_返回sel"];
    btn.frame = CGRectMake(0, 0, backNormal.size.width, backNormal.size.height);
    [btn setImage:backNormal forState:UIControlStateNormal];
    [btn setImage:backHighlighted forState:UIControlStateHighlighted];
    [btn addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.btNavigationBar setLeftBarButtonItem:btn];
    
    
    
    self.view.backgroundColor = [UIColor whiteColor];
}

-(void)setShowNavigationBar:(BOOL)showNavigationBar
{
    _showNavigationBar = showNavigationBar;
    
    if (showNavigationBar && !_btNavigationBar) {
        
        _btNavigationBar = [[BTNavigationBar alloc] initWithFrame:CGRectZero];
        [self.view addSubview:_btNavigationBar];
    }
    else if (!showNavigationBar){
        _btNavigationBar.hidden = YES;
    }
}
-(void)setNavTitle:(NSString *)navTitle
{
    [_navTitle release];
    _navTitle = [navTitle copy];
    
    self.btNavigationBar.title = _navTitle;
}
-(CGFloat)btNavigationBarBottomLine
{
    return _btNavigationBar.frame.origin.y + _btNavigationBar.frame.size.height;
}

-(void)goBack
{
    [self.btNavigationController popViewControllerAnimated:YES];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(isIOS7){
        UIView *statusBarView = [self.view viewWithTag:kStatusBarViewTag];
        [self.view bringSubviewToFront:statusBarView];
    }
    [self.view bringSubviewToFront:_btNavigationBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

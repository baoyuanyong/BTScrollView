//
//  BTOneViewController.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-10.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTOneViewController.h"
#import "BTOne_1ViewController.h"
@interface BTOneViewController ()

@end

@implementation BTOneViewController

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
    

    self.showNavigationBar = YES;
    
    self.navTitle = @"one";
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setTitle:@"alert" forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 40, 40);
    leftBtn.backgroundColor = [UIColor lightGrayColor];
    [leftBtn addTarget:self action:@selector(alert) forControlEvents:UIControlEventTouchUpInside];
    self.btNavigationBar.leftBarButtonItem = leftBtn;
    
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"next" forState:UIControlStateNormal];
    rightBtn.frame = CGRectMake(0, 0, 40, 40);
    rightBtn.backgroundColor = [UIColor lightGrayColor];
    [rightBtn addTarget:self action:@selector(next) forControlEvents:UIControlEventTouchUpInside];

    
    self.btNavigationBar.rightBarButtonItem = rightBtn;
    
 //   self.navigationController.navigationBarHidden = YES;
    
    
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:self.view.frame];
    img.image = [UIImage imageNamed:@"GLIP1"];
    
    [self.view addSubview:img];
}


-(void)next
{
    BTOne_1ViewController *one = [[BTOne_1ViewController alloc] init];
    one.hidesBottomBarWhenPushed = YES;
    [self.btNavigationController pushViewController:one animated:YES];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)alert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"msg" message:@"hello" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:@"cancel", nil];
    [alert show] ;
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

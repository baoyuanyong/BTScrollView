//
//  BTOne_2ViewController.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-12.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTOne_2ViewController.h"

@interface BTOne_2ViewController ()

@end

@implementation BTOne_2ViewController

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
    
    
    
    UIImageView *img = [[[UIImageView alloc] initWithFrame:self.view.frame] autorelease];
    img.image = [UIImage imageNamed:@"GLIP3.jpeg"];
    [self.view addSubview:img];

    // Do any additional setup after loading the view.
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

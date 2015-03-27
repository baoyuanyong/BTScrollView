//
//  BTBaseViewController.h
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-14.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTNavigationBar.h"
#import "BTNavigationController.h"

@interface BTBaseViewController : UIViewController

@property (nonatomic,assign) BOOL showNavigationBar;

@property (nonatomic, retain) BTNavigationBar *btNavigationBar;

@property (nonatomic, assign) CGFloat btNavigationBarBottomLine;

@property (nonatomic, assign) BTNavigationController *btNavigationController;

@property (nonatomic, copy) NSString *navTitle;

@end

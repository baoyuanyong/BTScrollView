//
//  BTNavigationController.h
//  CustomNavBarTest
//
//  Created by 鲍远勇 on 14-9-9.
//  Copyright (c) 2014年 YingYing. All rights reserved.
//

#import <UIKit/UIKit.h>



@class BTBaseViewController;

@interface BTNavigationController : UIViewController


@property(nonatomic,retain) NSMutableArray *viewControllers; // The current view controller stack.


// 默认为特效开启
@property (nonatomic, assign) BOOL canDragBack;

- (id)initWithRootViewController:(BTBaseViewController *)rootViewController; // Convenience method pushes the root view controller without animation.

- (void)pushViewController:(BTBaseViewController *)viewController animated:(BOOL)animated; // Uses a horizontal slide transition. Has no effect if the view controller is already in the stack.

- (void)popViewControllerAnimated:(BOOL)animated; // Returns the popped controller.
- (NSArray *)popToViewController:(BTBaseViewController *)viewController animated:(BOOL)animated; // Pops view controllers until the one specified is on top. Returns the popped controllers.
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated; // Pops until there's only a single view controller left on the stack. Returns the popped controllers.



@end

//
//  BTNavigationBar.h
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-15.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTNavigationBar : UIView

@property(nonatomic,copy)   NSString        *title;             // Title when topmost on the stack. default is nil
@property(nonatomic,retain) UIView          *titleView;         // Custom view to use in lieu of a title. May be sized horizontally. Only used when item is topmost on the stack.

@property(nonatomic,copy) NSArray *leftBarButtonItems NS_AVAILABLE_IOS(5_0);
@property(nonatomic,copy) NSArray *rightBarButtonItems NS_AVAILABLE_IOS(5_0);

@property(nonatomic,retain) UIButton *leftBarButtonItem;
@property(nonatomic,retain) UIButton *rightBarButtonItem;

@end

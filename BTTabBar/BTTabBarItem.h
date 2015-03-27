//
//  BTTabBarItem.h
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-14.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTabBarItemRect CGRectMake(0, 0, 50, 45)


@interface BTTabBarItem : UIButton


+(id)tabBarItemTitle:(NSString *)title image:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag;
@property(nonatomic,copy) NSString *badgeValue;    // default is nil

@end

//
//  BTTabBarItemModel.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-15.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTTabBarItemModel.h"

@implementation BTTabBarItemModel


+(BTTabBarItemModel *)tabBarItemModelTitle:(NSString *)title controllerName:(NSString *)controllerName imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    BTTabBarItemModel *model = [[BTTabBarItemModel alloc] init];
    model.title = title;
    model.controllerName = controllerName;
    model.imageName = imageName;
    model.selectedImageName = selectedImageName;
    return [model autorelease];
}
-(void)dealloc
{
    self.title = nil;
    self.controllerName = nil;
    self.imageName = nil;
    self.selectedImageName = nil;
    [super dealloc];
}

@end

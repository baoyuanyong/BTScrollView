//
//  BTTabBarItemModel.h
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-15.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTTabBarItemModel : NSObject

@property (nonatomic, assign) NSInteger itemIndex;//item 对应的索引(程序自己计算)
@property (nonatomic, copy) NSString *controllerName;//item 对应控制器类名
@property (nonatomic, copy) NSString *imageName;// item 对应图片名称(未选中状态)
@property (nonatomic, copy) NSString *title;// item 对应标题
@property (nonatomic, copy) NSString *selectedImageName;//item 选中状态下图片名

+(BTTabBarItemModel *)tabBarItemModelTitle:(NSString *)title controllerName:(NSString *)controllerName imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName;

@end

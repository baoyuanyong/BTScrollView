//
//  BTTabBar.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-14.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTTabBar.h"


#define kScreenBound     [[UIScreen mainScreen] bounds]

#define kTabBarFrame CGRectMake(0,100,kScreenBound.size.width,kTabBarItemRect.size.height)

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface BTTabBar ()
{
    NSInteger _currentIndex;        //点击按钮选择名字ID
}

@property (nonatomic, retain) NSArray *titlesArray;

@end


@implementation BTTabBar

@synthesize titlesArray;


-(id)initWithFrame:(CGRect)frame
{

  //  CGRect rect =
    self =[super initWithFrame:kTabBarFrame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}
-(void)setItems:(NSArray *)items
{
    [_items release];
    _items = [items retain];
    
    CGFloat space = (self.frame.size.width - _items.count*kTabBarItemRect.size.width)/(2*_items.count);
    for (int i = 0; i < _items.count; i++) {
        
        BTTabBarItem *item = [_items objectAtIndex:i];
        item.frame = CGRectMake(space*(2*i + 1)+i*kTabBarItemRect.size.width, 0, kTabBarItemRect.size.width, kTabBarItemRect.size.height);
        [self addSubview:item];
        [item addTarget:self action:@selector(clickItem:) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)clickItem:(BTTabBarItem *)sender
{
    for(BTTabBarItem *item in _items)
    {
        item.selected = NO;
    }
    sender.selected = YES;
    
    [self.tabBarDelegate clickTabBarItem:sender];
}

-(void)clickItemAtIndex:(NSInteger)index
{
    BTTabBarItem *item = [_items objectAtIndex:index];
    [self clickItem:item];
}



@end
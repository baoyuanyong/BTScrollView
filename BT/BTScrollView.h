//
//  BTScrollView.h
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BTBaseItem.h"

@class BTScrollView;

@protocol BTScrollViewDelegate <NSObject>

@optional

//BTScrollView
//默认的点击整个cell的回调
-(void)clickScrollViewBaseItem:(BTBaseItem *)baseItem;
//点击cell上某个控件的回调
-(void)clickScrollViewBaseCellBtnItem:(BTBaseItem *)baseItem sender:(id)sender;

//BTRefreshScrollView
//下拉刷新
- (void)pullDownTriggerHeaderRefresh:(BTScrollView*)pullTableView;
//上拉加载更多
- (void)pullUpLoadMore:(BTScrollView*)pullTableView;

@end



@interface BTScrollView : UIScrollView<BTBaseItemDelegate>

//@property (nonatomic, readonly, assign) BOOL isMovingDown;

@property (nonatomic, assign) id<BTScrollViewDelegate> scrollViewDelegate;

@property (nonatomic, retain) NSArray *sectionArray;//设置数据的时候，就会进行数据的布局

-(void)removeSectionAtIndex:(NSInteger)index;
-(void)insertSection:(BTSection *)section atIndex:(NSInteger)index;
-(void)appendSection:(BTSection *)section;

-(NSMutableArray *)getItemsInScreen;

-(void)showItemsInScreenOffsetY:(CGFloat)offsetY;
@end

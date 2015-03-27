//
//  BTSectionItem.h
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTBaseItem.h"

/***
*
*BTSection负责管理一个section。
*
*section管理cellItemsArray
*cellItemsArray应该分成两种。 所有的item都占据一行，或所有的item都不独占一行
*这样只有通过，占据一行和不占据一行的section混用，即可组合实现各种需求
****/
@protocol BTSectionDelegate <NSObject>

//将要布局
-(void)sectionWillCalculateItemsFrame:(BTSection *)section;

//
-(void)section:(BTSection *)section WillRemoveItems:(NSArray *)removeItems;
-(void)section:(BTSection *)section WillReplaceItem:(BTBaseItem *)replacedItem;

//已经布局
-(void)sectionDidCalculateItemsFrame:(BTSection *)section animated:(BOOL)animated;


@end

#define kMaxColumn  5

@interface BTSection : NSObject

@property (nonatomic, assign, readonly) CGFloat offsetY;
@property (nonatomic, assign) NSInteger sectionIndex;
@property (nonatomic, assign) NSInteger numCols;//多少列。numCols=1,相当于section.  numCols!=1 ,实现图片墙
@property (nonatomic, assign) CGFloat colWidth;//每一列的宽度
@property (nonatomic, assign) CGFloat marginLeft,marginRight,marignTop,mariginBottom;//cell整体距离上下左右的距离
@property (nonatomic, assign) CGFloat cellXGap,cellYGap;//cell之间水平和垂直之间的距离


/**
 * baseItems:
 *
 * 首次为BTSection赋值时，直接设置baseItems.此时并没有处理数据成员直接的链接关系。
 * 布局之后，如果需要对baseItems的数据成员进行操作，调用相应的方法，而不要再直接对baseItems进行操作。
 * 因为修改baseItems的数据成员时，还要修改成员直接的链接关系
 *
 **/
@property (nonatomic, retain) NSMutableArray *baseItems;



@property (nonatomic, assign) id<BTSectionDelegate> sectionDelegate;

-(CGFloat)getEndLine;
-(NSArray *)getHeaderItems;

/**
 * 获取某一列的第一个元素
 **/
-(BTBaseItem *)getFirstColumnItem:(NSInteger)index;

/**
 * 获取某一列的最后一个元素
 **/
-(BTBaseItem *)getLastColumnItem:(NSInteger)index;

//布局内部的item项时,传入起始偏移量
-(void)calculateItemsFrameWithOffsetY:(CGFloat)offsetY sectionNumber:(NSInteger)sectionNum;



-(BOOL)appendItems:(NSArray *)appendItems animated:(BOOL)animated;
-(BOOL)removeItemsInRange:(NSRange)range animated:(BOOL)animated;
-(BOOL)insertItems:(NSArray *)insertItems atIndex:(NSInteger)index animated:(BOOL)animated;
-(BOOL)replaceItemAtIndex:(NSInteger)index withItem:(BTBaseItem *)newItem animated:(BOOL)animated;

@end

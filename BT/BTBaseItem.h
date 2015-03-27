//
//  BTBaseItem.h
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BTBaseCell.h"


@class BTBaseItem;
@class BTSection;

@protocol BTBaseItemDelegate <NSObject>

//默认的点击整个cell的回调
-(void)clickBaseItem:(BTBaseItem *)baseItem;

//点击cell上某个控件的回调
-(void)clickBaseCellBtnItem:(BTBaseItem *)baseItem sender:(id)sender;
@end


@interface BTBaseItem : NSObject<BTBaseCellDelegate>

@property (nonatomic, assign) CGFloat itemHeight;//布局前需要确定itemHeight
@property (nonatomic, retain) Class cellClass;
@property (nonatomic, retain) id itemData;

//通过preItem和nextItem，让section成员形成一个链表
@property (nonatomic, assign) BTBaseItem *preItem,*nextItem;
@property (nonatomic, assign) BTBaseItem *belowItem,*aboveItem;

@property (nonatomic, assign) CGRect itemFrame;//布局后，具体的itemFrame
@property (nonatomic, assign) NSInteger index;//在当前section中的index
@property (nonatomic, assign) NSInteger column;//在当前section中的列

@property (nonatomic, retain) BTBaseCell *currentCell;
@property (nonatomic, assign) BTSection *parentSection;


@property (nonatomic, assign) NSInteger type;//具体页面可根据设置的type,区分数据来源


@property (nonatomic, assign) BOOL isHeader;//是否是要粘贴到头部
@property (nonatomic, assign) BTBaseItem *preSectionItem;
@property (nonatomic, assign) BTBaseItem *nextSectionItem;





//当需要cell内的btn与controller交互是，将此设为对应的控制器
@property (nonatomic, assign) id delegateController;

@property (nonatomic, assign) id<BTBaseItemDelegate> baseItemDelegate;

//让cell加载相应数据
-(void)refreshItemWithData:(id)newItemData;

-(void)refreshCurrentCell;

@end


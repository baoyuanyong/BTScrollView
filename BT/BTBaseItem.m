
//
//  BTBaseItem.m
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "BTBaseItem.h"


@implementation BTBaseItem

-(void)dealloc
{
    self.parentSection = nil;
    self.cellClass = nil;
    self.currentCell = nil;
    self.itemData = nil;
    self.preItem = nil;
    self.nextItem = nil;
    self.nextItem = nil;
    self.belowItem = nil;
    [super dealloc];
}

-(void)refreshItemWithData:(id)newItemData
{
    self.itemData = newItemData;
    [self refreshCurrentCell];
}

-(void)refreshCurrentCell
{
    if (self.delegateController)
    {
        self.currentCell.delegateController = self.delegateController;
    }
    
    if (self.itemData && self.currentCell && [self.currentCell respondsToSelector:@selector(loadItemData:)])
    {
        self.currentCell.frame = self.itemFrame;
        [self.currentCell loadItemData:self.itemData];
    }
}
-(void)clickCurrentCell
{
    if (self.baseItemDelegate && [self.baseItemDelegate respondsToSelector:@selector(clickCurrentItem:)])
    {
        [self.baseItemDelegate clickCurrentItem:self];
    }
}

-(void)clickCurrentCellBtn:(id)sender
{
    if (self.baseItemDelegate && [self.baseItemDelegate respondsToSelector:@selector(clickCurrentCellBtnItem: sender:)])
    {
        [self.baseItemDelegate clickCurrentCellBtnItem:self sender:sender];
    }
}
@end

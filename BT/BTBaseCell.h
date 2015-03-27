//
//  BTBaseCell.h
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BTBaseCell;

@protocol BTBaseCellDelegate <NSObject>
//点击cell
-(void)clickBaseCell;

//点击cell上的btn
-(void)clickBaseCellBtn:(id)sender;
@end


@interface BTBaseCell : UIView

@property (nonatomic, retain) UIControl *cellControl;

//contoller
@property (nonatomic, assign) id delegateController;

//BTBaseItem
@property (nonatomic, assign) id<BTBaseCellDelegate> baseCellDelegate;


//frame都是CGRectZero,这是由
-(void)initUIView:(CGRect)frame;


-(void)clickCellBtn:(id)sender;

//cell重新加载数据，通常要调整UI、显示数据
//基类做的是，调整cellControl
//如果调用BTBaseCell的loadItemData，会造成cellControl遮挡整个cell
-(void)loadItemData:(id)data;




@property (nonatomic, retain) UILabel *title,*name;

@end


//
//  BTBaseCell.m
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "BTBaseCell.h"
#import "BTScrollView.h"
#import "BTBaseData.h"

@implementation BTBaseCell

static NSInteger num = 0;

-(id)initWithFrame:(CGRect)rect
{
    self = [super initWithFrame:rect];
    if (self) {
        [self initUIView:rect];
    }
    return self;
}
-(void)dealloc
{
    NSLog(@"BTBaseCell dealloc  %d",num);
    num--;
    
    self.cellControl = nil;
    self.title = nil;
    self.name = nil;
    [super dealloc];
}
-(void)initUIView:(CGRect)frame
{
    num++;
    NSLog(@"BTBaseCell create  %d",num);

    self.title = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)] autorelease];
    self.title.font = [UIFont systemFontOfSize:15];
    self.title.textColor = [UIColor redColor];
    [self addSubview:self.title];
    
    
    self.name = [[[UILabel alloc] initWithFrame:CGRectMake(0, 30, 50, 20)] autorelease];
    [self addSubview:self.name];

    self.backgroundColor = [UIColor lightGrayColor];
}
-(void)clickCell
{
    if (self.baseCellDelegate && [self.baseCellDelegate respondsToSelector:@selector(clickBaseCell)]) {
        [self.baseCellDelegate clickBaseCell];
    }
}

-(void)clickCellBtn:(id)sender
{
    if (self.baseCellDelegate && [self.baseCellDelegate respondsToSelector:@selector(clickBaseCellBtn:)]) {
        [self.baseCellDelegate clickBaseCellBtn:sender];
    }
}

-(void)loadItemData:(NSNumber *)data
{
    if (!self.cellControl) {
        
        self.cellControl = [[[UIControl alloc] initWithFrame:self.frame] autorelease];
        [self addSubview:self.cellControl];
        [self.cellControl addTarget:self action:@selector(clickCell) forControlEvents:UIControlEventTouchUpInside];
    }
        
        self.title.text = data.description;
    
    CGRect rect = self.frame;
    rect.origin = CGPointZero;
    self.cellControl.frame = rect;
}

@end



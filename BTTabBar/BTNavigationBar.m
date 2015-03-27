//
//  BTNavigationBar.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-15.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTNavigationBar.h"
#import "BTUtilsDef.h"
#define kScreenBound     [[UIScreen mainScreen] bounds]
#define navigationTitleFont [UIFont systemFontOfSize:15]  //item 标题 字体font
#define navigationTitleColor [UIColor blackColor]

#define kNavigationBarFrame  CGRectMake(0,0,kScreenBound.size.width,44)
#define kGap 4

@interface BTNavigationBar ()
{
    UIView *_leftView;
    UIView *_rightView;
    UILabel *_titleLabel;
}

@end


@implementation BTNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:[BTUtilsDef navigationBarFrame]];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}
-(void)initView
{
    _leftView  = [[UIView alloc] initWithFrame:CGRectZero];
    _rightView = [[UIView alloc] initWithFrame:CGRectZero];
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _titleLabel.font = navigationTitleFont;
    _titleLabel.textColor = navigationTitleColor;
    _titleLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_leftView];
    [self addSubview:_rightView];
    [self addSubview:_titleLabel];
    
    self.backgroundColor = [UIColor lightGrayColor];
}

-(void)setTitle:(NSString *)title
{
    _titleLabel.hidden = NO;
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    _titleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
}
-(void)setTitleView:(UIView *)titleView
{
    _titleLabel.hidden = YES;
    [self addSubview:titleView];
    titleView.center = self.center;
}


-(void)setLeftBarButtonItem:(UIButton *)leftBarButtonItem
{
    if ([self shouldTerminateWithClearLeftView:YES button:leftBarButtonItem]) {
        return ;
    }
    
    CGRect rect = leftBarButtonItem.frame;
    rect.origin = CGPointZero;
    leftBarButtonItem.frame = rect;
    
    [_leftView addSubview:leftBarButtonItem];
    
    rect.origin.x = kGap;
    rect.origin.y = (kNavigationBarFrame.size.height - rect.size.height)/2;
    _leftView.frame = rect;
}
-(void)setRightBarButtonItem:(UIButton *)rightBarButtonItem
{
    if ([self shouldTerminateWithClearLeftView:NO button:rightBarButtonItem]) {
        return ;
    }
    
    CGRect rect = rightBarButtonItem.frame;
    rect.origin = CGPointZero;
    rightBarButtonItem.frame = rect;
    
    [_rightView addSubview:rightBarButtonItem];
    
    rect.origin.x =kNavigationBarFrame.size.width - rect.size.width - kGap;
    rect.origin.y = (kNavigationBarFrame.size.height - rect.size.height)/2;
    _rightView.frame = rect;
}

-(void)setLeftBarButtonItems:(NSArray *)leftBarButtonItems
{
    //认为所有button的高度是一致的


    if ([self shouldTerminateWithClearLeftView:YES button:leftBarButtonItems]) {
        return ;
    }

    
    CGRect rect = CGRectZero;
    CGPoint point = CGPointZero;
    for(UIButton *btn in leftBarButtonItems)
    {
        rect = btn.frame;
        rect.origin = point;
        btn.frame = rect;

        [_rightView addSubview:btn];
        
        point.x += rect.size.width + kGap;
    }
    
    rect.size.width += rect.origin.x;
    rect.origin.x = kGap;
    rect.origin.y = (kNavigationBarFrame.size.height - rect.size.height)/2;
    _leftView.frame = rect;
}



-(void)setRightBarButtonItems:(NSArray *)rightBarButtonItems
{
    //认为所有button的高度是一致的
    if ([self shouldTerminateWithClearLeftView:NO button:rightBarButtonItems]) {
        return ;
    }
    CGRect rect = CGRectZero;
    CGPoint point = CGPointZero;
    for(UIButton *btn in rightBarButtonItems)
    {
        rect = btn.frame;
        rect.origin = point;
        btn.frame = rect;
        
        [_rightView addSubview:btn];
        
        point.x += rect.size.width + kGap;
    }
    
    rect.size.width += rect.origin.x;
    rect.origin.x =kNavigationBarFrame.size.width - rect.size.width - kGap;
    rect.origin.y = (kNavigationBarFrame.size.height - rect.size.height)/2;
    _rightView.frame = rect;
}

-(BOOL)shouldTerminateWithClearLeftView:(BOOL)isLeftView button:(id)item
{
    if (isLeftView) {
        
        if (!item) {
            _leftView.hidden = YES;
            return YES;
        }else{
            _leftView.hidden = NO;
            for(UIView *av in _leftView.subviews)
            {
                [av removeFromSuperview];
            }
            return NO;
        }
    }else{
        if (!item) {
            _rightView.hidden = YES;
            return YES;
        }else{
            _rightView.hidden = NO;
            for(UIView *av in _rightView.subviews)
            {
                [av removeFromSuperview];
            }
            return NO;
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end

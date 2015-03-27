//
//  BTRefreshScrollView.m
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "BTRefreshScrollView.h"
#import "BTPullUpView.h"
#import "BTPullDownView.h"

@interface BTRefreshScrollView ()
{
    BTPullDownView *headerRefreshView;
    BTPullUpView *footerLoadMoreView;
}

@end

@implementation BTRefreshScrollView

@synthesize scrollViewDelegate = _scrollViewDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initRefreshView];
    }
    return self;
}
-(void)dealloc
{
    [self removeObserver:self forKeyPath:@"contentSize"];
    [self removeObserver:self forKeyPath:@"contentOffset"];

    [headerRefreshView release];
    [footerLoadMoreView release];
    [super dealloc];
}
-(void)initRefreshView
{
    if (!headerRefreshView) {
        headerRefreshView = [[BTPullDownView alloc] initWithFrame:CGRectZero];
        [self addSubview:headerRefreshView];
    }
    headerRefreshView.scrollView = self;
    headerRefreshView.hidden = YES;
    
    if (!footerLoadMoreView) {
        
        footerLoadMoreView = [[BTPullUpView alloc] initWithFrame:CGRectZero];
        [self addSubview:footerLoadMoreView];
    }
    footerLoadMoreView.scrollView = self;
    footerLoadMoreView.hidden = YES;


    [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)setScrollViewDelegate:(id<BTScrollViewDelegate>)theScrollViewDelegate
{
    _scrollViewDelegate = theScrollViewDelegate;
    
    #pragma mark -- 这两个都必须要避免循环引用
    __block id weakDelegate = _scrollViewDelegate;
    __block id weakSelf = self;
    headerRefreshView.refreshingBlock = ^(BTPullDownView *pullDownView){
        [weakDelegate pullDownTriggerHeaderRefresh:weakSelf];

    };
    
    footerLoadMoreView.loadingMoreBlock = ^(BTPullUpView *pullUpView){
        [weakDelegate pullUpLoadMore:weakSelf];
    };
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (_enableHeaderRefresh) {
        [headerRefreshView changeKeyPath:keyPath];
    }
    if (_enableLoadMore) {
        [footerLoadMoreView changeKeyPath:keyPath];
    }
}

-(void)setEnableHeaderRefresh:(BOOL)enableHeaderRefresh
{
    if (enableHeaderRefresh) {
        headerRefreshView.hidden = NO;
    }else{
        headerRefreshView.hidden = YES;
    }
    _enableHeaderRefresh = enableHeaderRefresh;
}

-(void)setEnableLoadMore:(BOOL)enableLoadMore
{
    if (enableLoadMore) {
        footerLoadMoreView.hidden = NO;
    }else{
        footerLoadMoreView.hidden = YES;
    }
    _enableLoadMore = enableLoadMore;
}


-(void)BTRefreshScrollViewDataSourceDidFinishedLoading
{
    [headerRefreshView endRefreshing];
    [footerLoadMoreView endLoading];
}

@end

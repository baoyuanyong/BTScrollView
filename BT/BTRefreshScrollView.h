//
//  BTRefreshScrollView.h
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "BTScrollView.h"

@interface BTRefreshScrollView : BTScrollView<UIScrollViewDelegate>

@property (nonatomic, assign) BOOL enableHeaderRefresh;
@property (nonatomic, assign) BOOL enableLoadMore;

-(void)BTRefreshScrollViewDataSourceDidFinishedLoading;
@end

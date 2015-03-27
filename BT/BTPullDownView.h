//
//  BTPullDownView.h
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    DOWNNormal = 1,
    DOWNPulling = 2,
    DOWNRefreshing = 3
} PullDownState;

@class BTPullDownView;

typedef void (^RefreshingBlock) (BTPullDownView *pullDownView);

@interface BTPullDownView : UIView
{
    UILabel *_lastRefreshLabel;
    PullDownState _state;
    UIEdgeInsets _defaultInset;
}
@property (nonatomic, retain) UIImageView *arrowImage;
@property (nonatomic, retain) NSDate *lastRefreshDate;

@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, copy)   RefreshingBlock refreshingBlock;


-(void)changeKeyPath:(NSString *)keyPath;

- (void)endRefreshing;
@end

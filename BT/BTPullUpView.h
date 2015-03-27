//
//  BTPullUpView.h
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    UPNormal = 1,
    UPPulling = 2,
    UPLoading = 3
} PullUpState;

@class BTPullUpView;

typedef void (^LoadingMoreBlock) (BTPullUpView *pullUpView);

@interface BTPullUpView : UIView
{
    UILabel *_statusLabel;
    UIActivityIndicatorView *_indicatorView;
    UIImageView *_arrowImage;
    PullUpState _state;
    UIEdgeInsets _defaultInset;
}

@property (nonatomic, assign) UIScrollView *scrollView;
@property (nonatomic, copy)   LoadingMoreBlock loadingMoreBlock;


-(void)changeKeyPath:(NSString *)keyPath;

- (void)endLoading;

@end

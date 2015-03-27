//
//  BTPullUpView.m
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "BTPullUpView.h"

#define kViewHeight         40
#define kStatusHeight       20
#define kPullingToLoading   @"上拉即可加载更多"
#define kReleaseToLoading   @"松开立即加载更多"
#define kLoading            @"正在加载..."

@implementation BTPullUpView

#pragma mark - Init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self shareInit];
    }
    return self;
}

- (void)shareInit
{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.backgroundColor = [UIColor clearColor];
    [self initSubViews];
    [self endLoading];
}

- (void)dealloc
{
    [_statusLabel release];
    [_arrowImage release];
    [_indicatorView release];
    self.loadingMoreBlock = nil;
    self.scrollView = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark - View
- (void)initSubViews
{
    _statusLabel = [[self labelWithFontSize:14] retain];
    [self addSubview:_statusLabel];

    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrow"]];
    _arrowImage.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:_arrowImage];

    _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    _indicatorView.bounds = _arrowImage.bounds;
    _indicatorView.autoresizingMask = _arrowImage.autoresizingMask;
    [self addSubview:_indicatorView];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height = kViewHeight;
    [super setFrame:frame];
    if (frame.size.width == 0) {
        return;
    }
    _statusLabel.frame = CGRectMake(0, (kViewHeight - kStatusHeight) / 2, self.frame.size.width, kStatusHeight);
    CGFloat arrowX = self.frame.size.width * 0.5 - 80;
    _arrowImage.center = CGPointMake(arrowX, frame.size.height * 0.5);
    _indicatorView.center = _arrowImage.center;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView != scrollView) {

        _scrollView = scrollView;

        _defaultInset = scrollView.contentInset;
        [self adapterFrame];
    }
}



- (UILabel *)labelWithFontSize:(CGFloat)size
{
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    label.font = [UIFont systemFontOfSize:size];
    label.textColor = [UIColor colorWithRed:150/255.0 green:150/255.0 blue:150/255.0 alpha:1.0];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)adapterFrame
{
    CGFloat y = MAX(_scrollView.contentSize.height, _scrollView.frame.size.height);
    self.frame = CGRectMake(0, y, _scrollView.frame.size.width, kViewHeight);
}

#pragma mark -
#pragma mark - Control
-(void)changeKeyPath:(NSString *)keyPath
{
    if ([@"contentSize" isEqualToString:keyPath]) {
        [self adapterFrame];
    }
    
    if ([@"contentOffset" isEqualToString:keyPath]) {
        //如果不够上拉加载更多的高度
        if (_scrollView.contentSize.height < _scrollView.frame.size.height) {
            return;
        }
        
        if (_scrollView.isDragging) {
            
            CGFloat validOffsetY = [self validOffsetY];
            CGFloat offsetY = _scrollView.contentOffset.y;
            if (_state == UPPulling && offsetY <= validOffsetY) {
                [self setState:UPNormal];
            }
            if (_state == UPNormal && offsetY > validOffsetY) {
                [self setState:UPPulling];
            }
        }
        else
        {
            if (_state == UPPulling) {
                [self setState:UPLoading];
            }
        }
    }
}

- (void)setState:(PullUpState)state
{
    if (_state == state) {
        return;
    }
    _state = state;
    switch (state) {
        case UPNormal:
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImage.transform = CGAffineTransformMakeRotation((CGFloat) M_PI);
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.bottom = _defaultInset.bottom;
                _scrollView.contentInset = inset;
            } completion:^(BOOL finished) {
                _statusLabel.text = kPullingToLoading;
                _arrowImage.hidden = NO;
                [_indicatorView stopAnimating];
            }];
            break;
        case UPPulling:
            _statusLabel.text = kReleaseToLoading;
            [UIView animateWithDuration:0.2 animations:^{
                _arrowImage.transform = CGAffineTransformIdentity;
                UIEdgeInsets inset = _scrollView.contentInset;
                inset.bottom = _defaultInset.bottom;
                _scrollView.contentInset = inset;
            }];
            break;
        case UPLoading:
            _statusLabel.text = kLoading;
            _arrowImage.hidden = YES;
            _arrowImage.transform = CGAffineTransformIdentity;
            [_indicatorView startAnimating];
            
            UIEdgeInsets inset = _scrollView.contentInset;
            inset.bottom = self.frame.origin.y - _scrollView.contentSize.height + kViewHeight + _defaultInset.bottom;
            
            [UIView animateWithDuration:0.2 animations:^{
                _scrollView.contentInset = inset;
                _scrollView.contentOffset = CGPointMake(0, [self validOffsetY]);
            }];

            if (_loadingMoreBlock) {
                _loadingMoreBlock(self);
            }
            break;
    }
}

- (CGFloat)validOffsetY
{
    CGFloat validY = MAX(_scrollView.contentSize.height, _scrollView.frame.size.height) - _scrollView.frame.size.height;
    return validY + kViewHeight;
}

- (void)endLoading
{
    [self setState:UPNormal];
}

@end

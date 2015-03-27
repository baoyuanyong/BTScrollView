//
//  BTPullDownView.m
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "BTPullDownView.h"

#define kViewHeight         80
#define kArrowHeight        62
#define kImageRect          CGRectMake(146, 15, 28, 62)

@implementation BTPullDownView

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
    [self endRefreshing];
    
    self.lastRefreshDate = [NSDate date];
}

- (void)dealloc
{
    [_lastRefreshLabel release];
    self.arrowImage = nil;
    self.lastRefreshDate = nil;
    self.refreshingBlock = nil;
    self.scrollView = nil;
    [super dealloc];
}

#pragma mark

#pragma mark -
#pragma mark - View
- (void)initSubViews
{
    _lastRefreshLabel = [[self labelWithFontSize:10] retain];
    _lastRefreshLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_lastRefreshLabel];
    
    _arrowImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sx0001.png"]];
    [self addSubview:_arrowImage];
}

- (void)setFrame:(CGRect)frame
{
    frame.size.height = kViewHeight;
    [super setFrame:frame];
    if (frame.size.width == 0) {
        return;
    }

    _lastRefreshLabel.frame = CGRectMake(0,50 , frame.size.width, 20);
    [self updateRefreshTime];

    _arrowImage.frame = kImageRect;
}

- (void)setScrollView:(UIScrollView *)scrollView
{
    if (_scrollView != scrollView) {

        _scrollView = scrollView;
        _defaultInset = _scrollView.contentInset;
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
    self.frame = CGRectMake(0, -kViewHeight -_defaultInset.top, _scrollView.frame.size.width, kViewHeight);
}

#pragma mark -
#pragma mark - Control

-(void)changeKeyPath:(NSString *)keyPath
{
    if ([@"contentOffset" isEqualToString:keyPath]) {
        CGFloat offsetY = - _scrollView.contentOffset.y;
        if (_scrollView.isDragging) {
            if (_state == DOWNPulling && offsetY <= kViewHeight) {
                [self setState:DOWNNormal];
            }
            if (_state == DOWNNormal && offsetY > kViewHeight) {
                [self setState:DOWNPulling];
            }
            
            if(offsetY<= kViewHeight && offsetY >=0)
            {
                [self setImageWithOffset:offsetY];
            }
            
        } else {
            if (_state == DOWNPulling) {
                [self setState:DOWNRefreshing];
            }
        }
    }
}

- (void)setState:(PullDownState)state
{
    if (_state == state) {
        return;
    }
    PullDownState oldState = _state;
    _state = state;
    switch (state) {
        case DOWNNormal:
            
            [self stopAnimation];
            [UIView animateWithDuration:0.2 animations:^{

                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _defaultInset.top;
                _scrollView.contentInset = inset;
            } completion:^(BOOL finished) {

                if (oldState == DOWNRefreshing)
                {
                    self.lastRefreshDate = [NSDate date];
                }
            }];
            break;
        case DOWNPulling:

            [self updateRefreshTime];
            [UIView animateWithDuration:0.2 animations:^{

                UIEdgeInsets inset = _scrollView.contentInset;
                inset.top = _defaultInset.top;
                _scrollView.contentInset = inset;
            }];
            break;
        case DOWNRefreshing:
        {
            [self startAnimation];

            UIEdgeInsets inset = _scrollView.contentInset;
            inset.top = _defaultInset.top +  kViewHeight;
            
            [UIView animateWithDuration:0.2 animations:^{
                
                _scrollView.contentInset = inset;
                _scrollView.contentOffset = CGPointMake(0, -kViewHeight);
            }];
            

            if (_refreshingBlock) {
                _refreshingBlock(self);
            }
        }
            break;
    }
}

- (void)updateRefreshTime
{
    if (_lastRefreshDate) {
        
        NSDate *date = _lastRefreshDate;
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setAMSymbol:@""];
        [formatter setPMSymbol:@""];
        [formatter setDateFormat:@"MM-dd hh:mm a"];
        _lastRefreshLabel.text = [NSString stringWithFormat:@"    最后更新:          %@", [formatter stringFromDate:date]];
        [formatter release];
    }
  
}


- (void)endRefreshing
{
    [self setState:DOWNNormal];
}

#pragma mark -- 修改图片相关

- (void)setImageWithOffset:(float)dy
{
    NSString* strName = [self getImageStateName:dy];
    [CATransaction begin];
    [CATransaction setValue:(id)kCFBooleanTrue forKey:kCATransactionDisableActions];
    if (strName && [strName length]>0) {
        _arrowImage.image = [UIImage imageNamed:strName];
    }
    [CATransaction commit];
}

-(NSArray*)buildNamesArray:(NSString*)pre begin:(int)nBeg count:(int)nCount
{
    NSMutableArray* names = [[NSMutableArray alloc] initWithCapacity:(nCount + 1)];
    NSString*   strName;
    for (int i =nBeg; i < nBeg+nCount; i++)
    {
        strName = [NSString stringWithFormat:@"%@%.4d.png", pre,i];
        [names addObject:strName];
    }
    return [names autorelease];
}

- (NSString*)getImageStateName:(float)dy
{
    NSArray* imgs = [self buildNamesArray:@"sx" begin:1 count:12];
    float arr[3]= {0.56,0.56,1.0};
    float step = (arr[2]-arr[0])/[imgs count];
    float begin= arr[0];
    float ndy  = abs(dy);
    
    NSString * strName=nil;
    if (ndy < kArrowHeight)
    {
        for (int i= 0; i< [imgs count]; i++) {
            if (ndy <= (kArrowHeight*begin) ) {
                strName =  [imgs objectAtIndex:i];
                break;
            }
            begin+=step;
        }
    }else{
        strName= [imgs objectAtIndex:[imgs count]-1];
    }
    return strName;
}


-(NSArray*)buildImageArray:(NSString*)pre begin:(int)nBeg count:(int)nCount
{
    NSMutableArray* images = [[NSMutableArray alloc] initWithCapacity:(nCount + 1)];
    UIImage*    img;
    NSString*   strName;
    for (int i =nBeg; i < nBeg+nCount; i++)
    {
        strName = [NSString stringWithFormat:@"%@%.4d.png", pre,i];
        img = [UIImage imageNamed:strName];
        if (img != nil) {
            [images addObject:img];
        }
    }
    return [images autorelease];
}

- (void)startAnimation
{
    NSArray* imgs = [self buildImageArray:@"sx" begin:15 count:8];
    CGRect rect               = kImageRect;
    UIImageView* aniView      = [[UIImageView alloc] initWithFrame:rect];
    aniView.image             = imgs[0];
    aniView.animationImages   = imgs;
    aniView.animationDuration = ((CGFloat)[imgs count])/24;
    aniView.animationRepeatCount=0;

    [_arrowImage removeFromSuperview];

    self.arrowImage = aniView;
    [self addSubview:self.arrowImage];
    [_arrowImage startAnimating];
    [aniView release];
}

- (void)stopAnimation
{
    [_arrowImage stopAnimating];
}

@end

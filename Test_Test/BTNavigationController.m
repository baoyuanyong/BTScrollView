//
//  BTNavigationController.m
//  CustomNavBarTest
//
//  Created by 鲍远勇 on 14-9-9.
//  Copyright (c) 2014年 YingYing. All rights reserved.
//

#import "BTNavigationController.h"
#import "BTBaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <math.h>



// 背景视图起始frame.x
#define startX  (-100)

@interface BTNavigationController ()<UIGestureRecognizerDelegate>
{
    CGPoint startTouch;
    
    UIView *_previousView;
    UIView *_currentView;
    UIView *_grayView;
    
    BTBaseViewController *_rootViewController;
}
@property (nonatomic, assign) BOOL isMoving;
@property (nonatomic, assign) UIViewController *currentViewController;

@end

@implementation BTNavigationController

//+ (void)asyncThreadEntryPoint:(id)__unused object {
//    
//    @autoreleasepool {
//        
//        [[NSThread currentThread] setName:@"asyncThread"];
//        NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
//        [runLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
//        [runLoop run];
//    }
//}
//
//+ (NSThread *)asyncThread {
//    
//    static NSThread *_asyncThread = nil;
//    static dispatch_once_t oncePredicate;
//    dispatch_once(&oncePredicate, ^{
//        _asyncThread = [[NSThread alloc] initWithTarget:self selector:@selector(asyncThreadEntryPoint:) object:nil];
//        [_asyncThread start];
//    });
//    
//    return _asyncThread;
//}
//读写图片到磁盘，有没有必要在异步线程上操作呢



-(id)initWithRootViewController:(BTBaseViewController *)rootViewController
{
    self = [super init];
    if (self) {
        
        _rootViewController = [rootViewController retain];
        _rootViewController.btNavigationController = self;
        _viewControllers = [[NSMutableArray alloc] initWithCapacity:10];
        _currentViewController = nil;
        self.canDragBack = YES;
    }
    return self;
}


- (void)dealloc
{
    

    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(paningGestureReceive:)];
    [recognizer setDelegate:self];
    [recognizer delaysTouchesBegan];
    [self.view addGestureRecognizer:recognizer];
    
    
    _rootViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:_rootViewController.view];
    _rootViewController.view.tag = kRootViewTag;
    [self.viewControllers addObject:_rootViewController];
}


//-(void)viewWillAppear:(BOOL)animated
//{
//    
//}
//
////只会调用一次，就是第一次显示该view的时候。之后，切换界面，并不会调用这个方法了
//-(void)viewDidAppear:(BOOL)animated
//{
//    
//}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)moveViewWithX:(float)x
{
    CGSize size = self.view.frame.size;
    x = x>size.width?size.width:x;
    x = x<0?0:x;
    
    _grayView.alpha = 0.4 - x/(2.5*size.width);
    
    _currentView.frame = CGRectMake(x, 0, size.width, size.height);
    
    _previousView.frame=CGRectMake(startX + x*abs(startX)/size.width,0,size.width,size.height);
}




#pragma mark - Gesture Recognizer -
//不响应的手势则传递下去
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (self.viewControllers.count <= 1 || !self.canDragBack){
        return NO;
    }
    return YES;
}


- (void)paningGestureReceive:(UIPanGestureRecognizer *)recoginzer
{
    if (self.viewControllers.count <= 1 || !self.canDragBack)
    {
        return;
    }
    
    CGPoint touchPoint = [recoginzer locationInView:KEY_WINDOW];
    
    if (recoginzer.state == UIGestureRecognizerStateBegan) {
        
        _isMoving = YES;
        startTouch = touchPoint;

        BTBaseViewController *currentCtl = [self.viewControllers objectAtIndex:self.viewControllers.count-1];
        _currentView = currentCtl.view;
        
        BTBaseViewController *preCtl = [self.viewControllers objectAtIndex:self.viewControllers.count-2];
        _previousView = preCtl.view;
        
        _grayView = [[UIView alloc] initWithFrame:preCtl.view.frame];
        _grayView.backgroundColor = [UIColor blackColor];
        [_previousView addSubview:_grayView];
        
        CGRect rect = _previousView.frame;
        rect.origin.x = startX;
        _previousView.frame = rect;
    }
    else if (recoginzer.state == UIGestureRecognizerStateEnded){
        
        CGFloat distance = touchPoint.x - startTouch.x;
        if (distance > 50)
        {
            CGFloat time = (self.view.frame.size.width - _currentView.frame.origin.x)/900;
            NSLog(@"time:%f",time);
 
            
            [UIView animateWithDuration:time delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                [self moveViewWithX:self.view.frame.size.width];

            } completion:^(BOOL finished) {
                _isMoving = NO;
                [_grayView removeFromSuperview];
                [self popViewControllerAnimated:NO];
                _previousView = nil;
                _grayView = nil;
                _currentView = nil;
            }];
            
        }
        else{
            
            [UIView animateWithDuration:0.3 animations:^{
                [self moveViewWithX:0];
            } completion:^(BOOL finished) {
                
                _isMoving = NO;
                [_grayView removeFromSuperview];
                _previousView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
                _previousView = nil;
                _grayView = nil;
                _currentView = nil;
            }];
            
        }
        return;
    }
    else if (recoginzer.state == UIGestureRecognizerStateCancelled){
        
        [UIView animateWithDuration:0.3 animations:^{
            
            [self moveViewWithX:0];
            
        } completion:^(BOOL finished) {
            
            _isMoving = NO;
            [_grayView removeFromSuperview];
            _previousView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
            _previousView = nil;
            _grayView = nil;
            _currentView = nil;
        }];
        return;
    }
    
    if (_isMoving) {
        [self moveViewWithX:touchPoint.x - startTouch.x];
    }
}


- (void)pushViewController:(BTBaseViewController *)viewController animated:(BOOL)animated
{
    CGSize size = self.view.frame.size;
    viewController.view.frame = CGRectMake(size.width, 0, size.width, size.height);
    [self.view addSubview:viewController.view];
    [self.viewControllers addObject:viewController];
    viewController.btNavigationController = self;
    
    [_currentViewController viewWillDisappear:animated];
    
    if (animated) {
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            viewController.view.frame = CGRectMake(0, 0, size.width, size.height);
            
        } completion:^(BOOL finished) {
            
            [_currentViewController viewDidDisappear:animated];
            _currentViewController = viewController;
        }];
    }else{
        viewController.view.frame = CGRectMake(0, 0, size.width, size.height);
        
        [_currentViewController viewDidDisappear:animated];
        _currentViewController = viewController;
    }
}

- (void)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *viewController = [self.viewControllers lastObject];
    CGSize size = self.view.frame.size;
    
    UIViewController *preCtl = nil;
    if (self.viewControllers.count >= 2) {
        preCtl = [self.viewControllers objectAtIndex:self.viewControllers.count -2];
    }
    
    [preCtl viewWillAppear:animated];
    [viewController viewWillDisappear:animated];
    
    if (animated) {
        
        [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
            
            viewController.view.frame = CGRectMake(size.width, 0, size.width, size.height);
            
        } completion:^(BOOL finished) {
            
            [preCtl viewDidAppear:animated];
            _currentViewController = preCtl;
            
            [viewController.view removeFromSuperview];
            [viewController viewDidDisappear:animated];
            [self.viewControllers removeLastObject];
        }];
        
    }else{
        
        [preCtl viewDidAppear:animated];
        _currentViewController = preCtl;
        
        [viewController.view removeFromSuperview];
        [viewController viewDidDisappear:animated];
        [self.viewControllers removeLastObject];
    }
    
    
    
}


@end


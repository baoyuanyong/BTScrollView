//
//  BTTabBarItem.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-14.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTTabBarItem.h"



#define titleColor [UIColor blackColor]    //item里标题默认颜色
#define selectedTitleColor [UIColor redColor]  // item被选中时标题的颜色
#define titleFont [UIFont systemFontOfSize:10]  //item 标题 字体font
#define badgeValueFont [UIFont systemFontOfSize:10]  //小红圈里字体的大小
#define badgeValueColor [UIColor whiteColor] //小红圈里字体的颜色
#define kImageHightScale  0.7
#define kBottomSpace    2

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@interface BTTabBarItem ()
{
    UIImageView *_badgeImgView;
}

@end


@implementation BTTabBarItem

+(id)tabBarItemTitle:(NSString *)title image:(UIImage *)normalImage selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag
{
    BTTabBarItem *item = [BTTabBarItem buttonWithType:UIButtonTypeCustom];
    item.frame = kTabBarItemRect;
    [item setTitleColor:titleColor forState:UIControlStateNormal];
    [item setTitleColor:selectedTitleColor forState:UIControlStateSelected];
    item.titleLabel.font = titleFont;
    [item setTitle:title forState:UIControlStateNormal];
    
    [item setImage:normalImage forState:UIControlStateNormal];
    [item setImage:selectedImage forState:UIControlStateSelected];
    
    item.tag = tag;
    
    return item;
}

-(void)setBadgeValue:(NSString *)badgeValue
{
    if (!badgeValue) {
        return ;
    }
    
    
    if (!_badgeImgView) {
        _badgeImgView = [[[UIImageView alloc] initWithFrame:CGRectZero] autorelease];
        _badgeImgView.tag = 100;
        [self addSubview:_badgeImgView];
    }
    
    if (badgeValue.length == 0 || [badgeValue isEqualToString:@"0"]) {
        _badgeImgView.hidden = YES;
    }else{
        _badgeImgView.hidden = NO;
    }
    
    NSString *numStr = badgeValue;
    UIFont *numFont = [UIFont systemFontOfSize:9];
    CGFloat appendWidth = 3*(numStr.length-1);
    CGSize size = CGSizeMake(14+appendWidth, 14);
    
    UIImage *image = [self imageRoundWithLetter:numStr imageSize:size font:numFont bgColor:UIColorFromRGB(0xf5560f) letterColor:[UIColor whiteColor]];
    
    _badgeImgView.frame = CGRectMake(30, 4, size.width, size.height);
    _badgeImgView.image = image;

}

-(UIImage *)imageRoundWithLetter:(NSString *)letter imageSize:(CGSize)size font:(UIFont *)font bgColor:(UIColor *)bgColor  letterColor:(UIColor *)letterColor;
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGFloat half = size.height/2;
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    
    CGContextMoveToPoint(context, half, 0);
    CGContextAddLineToPoint(context, width - half , 0);
    CGContextAddArc(context, width - half, half, half, - M_PI_2, M_PI_2, 0);
    
    CGContextAddLineToPoint(context, half, height);
    CGContextAddArc(context, half, half, half, M_PI_2, 1.5 * M_PI, 0);
    
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextDrawPath(context, kCGPathFill);
    
    
    CGSize letterSize = [letter sizeWithFont:font];
    CGContextSetFillColorWithColor(context, letterColor.CGColor);
    [letter drawAtPoint:CGPointMake((size.width -letterSize.width)/2+0.25, (size.height - letterSize.height)/2-0.25) withFont:font];
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}



- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        // 让图片按照原来的宽高比显示出来
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 设置按钮文字的字体
        self.titleLabel.font = titleFont;
        self.adjustsImageWhenHighlighted = NO;
        
    }
    return self;
}


#pragma mark 控制UILabel的位置和尺寸
// contentRect其实就是按钮的位置和尺寸
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleHeight = titleFont.lineHeight;
    CGFloat titleY = contentRect.size.height - titleHeight - kBottomSpace;
    CGFloat titleWidth = contentRect.size.width;
    return CGRectMake(0, titleY, titleWidth, titleHeight);
}

#pragma mark 控制UIImageView的位置和尺寸
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageWidth = contentRect.size.width;
    CGFloat imageHeight = contentRect.size.height * kImageHightScale;
    return CGRectMake(0, 0, imageWidth, imageHeight);
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

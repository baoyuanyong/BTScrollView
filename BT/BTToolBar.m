//
//  BTToolBar.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-8.
//
//

#import "BTToolBar.h"

//按钮空隙
#define kButtonGap 5
#define kButtonMarginLeft 10
#define kBackImageMarginLeft 7
//按钮宽度
#define kButtonHeight 30

#define BUTTONID (sender.tag-100)

@interface BTToolBar ()
{
    NSMutableArray *_buttonsArray;
    NSInteger _currentIndex;        //点击按钮选择名字ID
    
    
    UIImageView *_shadowImageView;
}

@property (nonatomic, retain) NSArray *titlesArray;

@end


 UIColor * colorFromHexRGB(NSString *inColorString)
{
    UIColor *result = nil;
    unsigned int colorCode = 0;
    unsigned char redByte, greenByte, blueByte;
    
    if (nil != inColorString)
    {
        NSScanner *scanner = [NSScanner scannerWithString:inColorString];
        (void) [scanner scanHexInt:&colorCode]; // ignore error
    }
    redByte = (unsigned char) (colorCode >> 16);
    greenByte = (unsigned char) (colorCode >> 8);
    blueByte = (unsigned char) (colorCode); // masks off high bits
    result = [UIColor
              colorWithRed: (float)redByte / 0xff
              green: (float)greenByte/ 0xff
              blue: (float)blueByte / 0xff
              alpha:1.0];
    return result;
}


@implementation BTToolBar

@synthesize titlesArray;



- (id)initWithFrame:(CGRect)frame withTitlesArray:(NSArray *)theTitlesArray;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.showsHorizontalScrollIndicator = NO;
        self.titlesArray = theTitlesArray; //[NSArray arrayWithObjects:@"诸葛亮", @"關羽", @"曹孟德", @"趙雲", @"馬超", @"黃忠", @"孫禮",@"孙尚香", nil];
        
        [self initWithNameButtons];
        
        [self clickItemAtIndex:0];
    }
    
    return self;
}

- (void)initWithNameButtons
{
    _shadowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 59, 44)];
    [_shadowImageView setImage:[UIImage imageNamed:@"red_line_and_shadow.png"]];
    [self addSubview:_shadowImageView];
    
    
    _buttonsArray = [[NSMutableArray alloc] initWithCapacity:titlesArray.count];
    
    CGRect rect = CGRectMake(-kButtonGap, 9, 0, 30);
    CGSize size;
    NSString *title;
    UIFont *font = [UIFont systemFontOfSize:20];
    for (int i = 0; i < [self.titlesArray count]; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_buttonsArray addObject:button];
        title = [self.titlesArray objectAtIndex:i];
        
        size = [title sizeWithFont:font];
        rect.origin.x += rect.size.width + kButtonGap;
        rect.size.width = size.width + kButtonMarginLeft*2;
        
        [button setFrame:rect];
        [button setTag:i+100];
        
        [button setTitle:title forState:UIControlStateNormal];
        button.titleLabel.font = font;
        [button setTitleColor:colorFromHexRGB(@"868686") forState:UIControlStateNormal];
        [button setTitleColor:colorFromHexRGB(@"bb0b15") forState:UIControlStateSelected];
        [button addTarget:self action:@selector(selectNameButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
    }
    _currentIndex = 100;
    
    self.contentSize = CGSizeMake(rect.origin.x + rect.size.width, self.frame.size.height);
    
    
    
    
    if (self.contentSize.width < self.frame.size.width) {
    //如果item比较少，重新调整item.frame
        NSInteger itemCount = self.titlesArray.count;
        CGFloat space = (self.frame.size.width - self.contentSize.width)/(2*itemCount);
        CGRect rect ;
        UIButton *btn;
        for(int i=0;i<itemCount;i++)
        {
            btn = [_buttonsArray objectAtIndex:i];
            rect = btn.frame;
            rect.origin.x += space*(2*i+1);
            btn.frame = rect;
        }
        self.contentSize = self.frame.size;
    }
    
    
}

-(void)clickItemAtIndex:(NSInteger)index
{
    UIButton *btn = [_buttonsArray objectAtIndex:index];
    [self selectNameButton:btn];
}

- (void)selectNameButton:(UIButton *)sender
{
    
    [self adjustScrollViewContentX:sender];
    //如果更换按钮
    if (sender.tag != _currentIndex) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:_currentIndex];
        lastButton.selected = NO;
        _currentIndex = sender.tag;
    }
    
    //按钮选中状态
    if (!sender.selected) {
        sender.selected = YES;
        
        [UIView animateWithDuration:0.25 animations:^{
            //背景色
            [_shadowImageView setFrame:CGRectMake(sender.frame.origin.x+kBackImageMarginLeft, 0, sender.frame.size.width-kBackImageMarginLeft*2, 44)];
            
        } completion:^(BOOL finished) {
            
            //让代理执行回调方法
            
            if (finished) {
               
                if ([self.toolBarDelegate respondsToSelector:@selector(clickToolBarItem:)]) {
                    [self.toolBarDelegate clickToolBarItem:sender];
                }
            }
        }];
    }
}


- (void)selectTitleAtIndex:(NSInteger)index;
{
    if (index<0 || index>_buttonsArray.count) {
        return ;
    }
    
    if(index+100 == _currentIndex) {
        //重复点击
        return ;
    }
    
    //滑动选中按钮
    UIButton *button = (UIButton *)[self viewWithTag:100+index];
    button.selected = YES;

    
    [self adjustScrollViewContentX:button];
    //如果更换按钮
    if (button.tag != _currentIndex) {
        //取之前的按钮
        UIButton *lastButton = (UIButton *)[self viewWithTag:_currentIndex];
        lastButton.selected = NO;
        _currentIndex = button.tag;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        [_shadowImageView setFrame:CGRectMake(button.frame.origin.x + kBackImageMarginLeft, 0, button.frame.size.width - kBackImageMarginLeft*2, 44)];
    }];
}



- (void)adjustScrollViewContentX:(UIButton *)sender
{
    CGFloat offLeft = self.frame.size.width/2;
    CGFloat offRight = self.contentSize.width - offLeft;
    CGPoint senderCenter = sender.center;
    
    if (senderCenter.x < offLeft) {
        
        [self setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }else if (senderCenter.x > offRight)
    {
        [self setContentOffset:CGPointMake(offRight-offLeft, 0) animated:YES];
    }
    else{//将sender的中点滚动到scrollview显示的中点
        
        [self setContentOffset:CGPointMake(senderCenter.x-offLeft, 0) animated:YES];
    }
}


@end
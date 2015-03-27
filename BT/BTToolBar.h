//
//  BTToolBar.h
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-8.
//
//

#import <UIKit/UIKit.h>


@protocol BTToolBarDelegate <NSObject>

-(void)clickToolBarItem:(UIButton *)sender;

@end


@interface BTToolBar : UIScrollView

- (id)initWithFrame:(CGRect)frame withTitlesArray:(NSArray *)titlesArray;

@property (nonatomic, assign) id <BTToolBarDelegate> toolBarDelegate;

//滑动选择按钮
- (void)selectTitleAtIndex:(NSInteger)index;

@end

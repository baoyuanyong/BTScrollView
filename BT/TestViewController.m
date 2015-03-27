//
//  TestViewController.m
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "TestViewController.h"
#import "BTBaseItem.h"
#import "BTBaseData.h"
#import "BTBaseCell.h"
#import "BTToolBar.h"
#import "BTSection.h"
#import "BTScrollView.h"
#import "BTRefreshScrollView.h"

@interface TestViewController ()<BTScrollViewDelegate>
{
}

@property (nonatomic, retain) BTRefreshScrollView *refreshScrollView;


@end

@implementation TestViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.refreshScrollView = nil;
    [super dealloc];
}


-(void)viewDidLoad
{
    [super viewDidLoad];    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    BTSection *section = [[[BTSection alloc] init] autorelease];
    section.baseItems = [self createArray:17];
    section.marignTop = 10;
    section.mariginBottom = 10;
    section.numCols = 1;
    section.marginLeft = 10;
    section.marginRight = 10;
    section.cellXGap = 5;
    section.cellYGap = 5;
    
    
    BTSection *section1 = [[[BTSection alloc] init] autorelease];
    section1.baseItems = [self createArray:6];
    section1.marignTop = 10;
    section1.numCols = 2;
    section1.marginLeft = 10;
    section1.cellXGap = 5;
    section1.cellYGap = 5;
    
    
    BTSection *section2 = [[[BTSection alloc] init] autorelease];
    section2.baseItems = [self createArray:5];
    section2.marignTop = 10;
    section2.numCols = 1;
    section2.marginLeft = 15;
    section2.marginRight = 15;
    section2.cellXGap = 5;
    section2.cellYGap = 5;
    
    BTSection *section3 = [[[BTSection alloc] init] autorelease];
    section3.baseItems = [self createArray:38];
    section3.marignTop = 10;
    section3.numCols = 4;
    section3.cellXGap = 5;
    section3.cellYGap = 5;
    section3.marginLeft = 10;
    
    
    self.refreshScrollView = [[[BTRefreshScrollView alloc] initWithFrame:CGRectMake(0, 100, 320, 468)] autorelease];
    _refreshScrollView.enableHeaderRefresh = YES;
    _refreshScrollView.enableLoadMore = YES;
    _refreshScrollView.scrollViewDelegate = self;


    [self.view addSubview:_refreshScrollView];
    _refreshScrollView.sectionArray = @[section,section1,section2,section3];
    [_refreshScrollView showItemsInScreenOffsetY:100];
    
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(40, 20, 50, 40);
    [btn setTitle:@"添加" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(itemAdd) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIButton *delete = [UIButton buttonWithType:UIButtonTypeCustom];
    delete.frame = CGRectMake(90, 20, 50, 40);
    [delete setTitle:@"删除" forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(itemDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:delete];
    
    
    UIButton *insert = [UIButton buttonWithType:UIButtonTypeCustom];
    insert.frame = CGRectMake(140, 20, 50, 40);
    [insert setTitle:@"插入" forState:UIControlStateNormal];
    [insert addTarget:self action:@selector(itemInsert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:insert];
    
    UIButton *replace = [UIButton buttonWithType:UIButtonTypeCustom];
    replace.frame = CGRectMake(190, 20, 50, 40);
    [replace setTitle:@"替换" forState:UIControlStateNormal];
    [replace addTarget:self action:@selector(itemReplace) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:replace];
    
    
    
    UIButton *sectionAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionAdd setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sectionAdd.frame = CGRectMake(5, 60,100, 40);
    [sectionAdd setTitle:@"追加section" forState:UIControlStateNormal];
    [sectionAdd addTarget:self action:@selector(sectonAppend) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sectionAdd];
    
    UIButton *sectionDelete = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionDelete setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sectionDelete.frame = CGRectMake(110, 60, 100, 40);
    [sectionDelete setTitle:@"删除section" forState:UIControlStateNormal];
    [sectionDelete addTarget:self action:@selector(sectionDelete) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sectionDelete];
    
    
    UIButton *sectionInsert = [UIButton buttonWithType:UIButtonTypeCustom];
    [sectionInsert setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    sectionInsert.frame = CGRectMake(220, 60, 100, 40);
    [sectionInsert setTitle:@"插入sectin" forState:UIControlStateNormal];
    [sectionInsert addTarget:self action:@selector(sectionInsert) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sectionInsert];
    
}

#pragma mark -- item

-(void)itemReplace
{
    BTSection *section = [_refreshScrollView.sectionArray firstObject];
    
    static int i=0;
    CGFloat height =  70 + random()%30;
    BTBaseItem *item = [[[BTBaseItem alloc] init] autorelease];
    item.cellClass = [BTBaseCell class];
    item.itemHeight = height;
    item.itemData = [NSString stringWithFormat:@"%d",i++];
    
    [section replaceItemAtIndex:0 withItem:item animated:YES];
}

-(void)itemInsert
{
    BTSection *section = [_refreshScrollView.sectionArray firstObject];
    
    [section insertItems:[self createArray:1] atIndex:0 animated:YES];
}

-(void)itemDelete
{
    BTSection *section = [_refreshScrollView.sectionArray firstObject];
    
    [section removeItemsInRange:NSMakeRange(0, 3) animated:YES];
}

-(void)itemAdd
{
    BTSection *section = [_refreshScrollView.sectionArray firstObject];
    NSArray *arr = [self createArray:1];
    [section appendItems:arr animated:YES];
}


#pragma mark -- section

-(void)sectonAppend
{
    BTSection *section3 = [[[BTSection alloc] init] autorelease];
    section3.baseItems = [self createArray:3];
    section3.marignTop = 10;
    section3.numCols = 2;
    section3.cellXGap = 5;
    section3.cellYGap = 5;
    section3.marginLeft = 10;
    
    [_refreshScrollView appendSection:section3];
}
-(void)sectionDelete
{
    [_refreshScrollView removeSectionAtIndex:0];
}
-(void)sectionInsert
{
    BTSection *section3 = [[[BTSection alloc] init] autorelease];
    section3.baseItems = [self createArray:4];
    section3.marignTop = 10;
    section3.numCols = 3;
    section3.marginLeft = 5;
    section3.cellXGap = 5;
    section3.cellYGap = 5;
    section3.marginLeft = 10;
    
    [_refreshScrollView insertSection:section3 atIndex:0];
}





#pragma mark -- delegate

- (void)pullUpLoadMore:(BTRefreshScrollView*)pullTableView
{
    [self performSelector:@selector(appendData:) withObject:pullTableView afterDelay:1];
}
- (void)pullDownTriggerHeaderRefresh:(BTRefreshScrollView*)pullTableView
{
    [self performSelector:@selector(loadData:) withObject:pullTableView afterDelay:1];
}

-(void)loadData:(BTRefreshScrollView *)pullTableView
{
    
    BTSection *section1 = [[[BTSection alloc] init] autorelease];
    
    section1.baseItems = [self createArray:16];
    section1.marignTop = 10;
    section1.numCols = 1;
    section1.marginLeft = 30;
    section1.cellXGap = 5;
    section1.cellYGap = 5;
    
    
    BTSection *section2 = [[[BTSection alloc] init] autorelease];
    section2.baseItems = [self createArray:25];
    section2.marignTop = 10;
    section2.numCols = 1;3;
    section2.marginLeft = 20;
    section2.cellXGap = 5;
    section2.cellYGap = 5;
    
    BTSection *section3 = [[[BTSection alloc] init] autorelease];
    section3.baseItems = [self createArray:7];
    section3.marignTop = 10;
    section3.numCols = 1;
    section3.marginLeft = 10;
    section3.cellXGap = 5;
    section3.cellYGap = 5;
    section3.marginLeft = 10;
    
    [_refreshScrollView setSectionArray:@[section1,section2,section3]];
    [_refreshScrollView showItemsInScreenOffsetY:0];
    
    [pullTableView BTRefreshScrollViewDataSourceDidFinishedLoading];
}


-(void)appendData:(BTRefreshScrollView *)pullTableView
{
    BTSection *section = [_refreshScrollView.sectionArray lastObject];
    NSMutableArray *aa = [self createArray:20];
    BTBaseItem *item = [aa firstObject];
    item.isHeader = NO;
    [section appendItems:aa animated:NO];
    
    [pullTableView BTRefreshScrollViewDataSourceDidFinishedLoading];
}

-(NSMutableArray *)createArray:(NSInteger)num
{
    static int  stc = 0;
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:num];
    for(int i=0;i<num;i++)
    {
        CGFloat height =  40 + random()%30;
        BTBaseItem *item = [[[BTBaseItem alloc] init] autorelease];

        item.cellClass = [BTBaseCell class];
        item.itemHeight = height;
        item.itemData = [NSString stringWithFormat:@"setion:%d  %d",stc,i];
        [array addObject:item];
    }
    stc++;
    return array;
}

@end

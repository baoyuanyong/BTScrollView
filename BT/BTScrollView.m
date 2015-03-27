//
//  BTScrollView.m
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "BTScrollView.h"
#import "BTBaseCell.h"
#import "BTSection.h"

//相交
BOOL static inline CGRectIntersectionLine(CGRect rect, CGFloat line){
    
    if (line <= CGRectGetMaxY(rect) && line >= CGRectGetMinY(rect)) {
        return YES;
    }
    return NO;
}

//rect是否 在minLine与maxLine之间||与minLine相交||与maxLine相交
BOOL static inline CGRectInScope(CGRect rect,CGFloat minLine,CGFloat maxLine)
{
    if ( (CGRectGetMinY(rect) > minLine && CGRectGetMaxY(rect) < maxLine) || CGRectIntersectionLine(rect, minLine) || CGRectIntersectionLine(rect,maxLine)) {
        return YES;
    }
    return NO;
}

@interface BTScrollView ()<BTSectionDelegate>
{
    NSMutableArray *_sectionArray;
    NSMutableArray *_headerItems;

    CGFloat _beforeYOffset;

    NSMutableArray *willShowItemsTemp;//不想创建太多数组
    NSMutableArray *willHideItemsTemp;//不想创建太多数组
    
    BTBaseItem *MaxColumnItems[kMaxColumn];
    BTBaseItem *MinColumnItems[kMaxColumn];
}
@property (nonatomic, retain) NSMutableDictionary *reuseableDictionary;//{className:[],className:[]}

@property (nonatomic, retain) NSMutableArray *beforeRelayoutShowingItems;
@property (nonatomic, retain) NSArray *willRemoveItems;
@property (nonatomic, assign) BOOL isReplacingItem;

@property (nonatomic, assign) BOOL isMovingDown;
@end


@implementation BTScrollView

@synthesize sectionArray = _sectionArray;

-(void)dealloc
{
    [willHideItemsTemp release];
    [willShowItemsTemp release];
    self.reuseableDictionary = nil;
    self.sectionArray = nil;
    self.beforeRelayoutShowingItems = nil;
    self.willRemoveItems = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.reuseableDictionary = [NSMutableDictionary dictionaryWithCapacity:5];
        willHideItemsTemp = [[NSMutableArray arrayWithCapacity:10] retain];
        willShowItemsTemp = [[NSMutableArray arrayWithCapacity:10] retain];
        _headerItems = [[NSMutableArray arrayWithCapacity:5] retain];
    }
    return self;
}


#pragma mark ---

//相当于section功能
-(void)showHeaderItems:(CGFloat)contentOffsetY
{
    BTBaseItem *preItem=nil, *showingItem=nil;
    for(BTBaseItem *item in _headerItems){
        
        if (contentOffsetY >= item.itemFrame.origin.y) {
            preItem = item;
        }
        else if (contentOffsetY + preItem.itemFrame.size.height >= item.itemFrame.origin.y){
            showingItem = item;
        }
        else if( !CGRectEqualToRect(item.currentCell.frame, item.itemFrame) ){
            item.currentCell.frame = item.itemFrame;
        }
    }
    
    CGRect rect = preItem.itemFrame;
    if (preItem && showingItem) {
        
        rect.origin.y = showingItem.itemFrame.origin.y - preItem.itemFrame.size.height;
        preItem.currentCell.frame = rect;
        [self bringSubviewToFront:preItem.currentCell];
    }
    else if(preItem && !showingItem){
        
        rect.origin.y = contentOffsetY;
        preItem.currentCell.frame = rect;
        [self bringSubviewToFront:preItem.currentCell];
    }
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat offsetY =  self.contentOffset.y ;
    CGFloat more = offsetY - _beforeYOffset;
    self.isMovingDown = more >0;
    
    NSMutableArray *showItems = [self willShowItemsIsDown:more>0];
    NSMutableArray *hideItems = [self willHideItemsIsDown:more>0];
    if (hideItems.count) {
        [self hideItems:hideItems];
    }
    if (showItems.count) {
        [self showItems:showItems];
    }
    
    if (_headerItems.count) {
        [self showHeaderItems:offsetY];
    }
    
    _beforeYOffset = offsetY;
}

-(NSMutableArray *)getItemsInScreen
{
    NSMutableArray *clearItems = [NSMutableArray arrayWithCapacity:10];
    BTBaseItem *tempItem = nil;
    NSInteger cols = 0;
    //TODO:MinColumnItems[0] 在极端情况下是会为nil的
    if (MinColumnItems[0] || MaxColumnItems[0]) {
        //屏幕内有数据
        tempItem = MinColumnItems[0];
        if(MinColumnItems[0].parentSection.sectionIndex == MaxColumnItems[0].parentSection.sectionIndex)
        {//处于同一个section
            cols = tempItem.parentSection.numCols;
            for(int i=0;i<cols;){
                
                if (tempItem.currentCell)
                {
                    [clearItems addObject:tempItem];
                }
                
                if (tempItem == MaxColumnItems[i]) {
                    i++;
                    tempItem = MinColumnItems[i];
                }else{
                    tempItem = tempItem.belowItem;
                }
            }
        }else{
            //
            cols = tempItem.parentSection.numCols;
            for(int i=0;i<cols;){

                if (tempItem.currentCell)
                {
                    [clearItems addObject:tempItem];
                }
                tempItem = tempItem.belowItem;
                if (!tempItem) {
                    i++;
                    tempItem = MinColumnItems[i];
                }
            }
            BOOL nextSection = YES;
            NSInteger sectionIndex = MinColumnItems[0].parentSection.sectionIndex;
            sectionIndex ++;
            BTSection *section = nil;
            while (nextSection)
            {
                nextSection = NO;
                if (sectionIndex >= _sectionArray.count) {
                    break;
                }
                section = [_sectionArray objectAtIndex:sectionIndex++];
                tempItem = [section getFirstColumnItem:0];
                cols = section.numCols;
                for(int i=0;i<cols;){
                    
                    if (tempItem.currentCell)
                    {
                        [clearItems addObject:tempItem];
                    }
                    
                    if (tempItem == MaxColumnItems[i] && MaxColumnItems[i]) {
                        i++;
                        tempItem = [section getFirstColumnItem:i];
                    }else if (!tempItem){
                        nextSection = YES;
                        i++;
                        tempItem = [section getFirstColumnItem:i];
                    }else{
                        tempItem = tempItem.belowItem;
                    }
                }
            }
        }
    }
    return clearItems;
}

-(void)showItemsInScreenOffsetY:(CGFloat)offsetY
{
    //TODO:如果不是初始化调用，应该先回收界面内的cell

    NSArray *showItems = [self getLayoutItemsInScreenOffsetY:offsetY];
    [self showItems:showItems];
    [self showItems:_headerItems];
    [self showHeaderItems:offsetY];
}

//获取指定屏幕内的items,同时会设置MinColumnItems,MaxColumnItems
-(NSMutableArray *)getLayoutItemsInScreenOffsetY:(CGFloat)offsetY
{
    if (self.contentSize.height < self.bounds.size.height) {
        offsetY = 0;
    }
    else if(self.contentSize.height - self.bounds.size.height<offsetY){
        offsetY = self.contentSize.height - self.bounds.size.height;
    }
    if (self.contentOffset.y != offsetY) {
        [self setContentOffset:CGPointMake(0, offsetY)];
    }
    
    [willShowItemsTemp removeAllObjects];
    BTSection *section = nil;
    BTBaseItem * tempItem = nil;
    CGFloat endLine = 0;
    
    //确定起点所在的section
    for(int i=0;i<_sectionArray.count;i++){
        section = [_sectionArray objectAtIndex:i];
        endLine = [section getEndLine] - section.mariginBottom;
        if (endLine >= offsetY) {
            break;
        }
    }
    
    //清零
    for(int i=0;i<kMaxColumn;i++){
        MinColumnItems[i] = nil;
        MaxColumnItems[i] = nil;
    }
    
    //设置MinColumnItems数组
    tempItem = [section.baseItems firstObject];
    int  tempSectionCols = MIN(section.numCols, section.baseItems.count);
    int tag = 0;
    while (tag<tempSectionCols) {
        
        if (!tempItem) {
            MinColumnItems[tag++] = nil;
            tempItem = [section getFirstColumnItem:tag];
        }
        else if (offsetY > CGRectGetMaxY(tempItem.itemFrame))
        {
            tempItem = tempItem.belowItem;
        }else{
            MinColumnItems[tag++] = tempItem;
            tempItem = [section getFirstColumnItem:tag];
        }
    }
    
    
    BOOL first = YES;
    BOOL nextSection = YES;
    for(int i=0;i<tempSectionCols;i++){
        if (MinColumnItems[i]) {
            tempItem = MinColumnItems[i];
            break;
        }
    }
    NSInteger minColumnSection = tempItem.parentSection.sectionIndex;
    NSInteger sectionIndex = tempItem.parentSection.sectionIndex;
    
    //终点
    CGFloat bottomY = offsetY + self.bounds.size.height;
    int cols = 0;

    while (nextSection) {
        
        nextSection = NO;
        if (sectionIndex >= _sectionArray.count) {
            break;
        }
        section = [_sectionArray objectAtIndex:sectionIndex++];
        int tag = tempItem.column;
        if (!first)
        {
            tempItem = [section.baseItems firstObject];
            if (bottomY >= CGRectGetMinY(tempItem.itemFrame)) {
                tag = 0;
                //MaxColumnItems都要被替换，设置成nil,便于判断取item
                for (int i=0; i<kMaxColumn; i++) {
                    MaxColumnItems[i] = nil;
                }
            }else{
                //保持当前的MaxColumnItems数组
                break;
            }
        }
        first = NO;
        cols = MIN(tempItem.parentSection.numCols,tempItem.parentSection.baseItems.count);
        
        for( ; tag <cols ; ){

            if(CGRectGetMaxY(tempItem.itemFrame) < bottomY){
                
                MaxColumnItems[tag] = tempItem;//有可能boundary就是这个item和下一个item之间，必须设
                if (tempItem && !tempItem.currentCell && !tempItem.isHeader)
                {
                    [willShowItemsTemp addObject:tempItem];
                }
                tempItem = tempItem.belowItem;
                if (!tempItem)
                {
                    BTBaseItem *lastItem = [section.baseItems lastObject];
                    if (CGRectGetMaxY(lastItem.itemFrame) < bottomY ) {
                        //对于判断是否进行下一个section的检查，这里要求的更精确了
                        nextSection = YES;
                    }
                    tag++ ;
                    if ( minColumnSection ==  section.sectionIndex) {
                        tempItem = MinColumnItems[tag];
                    }else{
                        tempItem = [section getFirstColumnItem:tag];
                    }
                }
            }
            else if (CGRectIntersectionLine(tempItem.itemFrame,bottomY)) {
                
                MaxColumnItems[tag] = tempItem;//一定是最大
                if (tempItem && !tempItem.currentCell && !tempItem.isHeader)
                {
                    [willShowItemsTemp addObject:tempItem];
                }
                tag++;
                if ( minColumnSection ==  section.sectionIndex) {
                    tempItem = MinColumnItems[tag];
                }else{
                    tempItem = [section getFirstColumnItem:tag];
                }
            }
            else if (CGRectGetMinY(tempItem.itemFrame) > bottomY){
                
                tag++ ;
                if ( minColumnSection ==  section.sectionIndex) {
                    tempItem = MinColumnItems[tag];
                }else{
                    tempItem = [section getFirstColumnItem:tag];
                }
            }
        }
    }

    return willShowItemsTemp;
}


#pragma mark --- section callback

-(void)sectionWillCalculateItemsFrame:(BTSection *)section
{
    self.beforeRelayoutShowingItems = [self getItemsInScreen];
}

-(void)section:(BTSection *)section WillRemoveItems:(NSArray *)removeItems
{
    self.willRemoveItems = removeItems;
}

-(void)section:(BTSection *)section WillReplaceItem:(BTBaseItem *)replacedItem
{
    _isReplacingItem = YES;
    self.willRemoveItems = @[replacedItem];
}

-(void)sectionDidCalculateItemsFrame:(BTSection *)section animated:(BOOL)animated
{
    NSInteger index = [_sectionArray indexOfObject:section];
    
    BTBaseItem *lastItem = nil;
    BTBaseItem *firstItem = [section.baseItems firstObject];
    BTBaseItem *preItem = nil;

    if(index != 0)
    {
        BTSection *preSection = [_sectionArray objectAtIndex:index -1];
        lastItem = [preSection.baseItems lastObject];
        lastItem.nextItem = firstItem;
        firstItem.preItem = lastItem;
    }
    
    preItem = [section.baseItems lastObject];
    
    CGFloat offset = [section getEndLine];
    NSInteger sectionIndex = index;
    BTSection *tempSection = nil;
    for(index++;index < _sectionArray.count;)
    {
        tempSection = [_sectionArray objectAtIndex:index++];
        tempSection.sectionDelegate = self;
        [tempSection calculateItemsFrameWithOffsetY:offset sectionNumber:++sectionIndex];
        offset = [tempSection getEndLine];
        
        //让所有的item形成一个链
        firstItem = [tempSection.baseItems firstObject];
        lastItem = [tempSection.baseItems lastObject];
        firstItem.preItem = preItem;
        preItem.nextItem = firstItem;
        preItem = lastItem;
    }
    
    CGSize size = self.contentSize;
    size.height = offset;
    self.contentSize = size;
    
    
    //新添加数组
    NSMutableArray *willLayoutItems = [self getLayoutItemsInScreenOffsetY:self.contentOffset.y];

    
    //回收数组
    NSMutableArray *removeItems = [NSMutableArray arrayWithCapacity:10];
    for(BTBaseItem *baseItem in _beforeRelayoutShowingItems){
       //不在当前屏幕内，以及与当今屏幕不相交
        if (!CGRectInScope(baseItem.itemFrame, self.contentOffset.y, self.contentOffset.y + self.bounds.size.height)) {
            [removeItems addObject:baseItem];
        }
    }
    //重新布局数组
    [_beforeRelayoutShowingItems removeObjectsInArray:removeItems];
    
    [self hideItems:removeItems];
    
    if (_isReplacingItem) {
        _isReplacingItem = NO;
        
        BTBaseItem *removeItem = [_willRemoveItems firstObject];
        BTBaseItem *animatedItem = nil;
        
        for(BTBaseItem *item in willLayoutItems)
        {
            if (item.index == removeItem.index) {
                animatedItem = item;
                break;
            }
        }
        
        [willLayoutItems removeObject:animatedItem];
        
        animatedItem.currentCell = removeItem.currentCell;
        removeItem.currentCell = nil;
        
        
        if (animated) {
            
            [UIView animateWithDuration:0.25 animations:^{
                
                if (animatedItem) {
                    //排除不在屏幕内
                    [self relayoutItems:@[animatedItem]];
                }
                [self relayoutItems:_beforeRelayoutShowingItems];
                [self showItems:willLayoutItems];
                
            } completion:^(BOOL finished) {
                [_beforeRelayoutShowingItems removeAllObjects];
                self.willRemoveItems = nil;
            }];

        }else{
            
            if (animatedItem) {
                //排除不在屏幕内
                [self relayoutItems:@[animatedItem]];
            }
            [self relayoutItems:_beforeRelayoutShowingItems];
            [self showItems:willLayoutItems];
            [_beforeRelayoutShowingItems removeAllObjects];
            self.willRemoveItems = nil;
        }
    }
    else{
        
        [self hideItems:_willRemoveItems];
        
        if (animated) {
            [UIView animateWithDuration:0.25 animations:^{
                
                [self relayoutItems:_beforeRelayoutShowingItems];
                [self showItems:willLayoutItems];
                
            } completion:^(BOOL finished) {
                [_beforeRelayoutShowingItems removeAllObjects];
                self.willRemoveItems = nil;
            }];
        }
        else{
            [self relayoutItems:_beforeRelayoutShowingItems];
            [self showItems:willLayoutItems];
            [_beforeRelayoutShowingItems removeAllObjects];
            self.willRemoveItems = nil;
        }
    }
}
#pragma mark -- 对section的操作
/**
 * 对sectionArray进行布局，形成链接关系
 *
 **/
-(void)setSectionArray:(NSArray *)sectionArray
{
    //回收界面内cell
    if (MinColumnItems[0]) {
        NSArray *items = [self getItemsInScreen];
        [self hideItems:items];
    }
    if (_headerItems.count) {
        [self hideItems:_headerItems];
        [_headerItems removeAllObjects];
    }
    
    
    [_sectionArray release];
    _sectionArray = [[NSMutableArray arrayWithArray:sectionArray] retain];
    
    CGFloat offset = 0;
    BTBaseItem *preItem = nil;
    BTBaseItem *firstItem = nil;
    BTBaseItem *lastItem = nil;
    NSInteger sectionIndex = 0;
    for(BTSection *section in _sectionArray)
    {
        section.sectionDelegate = self;
        [section calculateItemsFrameWithOffsetY:offset sectionNumber:sectionIndex++];
        offset = [section getEndLine];
        
        //让所有的item形成一个链
        firstItem = [section.baseItems firstObject];
        lastItem = [section.baseItems lastObject];
        firstItem.preItem = preItem;
        preItem.nextItem = firstItem;
        preItem = lastItem;
        
        [_headerItems addObjectsFromArray:[section getHeaderItems]];
    }
    
    CGSize size = self.contentSize;
    size.height = offset;
    self.contentSize = size;
}

-(void)removeSectionAtIndex:(NSInteger)index
{
    if (index >= _sectionArray.count) {
        return ;
    }
    
    NSMutableArray *showingItems =  [self getItemsInScreen];
    BTSection *section = [[[_sectionArray objectAtIndex:index] retain] autorelease];
    
    NSArray *sectionFixItems = [section getHeaderItems];
    [_headerItems removeObjectsInArray:sectionFixItems];
    [self hideItems:sectionFixItems];
    
    BTBaseItem *preItem = nil, *lastItem = nil;
    BTBaseItem *firstItem = [section.baseItems firstObject];
    NSInteger sectionIndex = section.sectionIndex;
    CGFloat offset = section.offsetY;
    preItem = firstItem.preItem;
    
    BTSection *tempSection = nil;
    NSInteger sectionNumber = sectionIndex;
    sectionIndex++;
    for(;sectionIndex < _sectionArray.count;)
    {
        tempSection = [_sectionArray objectAtIndex:sectionIndex++];
        tempSection.sectionDelegate = self;
        [tempSection calculateItemsFrameWithOffsetY:offset sectionNumber:sectionNumber++];
        offset = [tempSection getEndLine];
        
        //让所有的item形成一个链
        firstItem = [tempSection.baseItems firstObject];
        lastItem = [tempSection.baseItems lastObject];
        firstItem.preItem = preItem;
        preItem.nextItem = firstItem;
        preItem = lastItem;
    }
    
    [_sectionArray removeObjectAtIndex:index];
    
    CGSize size = self.contentSize;
    size.height = offset;
    self.contentSize = size;
    
    //新添加数组
    NSMutableArray *willLayoutItems = [self getLayoutItemsInScreenOffsetY:self.contentOffset.y];
    
    //回收数组
    NSMutableArray *removeItems = [NSMutableArray arrayWithCapacity:10];
    for(BTBaseItem *baseItem in showingItems){
        //不在当前屏幕内，以及与当今屏幕不相交
        if (!CGRectInScope(baseItem.itemFrame, self.contentOffset.y, self.contentOffset.y + self.bounds.size.height)) {
            [removeItems addObject:baseItem];
        }
    }
    
    [showingItems removeObjectsInArray:removeItems];
    [self hideItems:removeItems];
    [self hideItems:section.baseItems];
    [self relayoutItems:showingItems];
    [self showItems:willLayoutItems];
}

-(void)insertSection:(BTSection *)insertSection atIndex:(NSInteger)index
{
    if (index >= _sectionArray.count) {
        return ;
    }
    
    NSMutableArray *showingItems =  [self getItemsInScreen];
    
    BTSection *section = [_sectionArray objectAtIndex:index] ;
    BTBaseItem *lastItem = nil;
    BTBaseItem *firstItem = [section.baseItems firstObject];
    BTBaseItem *preItem = firstItem.preItem;
    NSInteger sectionIndex = section.sectionIndex;
    CGFloat offset = section.offsetY;
    NSInteger sectionNumber = sectionIndex;
    
    
    NSMutableArray *tempfixItems = [NSMutableArray arrayWithCapacity:5];
    for(BTBaseItem *item in _headerItems){
        if (item.parentSection.sectionIndex >= index) {
            [tempfixItems addObject:item];
        }
    }
    [_headerItems removeObjectsInArray:tempfixItems];
    [self hideItems:tempfixItems];
    [tempfixItems removeAllObjects];
    
    
    insertSection.sectionDelegate = self;
    [insertSection calculateItemsFrameWithOffsetY:offset sectionNumber:sectionNumber];
    offset = [insertSection getEndLine];
    [tempfixItems addObjectsFromArray:[insertSection getHeaderItems]];
    
    //让所有的item形成一个链
    firstItem = [insertSection.baseItems firstObject];
    lastItem = [insertSection.baseItems lastObject];
    firstItem.preItem = preItem;
    preItem.nextItem = firstItem;
    preItem = lastItem;
    
    
    BTSection *tempSection = nil;
    sectionNumber++;
    for(;sectionIndex < _sectionArray.count;)
    {
        tempSection = [_sectionArray objectAtIndex:sectionIndex++];
        tempSection.sectionDelegate = self;
        [tempSection calculateItemsFrameWithOffsetY:offset sectionNumber:sectionNumber++];
        offset = [tempSection getEndLine];
        
        [tempfixItems addObjectsFromArray:[tempSection getHeaderItems]];
        
        //让所有的item形成一个链
        firstItem = [tempSection.baseItems firstObject];
        lastItem = [tempSection.baseItems lastObject];
        firstItem.preItem = preItem;
        preItem.nextItem = firstItem;
        preItem = lastItem;
    }
    
    [_headerItems addObjectsFromArray:tempfixItems];
    [_sectionArray insertObject:insertSection atIndex:index];
    
    CGSize size = self.contentSize;
    size.height = offset;
    self.contentSize = size;
    
    //新添加数组
    NSMutableArray *willLayoutItems = [self getLayoutItemsInScreenOffsetY:self.contentOffset.y];
    
    //回收数组
    NSMutableArray *removeItems = [NSMutableArray arrayWithCapacity:10];
    for(BTBaseItem *baseItem in showingItems){
        //不在当前屏幕内，以及与当今屏幕不相交
        if (!CGRectInScope(baseItem.itemFrame, self.contentOffset.y, self.contentOffset.y + self.bounds.size.height)) {
            [removeItems addObject:baseItem];
        }
    }
    
    [showingItems removeObjectsInArray:removeItems];
    [self hideItems:removeItems];
    [self relayoutItems:showingItems];
    [self showItems:willLayoutItems];
    [self showItems:tempfixItems];
}

-(void)appendSection:(BTSection *)section
{
    NSMutableArray *showingItems =  [self getItemsInScreen];
    
    BTSection *lastSection = [_sectionArray lastObject];
    BTBaseItem *preItem = [lastSection.baseItems lastObject];
    NSInteger sectionIndex = lastSection.sectionIndex + 1;
    
    section.sectionDelegate = self;
    [section calculateItemsFrameWithOffsetY:[lastSection getEndLine] sectionNumber:sectionIndex];
    BTBaseItem *firstItem = [section.baseItems firstObject];
    preItem.nextItem = firstItem;
    firstItem.preItem = preItem;
    [_sectionArray addObject:section];
    [_headerItems addObjectsFromArray:[section getHeaderItems]];
    
    CGSize size = self.contentSize;
    size.height = [section getEndLine];
    self.contentSize = size;
    
    //新添加数组
    NSMutableArray *willLayoutItems = [self getLayoutItemsInScreenOffsetY:self.contentOffset.y];
    
    //回收数组
    NSMutableArray *removeItems = [NSMutableArray arrayWithCapacity:10];
    for(BTBaseItem *baseItem in _beforeRelayoutShowingItems){
        //不在当前屏幕内，以及与当今屏幕不相交
        if (!CGRectInScope(baseItem.itemFrame, self.contentOffset.y, self.contentOffset.y + self.bounds.size.height)) {
            [removeItems addObject:baseItem];
        }
    }
    
    [showingItems removeObjectsInArray:removeItems];
    [self hideItems:removeItems];
    [self relayoutItems:showingItems];
    [self showItems:willLayoutItems];
    [self showItems:[section getHeaderItems]];
}




#pragma mark ---- 滑动时计算 回收、显示cell

//isDown 是否由下往上滑动
-(NSMutableArray *)willShowItemsIsDown:(BOOL)isDown
{
    [willShowItemsTemp removeAllObjects];
    BTBaseItem *tempItem = nil;
    CGFloat boundary = 0;
    NSInteger cols = 0, sectionIndex = 0;
    BTSection *section = nil;
    BOOL first = YES;
    int tag = 0;
    if(isDown)
    {
        BOOL nextSection = YES;
        boundary = self.contentOffset.y + self.frame.size.height;
        for(int i=0;i<kMaxColumn;i++){
            if (MaxColumnItems[i]) {
                tempItem = MaxColumnItems[i];
                break;
            }
        }
        sectionIndex = tempItem.parentSection.sectionIndex;
        tag = tempItem.column;

        while (nextSection)
        {
            nextSection = NO;
            if (sectionIndex >= _sectionArray.count) {
                break;
            }
            section = [_sectionArray objectAtIndex:sectionIndex++];
            
            if (!first) {
                
                tempItem = [section.baseItems firstObject];
                if (boundary >= CGRectGetMinY(tempItem.itemFrame)) {
                    tag = 0;
                    //MaxColumnItems都要被替换，设置成nil,便于判断取item
                    for (int i=0; i<kMaxColumn; i++) {
                        MaxColumnItems[i] = nil;
                    }
                }else{
                    //保持当前的MaxColumnItems数组
                    break;
                }
            }
            first = NO;
            cols = MIN(tempItem.parentSection.numCols,tempItem.parentSection.baseItems.count);
            
            for( ; tag<cols ; ){
                
                if(CGRectGetMaxY(tempItem.itemFrame) < boundary){
                    
                    MaxColumnItems[tag] = tempItem;//有可能boundary就是这个item和下一个item之间，必须设
                    if (tempItem && !tempItem.currentCell && !tempItem.isHeader)
                    {
                        [willShowItemsTemp addObject:tempItem];
                    }
                    tempItem = tempItem.belowItem;
                    if (!tempItem)
                    {
                        BTBaseItem *lastItem = [section.baseItems lastObject];
                        if (CGRectGetMaxY(lastItem.itemFrame) < boundary ) {
                            //对于判断是否进行下一个section的检查，这里要求的更精确了
                            nextSection = YES;
                        }
                        tag++ ;
                        tempItem = MaxColumnItems[tag];
                        if (!tempItem) {
                            tempItem = [section getFirstColumnItem:tag];
                        }
                    }
                }
                else if (CGRectIntersectionLine(tempItem.itemFrame,boundary)) {
                    
                    MaxColumnItems[tag] = tempItem;//一定是最大
                    if (tempItem && !tempItem.currentCell && !tempItem.isHeader)
                    {
                        [willShowItemsTemp addObject:tempItem];
                    }
                    tag++;
                    tempItem = MaxColumnItems[tag];
                    if (!tempItem) {
                        tempItem = [section getFirstColumnItem:tag];
                    }
                }
                else{
                    
                    tag++ ;
                    tempItem = MaxColumnItems[tag];
                    if (!tempItem) {
                        tempItem = [section getFirstColumnItem:tag];
                    }
                }
            }
        }
        
    }else{
        
        BOOL beforeSection = YES;
        boundary = self.contentOffset.y;
        
        //可能的情况：MinColumnItems[0]=nil,MinColumnItems[1]有值
        for(int i=0;i<kMaxColumn;i++){
            if (MinColumnItems[i]) {
                tempItem = MinColumnItems[i];
                break;
            }
        }
        if (tempItem.column != 0 ) {
            tempItem = [tempItem.parentSection getLastColumnItem:0];
        }
        
        sectionIndex = tempItem.parentSection.sectionIndex;
        BOOL checkNextColoum = NO;

        while (beforeSection)
        {
            beforeSection = NO;
            if (sectionIndex < 0) {
                break;
            }
            section = [_sectionArray objectAtIndex:sectionIndex--];
            tag = 0;
            if (!first) {
                
                tempItem = [section.baseItems lastObject];
                if (boundary > CGRectGetMaxY(tempItem.itemFrame)) {
                    break;
                }else{
                    //这样设置的MinColumnItems，很有可能是不会真的显示的
                    //比如，有三列。向上移动时，只有一页显示，另外两列没有显示
                    for (int i=0; i<kMaxColumn; i++) {
                        MinColumnItems[i] = [section getLastColumnItem:i];
                    }
                    tempItem = MinColumnItems[0];
                }
            }
            
            first = NO;
            cols = MIN(tempItem.parentSection.numCols,tempItem.parentSection.baseItems.count);
            
            for( ; tag<cols ; ){

                if (CGRectGetMinY(tempItem.itemFrame) > boundary)
                {
                    MinColumnItems[tag] = tempItem;
                    if (tempItem && !tempItem.currentCell && !tempItem.isHeader)
                    {
                        [willShowItemsTemp addObject:tempItem];
                    }
                    tempItem = tempItem.aboveItem;
                    if (!tempItem) {
                        beforeSection = YES;
                        checkNextColoum = YES;
                    }
                }
                else if (CGRectIntersectionLine(tempItem.itemFrame,boundary)) {
                    //满足这个条件，就是终结
                    MinColumnItems[tag] = tempItem;
                    if (tempItem && !tempItem.currentCell && !tempItem.isHeader)
                    {
                        [willShowItemsTemp addObject:tempItem];
                    }
                    checkNextColoum = YES;
                }
                else if(CGRectGetMaxY(tempItem.itemFrame) < boundary){
                    //不能加入
                    checkNextColoum = YES;
                }
                
                if (checkNextColoum)
                {
                    checkNextColoum = NO;
                    
                    tag++;
                    if (!MinColumnItems[tag]) {
                        tempItem = [section getLastColumnItem:tag];
                    }else{
                        tempItem = MinColumnItems[tag];
                    }
                }
            }
        }
    }
    
    return willShowItemsTemp;
}

-(NSMutableArray *)willHideItemsIsDown:(BOOL)isDown
{
    [willHideItemsTemp removeAllObjects];
    BTBaseItem *tempItem = nil;
    CGFloat boundary = 0;
    NSInteger cols = 0, sectionIndex = 0;
    BTSection *section =nil;
    BOOL first = YES;
    int tag = 0;
    if (isDown) {
        
        BOOL nextSection = YES;
        boundary = self.contentOffset.y;
        for(int i=0;i<kMaxColumn;i++){
            if (MinColumnItems[i]) {
                tempItem = MinColumnItems[i];
                break;
            }
        }
        sectionIndex = tempItem.parentSection.sectionIndex;
        tag = tempItem.column;
        
        while (nextSection) {
            
            nextSection = NO;
            if (sectionIndex >= _sectionArray.count) {
                break;
            }
            section = [_sectionArray objectAtIndex:sectionIndex++];
            if (!first) {
                tag = 0;
                tempItem = [section.baseItems firstObject];
                //只有上个月section的cell都彻底不在屏幕内了，才会进行下一个section的判断
                for (int i=0; i<kMaxColumn; i++) {
                    MinColumnItems[i] = [section getFirstColumnItem:i];
                }
            }
            first = NO;
            cols = MIN(tempItem.parentSection.numCols,tempItem.parentSection.baseItems.count);
            
            for( ; tag<cols ; ){
                
                if ( boundary > CGRectGetMaxY(tempItem.itemFrame)) {
                    
                    if (tempItem.currentCell && !tempItem.isHeader) {
                        [willHideItemsTemp addObject:tempItem];
                    }
                    
                    tempItem = tempItem.belowItem;
                    if (!tempItem) {
                        BTBaseItem *lastItem = [section.baseItems lastObject];
                        if (CGRectGetMaxY(lastItem.itemFrame) < boundary ) {
                            //对于判断是否进行下一个section的检查，这里要求的更精确了
                            nextSection = YES;
                        }
                        tag++;
                        tempItem = MinColumnItems[tag];
                    }
                }else{
                    //这个不能隐藏，得留着
                    MinColumnItems[tag] = tempItem;//一定是最小的，在界面内
                    tag++;
                    tempItem = MinColumnItems[tag];
                }
            }
        }
    }
    else{
        
        BOOL beforeSection = YES;
        boundary = self.contentOffset.y + self.frame.size.height;
        for(int i=0;i<kMaxColumn;i++){
            if (MaxColumnItems[i]) {
                tempItem = MaxColumnItems[i];
                break;
            }
        }
        if (tempItem.column != 0 ) {
            tempItem = [tempItem.parentSection getLastColumnItem:0];
        }
        sectionIndex = tempItem.parentSection.sectionIndex;
        
        while (beforeSection) {
            
            beforeSection = NO;
            if (sectionIndex < 0) {
                break ;
            }
            section = [_sectionArray objectAtIndex:sectionIndex--];
            
            if (!first) {
                
                tempItem = [section.baseItems lastObject];
                if (CGRectGetMaxY(tempItem.itemFrame) < boundary) {
                    break;//保持当前，不用再检查了
                }else{
                    //MinColumnItems都要被替换，设置成nil,便于判断取item
                    for (int i=0; i<kMaxColumn; i++) {
                        MaxColumnItems[i] = [section getLastColumnItem:i];
                    }
                }
                tempItem = MaxColumnItems[0];
            }
            first = NO;
            cols = MIN(tempItem.parentSection.numCols,tempItem.parentSection.baseItems.count);
            for(int i=0 ;i <cols ; ){
                
                if(CGRectGetMinY(tempItem.itemFrame) > boundary){
                    
                    if (tempItem.currentCell && !tempItem.isHeader) {
                        [willHideItemsTemp addObject:tempItem];
                    }
                    
                    tempItem = tempItem.aboveItem;
                    if (!tempItem) {
                        beforeSection = YES;
                        i++;
                        tempItem = MaxColumnItems[i];
                    }
                }
                else {
                    if(CGRectGetMaxY(tempItem.itemFrame) >= self.contentOffset.y){
                        //过滤一种极端情况
                        MaxColumnItems[i]=tempItem;
                    }
                    i++;
                    tempItem = MaxColumnItems[i];
                }
            }
        }
    }
    
    return willHideItemsTemp;
}

#pragma mark -- reusable cell


//搜寻可重复利用的cell,如果没有就创建一个
-(BTBaseCell *)dequeueReuseableCellIdentityClass:(Class)theIdentity;
{
    NSString *classStr = NSStringFromClass(theIdentity);
    NSMutableArray *classMutArr = [self.reuseableDictionary objectForKey:classStr];
    if (!classMutArr) {
        classMutArr = [NSMutableArray arrayWithCapacity:5];
        [self.reuseableDictionary setObject:classMutArr forKey:classStr];
    }
    
    BTBaseCell *baseCell = nil;
    
    if ([classMutArr count])
    {
        baseCell = [[classMutArr firstObject]  retain];
        [classMutArr removeObject:baseCell];
        [baseCell autorelease];
    }
    
    return baseCell;
}

//将不在屏幕内的cell,加入队列，以备重复利用
-(void)enqueueReusableCell:(BTBaseCell *)baseCell
{
    NSString *classStr = NSStringFromClass([baseCell class]);
    NSMutableArray *classMutArr = [self.reuseableDictionary objectForKey:classStr];
    
    if (!classMutArr) {
        classMutArr = [NSMutableArray arrayWithCapacity:10];
        [self.reuseableDictionary setObject:classMutArr forKey:classStr];
    }
    
    [classMutArr addObject:baseCell];
}

//显示的cell需要做的初始化和数据加载
-(void)showItems:(NSArray *)showItems
{
    for(BTBaseItem *item in showItems)
    {
        BTBaseCell *cell = [self dequeueReuseableCellIdentityClass:item.cellClass];
        
        if(!cell)
        {
            cell = [[[item.cellClass alloc] initWithFrame:item.itemFrame] autorelease];
        }
        item.currentCell = cell;
        cell.baseCellDelegate = item;
        [item refreshCurrentCell];
        [self addSubview:cell];
    }
}
//cell位置有调整
-(void)relayoutItems:(NSArray *)relayoutItems
{
    for(BTBaseItem *item in relayoutItems)
    {
        if(item.currentCell){
        
            [item refreshCurrentCell];
        }
    }
}

-(void)hideItems:(NSArray *)hideItems
{
    for(BTBaseItem *item in hideItems)
    {
        if (item.currentCell) {
            [self enqueueReusableCell:item.currentCell];
            [item.currentCell removeFromSuperview];
            item.currentCell = nil;
        }
    }
}


@end
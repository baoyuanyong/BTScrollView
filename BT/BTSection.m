//
//  BTSectionItem.m
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "BTSection.h"

@interface BTSection ()
{
    CGFloat colsHeight[kMaxColumn];//一行不会有太多列吧
    BTBaseItem *verticalItems[kMaxColumn];
}

@property (nonatomic, retain) NSMutableArray *headerItems;

@end


@implementation BTSection

-(void)dealloc
{
    self.baseItems = nil;
    self.headerItems = nil;
    [super dealloc];
}

-(id)init{
    if (self = [super init]) {
        _numCols = 1;
        _marginLeft = _marginRight = _mariginBottom = _marignTop = 0;
        _cellXGap = _cellYGap = 0;
        _headerItems = [[NSMutableArray arrayWithCapacity:2] retain];
    }
    return self;
}

-(NSArray *)getHeaderItems
{
    return _headerItems;
}

-(CGFloat)getEndLine
{
    NSInteger maxCol = [self getCurrentColsIndexMax:YES];
    return colsHeight[maxCol]  + self.mariginBottom;
}

/**
 * 获取某一列的第一个元素
 **/
-(BTBaseItem *)getFirstColumnItem:(NSInteger)index
{
    if ( index > _numCols -1 || index >= _baseItems.count) {
        return nil;
    }
    return [_baseItems objectAtIndex:index];
}

/**
 * 获取某一列的最后一个元素
 **/
-(BTBaseItem *)getLastColumnItem:(NSInteger)index
{
    if ( index > _numCols -1 || index >= _baseItems.count) {
        return nil;
    }
    
    BTBaseItem *lastItem = [_baseItems lastObject];
    
    for(int i=0;i<_baseItems.count;i++){
        
        if (lastItem.column == index) {
            break;
        }
        lastItem = lastItem.preItem;
    }
    return lastItem;
}


-(void)calculateItemsFrameWithOffsetY:(CGFloat)offsetY sectionNumber:(NSInteger)sectionNum;
{
    _offsetY = offsetY;
    self.sectionIndex = sectionNum;
    [self calculateItemsFrame:_baseItems fromIndex:0 inheritLayout:NO];
}


//isMax=YES返回最大列，isMax=NO返回最小列
-(NSInteger)getCurrentColsIndexMax:(BOOL)isMax
{
    NSInteger index = 0;
    for(int i=1;i<self.numCols;i++)
    {
        if (isMax && colsHeight[index] < colsHeight[i]) {
            index = i;
        }else if(!isMax && colsHeight[index] > colsHeight[i]){
            index = i;
        }
    }
    return index;
}

//1,开始布局
//传入cellItems,offsetY有值,fromIndex=0

//2,从某个item开始
// offsetY不取值，fromIndex >0
//从某个item开始的要重新计算，从这个index,向前反向重新获得设置colHeight[],并布局

//关键是获得colHeight[]后，布局
//fromIndex就是将要放置的index

/**
 * @param cellItems 将要进行布局计算的items
 * @param fromIndex cellItems的布局计算起始下标
 * @param isInherited 是否是在原有布局计算的基础上进行布局
 **/

-(void)calculateItemsFrame:(NSArray *)cellItems fromIndex:(NSInteger)fromIndex inheritLayout:(BOOL)isInherited
{
    CGFloat tempHeight = _offsetY;
    tempHeight += self.marignTop;
    //初始化colHeight[]
    for(int i=0;i<_numCols;i++){
        colsHeight[i] = tempHeight;
        verticalItems[i] = nil;
    }
    
    BTBaseItem *preItem = nil;
    
    if (!isInherited) {
        self.colWidth = ([UIScreen mainScreen].bounds.size.width - self.marginLeft-self.marginRight -(self.numCols -1)*self.cellXGap)/self.numCols;
        [_headerItems removeAllObjects];
    }else{
        
        //如果是第二种情况，需要逆向设置colHeight[],和verticalItems[]
        BTBaseItem *tempItem = [_baseItems lastObject];
        
        //处理section
        NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:2];
        for(BTBaseItem *item in _headerItems){
            if (item.index > tempItem.index) {
                [tempArr addObject:tempItem];
            }
        }
        [_headerItems removeObjectsInArray:tempArr];
        
        
        preItem = tempItem;
        int num = 0;
        BOOL tempCols[kMaxColumn] = {0};
        
        for(int i=fromIndex ;i>=0 ;i--)
        {
            if (!tempCols[tempItem.column])
            {
                colsHeight[tempItem.column] = CGRectGetMaxY(tempItem.itemFrame) + _cellYGap;
                verticalItems[tempItem.column] = tempItem;
                
                //至少检测的每一列的一个item,这样才能确保，跳出是正确的
                tempCols[tempItem.column] = YES;
                
                num = 0;
                for(int j=0;j<_numCols;j++)
                {
                    if (tempCols[j]) {
                        num++;
                    }else{
                        break;
                    }
                }
                if (num == _numCols) {
                    break;
                }
            }
            tempItem = tempItem.preItem;
        }
    }
    
    NSInteger index = fromIndex;
    NSInteger minCol = 0;
    CGPoint origin = CGPointZero;
    
    for(BTBaseItem *item in cellItems)
    {
        //获取当前列高度最小的 列标
        minCol = [self getCurrentColsIndexMax:NO];
        origin.x = self.marginLeft + minCol*(self.colWidth + self.cellXGap);
        origin.y = colsHeight[minCol];
        item.itemFrame = CGRectMake(origin.x,origin.y,_colWidth, item.itemHeight);
        
        if (item.isHeader) {
            [_headerItems addObject:item];
        }
        
        item.parentSection = self;
        item.index = index++;
        item.column = minCol;
    
        
        colsHeight[minCol] = CGRectGetMaxY(item.itemFrame) + self.cellYGap;
        item.baseItemDelegate = self;//点击cell回调时使用

        
        //形成链表
        preItem.nextItem = item;
        item.preItem = preItem;
        preItem = item;
        
        //形成竖直链
        item.aboveItem = verticalItems[minCol];
        verticalItems[minCol].belowItem = item;
        verticalItems[minCol] = item;
    }
}




#pragma mark --- 对section内部数据操作

-(BOOL)appendItems:(NSArray *)appendItems animated:(BOOL)animated
{
    //1,_baseItems 不需要改变
    //2.带着数据布局
    
    if([_sectionDelegate respondsToSelector:@selector(sectionWillCalculateItemsFrame:)]){
        [_sectionDelegate sectionWillCalculateItemsFrame:self];
    }
    
    [self calculateItemsFrame:appendItems fromIndex:_baseItems.count inheritLayout:YES];
    
    [_baseItems addObjectsFromArray:appendItems];
    
    if([_sectionDelegate respondsToSelector:@selector(sectionDidCalculateItemsFrame: animated:)]){
        [_sectionDelegate sectionDidCalculateItemsFrame:self animated:animated];
    }
    
    return YES;
}


-(BOOL)removeItemsInRange:(NSRange)range animated:(BOOL)animated
{
    if (!range.length||
        (range.location == 0 && range.length >= _baseItems.count) ||
        (range.location != 0 && range.location + range.length -1 >= _baseItems.count))
    {
        return NO;
    }
    
    if([_sectionDelegate respondsToSelector:@selector(sectionWillCalculateItemsFrame:)]){
        [_sectionDelegate sectionWillCalculateItemsFrame:self];
    }
    
    if ([_sectionDelegate respondsToSelector:@selector(section:WillRemoveItems:)]) {
        [_sectionDelegate section:self WillRemoveItems:[_baseItems subarrayWithRange:range]];
    }
    
    if (range.location == 0) {
        
        [_baseItems removeObjectsInRange:range];
        [self calculateItemsFrame:_baseItems fromIndex:0 inheritLayout:NO];
        
    }
    else{
        
        //重新计算受影响的item.frame
        NSUInteger location = range.location+range.length;
        NSUInteger length = _baseItems.count - location;
        NSArray *appendArray = [_baseItems subarrayWithRange:NSMakeRange(location,length)];
        
        //只留下不需要重新布局的数据
        [_baseItems removeObjectsInRange:NSMakeRange(range.location, _baseItems.count - range.location)];
        [self calculateItemsFrame:appendArray fromIndex:range.location inheritLayout:YES];
        
        [_baseItems addObjectsFromArray:appendArray];
    }
    
    if([_sectionDelegate respondsToSelector:@selector(sectionDidCalculateItemsFrame: animated:)]){
        [_sectionDelegate sectionDidCalculateItemsFrame:self animated:animated];
    }
    
    return YES;
}


-(BOOL)insertItems:(NSArray *)insertItems atIndex:(NSInteger)index animated:(BOOL)animated
{
    if (index > _baseItems.count || index < 0 || !insertItems.count) {
        return NO;
    }
    
    if (index == _baseItems.count) {
        [self appendItems:insertItems animated:animated];
        return YES;
    }
    
    
    if([_sectionDelegate respondsToSelector:@selector(sectionWillCalculateItemsFrame:)]){
        [_sectionDelegate sectionWillCalculateItemsFrame:self];
    }
    
    NSRange range = NSMakeRange(index, _baseItems.count - index);
    NSArray *moveItems = [_baseItems subarrayWithRange:range];
    NSMutableArray *appendItems = [NSMutableArray arrayWithArray:insertItems];
    [appendItems addObjectsFromArray:moveItems];
    
    [_baseItems removeObjectsInArray:moveItems];
    
    if (index == 0) {
        //index=0时，需要完全的布局
        [self calculateItemsFrame:appendItems fromIndex:0 inheritLayout:NO];
    }else{
        [self calculateItemsFrame:appendItems fromIndex:index inheritLayout:YES];
    }
    
    
    [_baseItems addObjectsFromArray:appendItems];
    
    
    if([_sectionDelegate respondsToSelector:@selector(sectionDidCalculateItemsFrame: animated:)]){
        [_sectionDelegate sectionDidCalculateItemsFrame:self animated:animated];
    }
    
    return YES;
    
}
-(BOOL)replaceItemAtIndex:(NSInteger)index withItem:(BTBaseItem *)newItem animated:(BOOL)animated
{
    if (!newItem || index >= _baseItems.count || index <0) {
        return NO;
    }
    
    if([_sectionDelegate respondsToSelector:@selector(sectionWillCalculateItemsFrame:)]){
        [_sectionDelegate sectionWillCalculateItemsFrame:self];
    }
    
    if([_sectionDelegate respondsToSelector:@selector(section:WillReplaceItem:)]){
        [_sectionDelegate section:self WillReplaceItem:[_baseItems objectAtIndex:index]];
    }
    
    NSRange range = NSMakeRange(index, _baseItems.count - index);
    NSMutableArray *moveItems = [NSMutableArray arrayWithArray:[_baseItems subarrayWithRange:range]];
    [_baseItems removeObjectsInArray:moveItems];
    
    [moveItems replaceObjectAtIndex:0 withObject:newItem];
    
    if (index == 0) {
        //index=0时，需要完全的布局
        [self calculateItemsFrame:moveItems fromIndex:0 inheritLayout:NO];
    }else{
        [self calculateItemsFrame:moveItems fromIndex:index inheritLayout:YES];
    }
    [_baseItems addObjectsFromArray:moveItems];
    
    if([_sectionDelegate respondsToSelector:@selector(sectionDidCalculateItemsFrame: animated:)]){
        [_sectionDelegate sectionDidCalculateItemsFrame:self animated:animated];
    }
    
    return YES;
}

@end

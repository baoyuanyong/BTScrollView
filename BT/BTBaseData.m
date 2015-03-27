

//
//  BTBaseData.m
//  Test_Test
//
//  Created by 鲍远勇 on 15-1-30.
//  Copyright (c) 2015年 鲍远勇. All rights reserved.
//

#import "BTBaseData.h"

@implementation BTBaseData

-(void)dealloc
{
    self.name = nil;
    self.title = nil;
    [super dealloc];
}

@end

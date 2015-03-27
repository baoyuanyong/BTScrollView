//
//  BTUtilsDef.m
//  Test_Test
//
//  Created by 鲍远勇 on 14-9-16.
//  Copyright (c) 2014年 鲍远勇. All rights reserved.
//

#import "BTUtilsDef.h"

@implementation BTUtilsDef

+(CGRect)navigationBarFrame
{
    if (isIOS7) {
        return CGRectMake(0, 20, kScreenBound.size.width, 44);
    }else{
        return CGRectMake(0, 0, kScreenBound.size.width, 44);
    }
}

@end

//
//  HNTabBar.m
//  HNProject
//
//  Created by user on 2017/7/13.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HNTabBar.h"

@implementation HNTabBar


-(instancetype)init{
    
    if (self=[super init]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setTintColor:RGB(37, 37, 37)];
        self.translucent = NO;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}
@end

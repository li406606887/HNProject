//
//  PersonalViewModel.m
//  JYQHProject
//
//  Created by user on 2017/7/7.
//  Copyright © 2017年 zero. All rights reserved.
//

#import "PersonalViewModel.h"

@implementation PersonalViewModel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(RACSubject *)personalCellClick{
    if (!_personalCellClick) {
        _personalCellClick = [RACSubject subject];
    }
    return _personalCellClick;
}
-(RACSubject *)personalDataUpdateClick{
    if (!_personalDataUpdateClick) {
        _personalDataUpdateClick = [RACSubject subject];
    }
    return _personalDataUpdateClick;
}
@end

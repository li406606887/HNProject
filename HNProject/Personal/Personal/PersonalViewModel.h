//
//  PersonalViewModel.h
//  JYQHProject
//
//  Created by user on 2017/7/7.
//  Copyright © 2017年 zero. All rights reserved.
//

#import "BaseViewModel.h"

@interface PersonalViewModel : BaseViewModel
@property(nonatomic,strong)RACSubject *personalCellClick;
@property(nonatomic,strong)RACSubject *personalDataUpdateClick;
@end

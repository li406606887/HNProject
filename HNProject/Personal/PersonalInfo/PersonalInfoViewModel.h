//
//  PersonalInfoViewModel.h
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface PersonalInfoViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *getUserInfoCommand;
@property(nonatomic,strong) RACCommand *updateUserInfoCommand;
@property(nonatomic,strong) RACSubject *cellClickSubject;
@property(nonatomic,strong) RACSubject *refreshUISubject;

@end

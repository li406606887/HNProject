//
//  LoginViewModel.h
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface LoginViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *loginRequestCommand;
@property(nonatomic,strong) RACSubject *loginSuccessfulSubject;
@property(nonatomic,strong) RACSubject *forgetClickSubject;
@property(nonatomic,copy) NSString* phone;
@end

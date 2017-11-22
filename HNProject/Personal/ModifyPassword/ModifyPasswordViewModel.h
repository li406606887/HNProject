//
//  ModifyPasswordViewModel.h
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface ModifyPasswordViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *modifyPwdCommand;
@property(nonatomic,strong) RACSubject *refreshUISubject;
@end

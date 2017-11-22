//
//  ForgetViewModel.h
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface ForgetViewModel : BaseViewModel
@property(nonatomic,strong) RACSubject *verificationCodeSubject;
@property(nonatomic,strong) RACCommand *verificationCodeCommand;
@property(nonatomic,strong) RACCommand *sumbitDataCommand;
@property(nonatomic,strong) RACSubject *sumbitDataSubject;
@end

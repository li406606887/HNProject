//
//  RegisterViewModel.h
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface RegisterViewModel : BaseViewModel
@property(nonatomic,strong) RACSubject *userAgreementClickSubject;
@property(nonatomic,strong) RACSubject *registerSuccessfulClickSubject;
@property(nonatomic,strong) RACSubject *getVerificationCodeSubject;
@property(nonatomic,strong) RACCommand *getVerificationCodeCommand;
@property(nonatomic,strong) RACCommand *registerSuccessfulClickCommand;
@property(nonatomic,strong) NSDictionary *cityData;
@property(nonatomic,strong) NSArray *city;
@property(nonatomic,strong) NSArray *provinces;
@end

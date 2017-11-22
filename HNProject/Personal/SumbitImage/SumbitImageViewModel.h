//
//  SumbitImageViewModel.h
//  HNProject
//
//  Created by user on 2017/7/28.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface SumbitImageViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *sendSumbitCommand;
@property(nonatomic,strong) RACSubject *successfulSubject;
@property(nonatomic,strong) RACSubject *sendSumbitSubject;
@property(nonatomic,copy  ) NSString   *projectID ;
@end

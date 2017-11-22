//
//  MyBankViewModel.h
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyBankViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *getAllBankCommand;
@property(nonatomic,strong) RACCommand *deleteBankCommand;
@property(nonatomic,strong) RACSubject *refreshUISubject;
@property(nonatomic,strong) RACSubject *addBankCardClickSubject;
@property(nonatomic,strong) RACSubject *bankEditSubject;
@property(nonatomic,strong) NSMutableArray *bankArray;
@end

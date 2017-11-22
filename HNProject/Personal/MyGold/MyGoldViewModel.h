//
//  MyGoldViewModel.h
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"
#import "MyBankModel.h"

@interface MyGoldViewModel : BaseViewModel
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) RACCommand *myGoldCommand;
@property(nonatomic,strong) RACCommand *withdrawalCommand;
@property(nonatomic,strong) RACCommand *getBankCommand;
@property(nonatomic,strong) NSMutableArray *bankArray;
@property(nonatomic,strong) RACSubject *refreshUISubject;
@property(nonatomic,copy) NSString* cash;
@property(nonatomic,copy) NSString* bankId;
@end

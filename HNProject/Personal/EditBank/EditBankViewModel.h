//
//  EditBankViewModel.h
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface EditBankViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *updateBankInfoCommand;
@property(nonatomic,strong) RACCommand *addBankInfoCommand;
@property(nonatomic,strong) RACCommand *getBankArrayCommand;
@property(nonatomic,strong) RACSubject *updateDataSubject;
@property(nonatomic,strong) RACSubject *refreshUISubject;
@property(nonatomic,copy) NSString* cardID;
@property(nonatomic,strong) NSArray* bankArray;
@end

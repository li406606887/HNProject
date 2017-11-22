//
//  CommonProblemsViewModel.h
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface CommonProblemsViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *getQuestionDataCommand;
@property(nonatomic,strong) RACSubject *refreshUISubject;
@property(nonatomic,strong) RACSubject *callPhoneSubject;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) NSMutableArray *textHeightArray;
@end

//
//  IndividualitySignatureViewModel.h
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface IndividualitySignatureViewModel : BaseViewModel
@property(nonatomic,strong) RACSubject *sumbitClickSubject;
@property(nonatomic,strong) RACSubject *refreshUISubject;
@property(nonatomic,strong) RACCommand *saveSignatureCommand;
@end

//
//  MessageViewModel.h
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface MessageViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *getMessageCommand;
@property(nonatomic,strong) RACSubject *successfulSubject;
@property(nonatomic,strong) RACSubject *cellClickSubject;
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,assign) int page;
@end

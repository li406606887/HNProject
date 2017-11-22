//
//  HistoryShareViewModel.h
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface HistoryShareViewModel : BaseViewModel
@property(nonatomic,strong) NSMutableArray *dataArray;
@property(nonatomic,strong) RACCommand *getHistoryCommand;
@property(nonatomic,strong) RACSubject *refreshUISubject;
@property(nonatomic,strong) RACSubject *cellClickSubject;
@property(nonatomic,assign) int page;
@end

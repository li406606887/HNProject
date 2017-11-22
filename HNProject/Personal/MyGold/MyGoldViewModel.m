//
//  MyGoldViewModel.m
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyGoldViewModel.h"
#import "MyGoldModel.h"
#import "MyBankModel.h"

@implementation MyGoldViewModel
-(void)initialize{
    @weakify(self)
    [self.myGoldCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSMutableArray *array = [[NSMutableArray alloc] init];
        if (x) {
            for (NSDictionary *dic in x) {
                MyGoldModel *model = [MyGoldModel mj_objectWithKeyValues:dic];
                [array addObject:model];
            }
            self.dataArray = array; 
        }
        [self.refreshUISubject sendNext:nil];
    }];
    [self.getBankCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        if (x) {
            for (NSDictionary *dic in x) {
                MyBankModel *model = [MyBankModel mj_objectWithKeyValues:dic];
                [self.bankArray addObject:model];
            }
        }
    }];
    [self.withdrawalCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
         ;
        [HNUesrInformation getInformation].model.golds = [NSString stringWithFormat:@"%.2f",[[HNUesrInformation getInformation].model.golds floatValue] -[[x objectForKey:@"golds"] floatValue]];
        [self.myGoldCommand execute:nil];
    }];
}
//提现
-(RACCommand *)withdrawalCommand {
    if (!_withdrawalCommand) {
        _withdrawalCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error;
                    id data = [QHRequest postDataWithApi:@"cashs" withParam:input error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else {
                            NSString *message = [NSString stringWithFormat:@"%@",[data objectForKey:@"message"]];
                            showMassage(message)
                        }
                        [subscriber sendCompleted];
                    });
                });
                return nil;
            }];
        }];
    }
    return _withdrawalCommand;
}
//流水
-(RACCommand *)myGoldCommand {
    if (!_myGoldCommand) {
        _myGoldCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSString *api = [NSString stringWithFormat:@"users/%@/accounts",[HNUesrInformation getInformation].model.ID];
                   NSError *error;
                   id data = [QHRequest getDataWithApi:api withParam:nil error:&error];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (error == nil) {
                           [subscriber sendNext:data];
                       }else {
                           NSString *message = [NSString stringWithFormat:@"%@",[data objectForKey:@"message"]];
                           showMassage(message)
                       }
                       [subscriber sendCompleted];
                   });
               });
               return nil;
           }];
        }];
    }
    return _myGoldCommand;
}
//获取银行卡信息
-(RACCommand *)getBankCommand{
    if (!_getBankCommand) {
        _getBankCommand =[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               loading(@"")
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSString *api = [NSString stringWithFormat:@"users/%@/cards",[HNUesrInformation getInformation].model.ID];
                   NSError *error;
                   id data = [QHRequest getDataWithApi:api withParam:nil error:&error];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       hiddenHUD
                       if (error == nil) {
                           [subscriber sendNext:data];
                       }else {
                           NSString *message = [NSString stringWithFormat:@"%@",[data objectForKey:@"message"]];
                           showMassage(message)
                       }
                       [subscriber sendCompleted];
                   });
               });
               return nil;
           }];
        }];
    }
    return _getBankCommand;
}

-(RACSubject *)refreshUISubject{
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(NSMutableArray *)bankArray{
    if (!_bankArray) {
        _bankArray = [[NSMutableArray alloc] init];
    }
    return _bankArray;
}
-(NSString *)cash{
    if (!_cash) {
        _cash = @"";
    }
    return _cash;
}

@end

//
//  MyBankViewModel.m
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBankViewModel.h"
#import "MyBankModel.h"

@implementation MyBankViewModel


-(void)initialize{
    @weakify(self)
    [self.getAllBankCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (NSDictionary *dic in x) {
            MyBankModel *model  = [MyBankModel mj_objectWithKeyValues:dic];
            [array addObject:model];
        }
        self.bankArray = array;
        [self.refreshUISubject sendNext:@"pull"];
    }];
    [self.deleteBankCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        [self.getAllBankCommand execute:nil];
    }];
}

-(RACCommand *)getAllBankCommand {
    if (!_getAllBankCommand) {
        _getAllBankCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
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
    return _getAllBankCommand;
}
-(RACCommand *)deleteBankCommand {
    if (!_deleteBankCommand) {
        _deleteBankCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               loading(@"")
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSString *api = [NSString stringWithFormat:@"cards/%@",input];
                   NSError *error;
                   id data = [QHRequest deleteDataWithApi:api withParam:nil error:&error];
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
    return _deleteBankCommand;
}
-(RACSubject *)refreshUISubject{
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}

-(RACSubject *)addBankCardClickSubject{
    if (!_addBankCardClickSubject) {
        _addBankCardClickSubject = [RACSubject subject];
    }
    return _addBankCardClickSubject;
}
-(RACSubject *)bankEditSubject {
    if (!_bankEditSubject) {
        _bankEditSubject = [RACSubject subject];
    }
    return _bankEditSubject;
}

@end

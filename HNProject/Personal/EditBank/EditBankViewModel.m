//
//  EditBankViewModel.m
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "EditBankViewModel.h"

@implementation EditBankViewModel

-(void)initialize {
    @weakify(self)
    [self.updateBankInfoCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.refreshUISubject sendNext:nil];
    }];
    [self.addBankInfoCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.refreshUISubject sendNext:nil];
    }];
    [self.getBankArrayCommand.executionSignals.switchToLatest subscribeNext:^(NSArray * _Nullable array) {
       @strongify(self)
        self.bankArray = array;
    }];
}
-(RACCommand *)updateBankInfoCommand {
    if (!_updateBankInfoCommand) {
        _updateBankInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               loading(@"")
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSString *api = [NSString stringWithFormat:@"cards/%@",self.cardID];
                   NSError *error;
                   id data = [QHRequest putDataWithApi:api withParam:input error:&error];
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
    return _updateBankInfoCommand;
}

-(RACCommand *)getBankArrayCommand {
    if (!_getBankArrayCommand) {
        _getBankArrayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               loading(@"")
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSError *error;
                   id data = [QHRequest getDataWithApi:@"banks" withParam:nil error:&error];
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
    return _getBankArrayCommand;
}

-(RACCommand *)addBankInfoCommand {
    if (!_addBankInfoCommand) {
        _addBankInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *api = [NSString stringWithFormat:@"users/%@/cards",[HNUesrInformation getInformation].model.ID];
                    NSError *error;
                    id data = [QHRequest postDataWithApi:api withParam:input error:&error];
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
    return _addBankInfoCommand;
}

-(RACSubject *)refreshUISubject{
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}
-(RACSubject *)updateDataSubject{
    if (!_updateDataSubject) {
        _updateDataSubject = [RACSubject subject];
    }
    return _updateDataSubject;
}

@end

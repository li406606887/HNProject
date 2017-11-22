//
//  MyBuyViewModel.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MyBuyViewModel.h"

@implementation MyBuyViewModel

-(void)initialize{
    @weakify(self)
    [self.auditDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
     @strongify(self)
        if (self.auditPage == 1) {
            [self.auditArray removeAllObjects];
        }
        if (x) {
            for (NSDictionary *data in [x objectForKey:@"data"]) {
                MyBuyModel *model = [MyBuyModel mj_objectWithKeyValues:data];
                [self.auditArray addObject:model];
            }
            [self.auditRefreshUISubject sendNext:@(RefreshError)];
        }
    }];
    [self.modifyDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.modifyPage == 1) {
            [self.modifyArray removeAllObjects];
        }
        if (x) {
            for (NSDictionary *data in [x objectForKey:@"data"]) {
                MyBuyModel *model = [MyBuyModel mj_objectWithKeyValues:data];
                [self.modifyArray addObject:model];
            }
            [self.modifyRefreshUISubject sendNext:@(RefreshError)];
        }
    }];
    [self.sumbitDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.sumbitPage == 1) {
            [self.sumbitArray removeAllObjects];
        }
        if (x) {
            for (NSDictionary *data in [x objectForKey:@"data"]) {
                MyBuyModel *model = [MyBuyModel mj_objectWithKeyValues:data];
                [self.sumbitArray addObject:model];
            }
            [self.sumbitRefreshUISubject sendNext:@(RefreshError)];
        }
    }];
    [self.confirmDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.confirmPage == 1) {
            [self.confirmArray removeAllObjects];
        }
        if (x) {
            for (NSDictionary *data in [x objectForKey:@"data"]) {
                MyBuyModel *model = [MyBuyModel mj_objectWithKeyValues:data];
                [self.confirmArray addObject:model];
            }
            [self.confirmRefreshUISubject sendNext:@(RefreshError)];
        }
    }];
    [self.completedCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if (self.completedPage == 1) {
            [self.completedArray removeAllObjects];
        }
        @strongify(self)
        if (x) {
            for (NSDictionary *data in [x objectForKey:@"data"]) {
                MyBuyModel *model = [MyBuyModel mj_objectWithKeyValues:data];
                [self.completedArray addObject:model];
            }
            [self.completedRefreshUISubject sendNext:@(RefreshError)];
        }
    }];
}

-(RACCommand *)auditDataCommand{
    if (!_auditDataCommand) {
        _auditDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.auditPage = input==nil ? self.auditPage : 0;
                    self.auditPage ++;
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:[NSString stringWithFormat:@"%d",self.auditPage] forKey:@"page"];
                    NSError *error ;
                    NSString *api = [NSString stringWithFormat:@"users/%@/applys/status/1",[HNUesrInformation getInformation].model.ID];
                    id data = [QHRequest getDataWithApi:api withParam:nil error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
                            [self.auditRefreshUISubject sendNext:@(RefreshError)];
                            self.auditPage --;
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
    return _auditDataCommand;
}
-(RACCommand *)modifyDataCommand{
    if (!_modifyDataCommand) {
        _modifyDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.modifyPage = input==nil ? self.modifyPage : 0;
                    self.modifyPage ++;
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:[NSString stringWithFormat:@"%d",self.modifyPage] forKey:@"page"];
                    NSError *error ;
                    NSString *api = [NSString stringWithFormat:@"users/%@/applys/status/3",[HNUesrInformation getInformation].model.ID];
                    id data = [QHRequest getDataWithApi:api withParam:param error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
                            [self.modifyRefreshUISubject sendNext:@(RefreshError)];
                            self.modifyPage --;
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
    return _modifyDataCommand;
}
-(RACCommand *)sumbitDataCommand{
    if (!_sumbitDataCommand) {
        _sumbitDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.sumbitPage = input==nil ? self.sumbitPage : 0;
                    self.sumbitPage ++;
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:[NSString stringWithFormat:@"%d",self.sumbitPage] forKey:@"page"];
                    NSError *error ;
                    NSString *api = [NSString stringWithFormat:@"users/%@/applys/status/2",[HNUesrInformation getInformation].model.ID];
                    id data = [QHRequest getDataWithApi:api withParam:param error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
                            [self.sumbitRefreshUISubject sendNext:@(RefreshError)];
                            self.sumbitPage --;
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
    return _sumbitDataCommand;
}
-(RACCommand *)confirmDataCommand{
    if (!_confirmDataCommand) {
        _confirmDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.confirmPage = input==nil ? self.confirmPage : 0;
                    self.confirmPage ++;
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:[NSString stringWithFormat:@"%d",self.confirmPage] forKey:@"page"];
                    NSError *error ;
                    NSString *api = [NSString stringWithFormat:@"users/%@/applys/status/4",[HNUesrInformation getInformation].model.ID];
                    id data = [QHRequest getDataWithApi:api withParam:param error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
                            [self.confirmRefreshUISubject sendNext:@(RefreshError)];
                            self.confirmPage --;
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
    return _confirmDataCommand;
}
-(RACCommand *)completedCommand{
    if (!_completedCommand) {
        _completedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.completedPage = input==nil ? self.completedPage : 0;
                    self.completedPage ++;
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:[NSString stringWithFormat:@"%d",self.completedPage] forKey:@"page"];
                    NSError *error ;
                    NSString *api = [NSString stringWithFormat:@"users/%@/applys/status/5",[HNUesrInformation getInformation].model.ID];
                    id data = [QHRequest getDataWithApi:api withParam:param error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
                            [self.completedRefreshUISubject sendNext:@(RefreshError)];
                            self.completedPage --;
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
    return _completedCommand;
}

-(RACSubject *)completedRefreshUISubject{
    if (!_completedRefreshUISubject) {
        _completedRefreshUISubject = [RACSubject subject];
    }
    return _completedRefreshUISubject;
}
-(RACSubject *)segmentClickSubject{
    if (!_segmentClickSubject) {
        _segmentClickSubject = [RACSubject subject];
    }
    return _segmentClickSubject;
}

-(RACSubject *)auditCellClickSubJect{
    if (!_auditCellClickSubJect) {
        _auditCellClickSubJect = [RACSubject subject];
    }
    return _auditCellClickSubJect;
}

-(RACSubject *)modifyCellClickSubJect{
    if (!_modifyCellClickSubJect) {
        _modifyCellClickSubJect = [RACSubject subject];
    }
    return _modifyCellClickSubJect;
}
-(RACSubject *)sumbitCellClickSubJect{
    if (!_sumbitCellClickSubJect) {
        _sumbitCellClickSubJect = [RACSubject subject];
    }
    return _sumbitCellClickSubJect;
}
-(RACSubject *)confirmCellClickSubJect{
    if (!_confirmCellClickSubJect) {
        _confirmCellClickSubJect = [RACSubject subject];
    }
    return _confirmCellClickSubJect;
}
-(RACSubject *)completedCellClickSubJect{
    if (!_completedCellClickSubJect) {
        _completedCellClickSubJect = [RACSubject subject];
    }
    return _completedCellClickSubJect;
}

-(RACSubject *)auditRefreshUISubject{
    if (!_auditRefreshUISubject) {
        _auditRefreshUISubject = [RACSubject subject];
    }
    return _auditRefreshUISubject;
}
-(RACSubject *)modifyRefreshUISubject{
    if (!_modifyRefreshUISubject) {
        _modifyRefreshUISubject = [RACSubject subject];
    }
    return _modifyRefreshUISubject;
}
-(RACSubject *)sumbitRefreshUISubject{
    if (!_sumbitRefreshUISubject) {
        _sumbitRefreshUISubject = [RACSubject subject];
    }
    return _sumbitRefreshUISubject;
}
-(RACSubject *)confirmRefreshUISubject{
    if (!_confirmRefreshUISubject) {
        _confirmRefreshUISubject = [RACSubject subject];
    }
    return _confirmRefreshUISubject;
}

-(RACSubject *)sumbitEditClickSubJect {
    if (!_sumbitEditClickSubJect) {
        _sumbitEditClickSubJect = [RACSubject subject];
    }
    return _sumbitEditClickSubJect;
}
-(NSMutableArray *)completedArray{
    if (!_completedArray) {
        _completedArray = [[NSMutableArray alloc] init];
    }
    return _completedArray;
}
-(NSMutableArray *)auditArray{
    if (!_auditArray) {
        _auditArray = [[NSMutableArray alloc] init];
    }
    return _auditArray;
}
-(NSMutableArray *)modifyArray{
    if (!_modifyArray) {
        _modifyArray = [[NSMutableArray alloc] init];
    }
    return _modifyArray;
}
-(NSMutableArray *)sumbitArray{
    if (!_sumbitArray) {
        _sumbitArray = [[NSMutableArray alloc] init];
    }
    return _sumbitArray;
}
-(NSMutableArray *)confirmArray{
    if (!_confirmArray) {
        _confirmArray = [[NSMutableArray alloc] init];
    }
    return _confirmArray;
}
-(int)auditPage{
    if (!_auditPage) {
        _auditPage = 0;
    }
    return _auditPage;
}
-(int)modifyPage{
    if (!_modifyPage) {
        _modifyPage = 0;
    }
    return _modifyPage;
}
-(int)sumbitPage{
    if (!_sumbitPage) {
        _sumbitPage = 0;
    }
    return _sumbitPage;
}
-(int)confirmPage{
    if (!_confirmPage) {
        _confirmPage = 0;
    }
    return _confirmPage;
}
-(int)completedPage{
    if (!_completedPage) {
        _completedPage = 0;
    }
    return _completedPage;
}
@end

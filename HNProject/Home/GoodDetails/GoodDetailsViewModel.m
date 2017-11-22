//
//  GoodDetailsViewModel.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "GoodDetailsViewModel.h"
#import "GoodDetailsModel.h"
#import "MyBuyModel.h"

@implementation GoodDetailsViewModel

-(void)initialize{
    @weakify(self)
    //获取项目详情
    [self.getGoodDetailsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.model = [GoodDetailsModel mj_objectWithKeyValues:x];
        if (self.model.tao_1.length>2) {
            [self.taoPwdArray addObject:self.model.tao_1];
        }
        if(self.model.tao_2.length>2){
            [self.taoPwdArray addObject:self.model.tao_2];
        }
        [self.refreshUISubject sendNext:self.model];
    }];
    //申请项目
    [self.applyProjectCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.applySuccessfulSubject sendNext:nil];
    }];
    //获取申请项目详情
    [self.getApplysCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        self.myBuyModel = [MyBuyModel mj_objectWithKeyValues:x];
        self.model = [GoodDetailsModel mj_objectWithKeyValues:[x objectForKey:@"project"]];
        [self.refreshUISubject sendNext:self.model];
        [self.refreshStateUISubject sendNext:self.myBuyModel];
    }];
    [self.isApplyProjectCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        NSString *status = [NSString stringWithFormat:@"%@",[x objectForKey:@"status"]];
        if ([status isEqualToString:@"1"]) {
            [self.sumbitUISubject sendNext:nil];
        }else{
            showMassage(@"没有申请资格");
        }
    }];
    [self.reportClickCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
//        @strongify(self)
        showMassage(@"举报成功");
    }];
}


-(RACCommand *)getGoodDetailsCommand{
    if (!_getGoodDetailsCommand) {
        _getGoodDetailsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSString *api = [NSString stringWithFormat:@"projects/%@",input];
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
    return _getGoodDetailsCommand;
}

-(RACCommand *)getApplysCommand{
    if (!_getApplysCommand) {
        _getApplysCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *api = [NSString stringWithFormat:@"applys/%@",input];
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
    return _getApplysCommand;
}

-(RACCommand *)applyProjectCommand{
    if (!_applyProjectCommand) {
        _applyProjectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               loading(@"")
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSError *error;
                   id data = [QHRequest postDataWithApi:@"applys" withParam:input error:&error];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       hiddenHUD;
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
    
    return _applyProjectCommand;
}
-(RACCommand *)isApplyProjectCommand {
    if (!_isApplyProjectCommand) {
        _isApplyProjectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               loading(@"");
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSString *api = [NSString stringWithFormat:@"users/%@/can_apply",[HNUesrInformation getInformation].model.ID];
                   NSError *error;
                   id data = [QHRequest getDataWithApi:api withParam:nil error:&error];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       hiddenHUD;
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
    return _isApplyProjectCommand;
}

-(RACCommand *)reportClickCommand {
    if (!_reportClickCommand) {
        _reportClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
                    [param setObject:self.model.merchant_id forKey:@"merchant_id"];
                    [param setObject:self.reason forKey:@"reason"];
                    NSError *error;
                    id data = [QHRequest postDataWithApi:@"reports" withParam:param error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hiddenHUD;
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
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
    return _reportClickCommand;
}
-(RACSubject *)refreshStateUISubject{
    if (!_refreshStateUISubject) {
        _refreshStateUISubject = [RACSubject subject];
    }
    return _refreshStateUISubject;
}
-(RACSubject *)applySuccessfulSubject{
    if (!_applySuccessfulSubject) {
        _applySuccessfulSubject = [RACSubject subject];
    }
    return _applySuccessfulSubject;
}
-(RACSubject *)sumbitUISubject {
    if (!_sumbitUISubject) {
        _sumbitUISubject = [RACSubject subject];
    }
    return _sumbitUISubject;
}
-(RACSubject *)refreshUISubject{
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}
-(RACSubject *)scrollContentSizeSubject{
    if (!_scrollContentSizeSubject) {
        _scrollContentSizeSubject = [RACSubject subject];
    }
    return _scrollContentSizeSubject;
}
-(RACSubject *)tableContentSizeSubject{
    if (!_tableContentSizeSubject) {
        _tableContentSizeSubject = [RACSubject subject];
    }
    return _tableContentSizeSubject;
}
-(RACSubject *)sumbitPhotoSubject{
    if (!_sumbitPhotoSubject) {
        _sumbitPhotoSubject = [RACSubject subject];
    }
    return _sumbitPhotoSubject;
}
-(NSMutableArray *)taoPwdArray {
    if (!_taoPwdArray) {
        _taoPwdArray = [[NSMutableArray alloc] init];
    }
    return _taoPwdArray;
}
@end

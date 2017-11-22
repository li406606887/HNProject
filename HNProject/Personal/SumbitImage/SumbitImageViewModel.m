//
//  SumbitImageViewModel.m
//  HNProject
//
//  Created by user on 2017/7/28.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "SumbitImageViewModel.h"

@implementation SumbitImageViewModel

-(void)initialize{
    @weakify(self)
    [self.sendSumbitCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        [self.successfulSubject sendNext:nil];
    }];
}

//提交状态
-(RACCommand *)sendSumbitCommand {
    if (!_sendSumbitCommand) {
        _sendSumbitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *api = [NSString stringWithFormat:@"submitted/%@",self.projectID];
                    NSError *error;
                    id data = [QHRequest putDataWithApi:api withParam:input error:&error];
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
    return _sendSumbitCommand;
}
-(RACSubject *)sendSumbitSubject{
    if (!_sendSumbitSubject) {
        _sendSumbitSubject = [RACSubject subject];
    }
    return _sendSumbitSubject;
}
-(RACSubject *)successfulSubject {
    if (!_successfulSubject) {
        _successfulSubject = [RACSubject subject];
    }
    return _successfulSubject;
}
@end

//
//  ForgetViewModel.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ForgetViewModel.h"

@implementation ForgetViewModel

-(void)initialize{
    [self.verificationCodeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [self.verificationCodeSubject sendNext:nil];
    }];
    [self.sumbitDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        [self.sumbitDataSubject sendNext:nil];
    }];
}

-(RACSubject *)verificationCodeSubject{
    if (!_verificationCodeSubject) {
        _verificationCodeSubject = [RACSubject subject];
    }
    return _verificationCodeSubject;
}
-(RACSubject *)sumbitDataSubject{
    if (!_sumbitDataSubject) {
        _sumbitDataSubject = [RACSubject subject];
    }
    return _sumbitDataSubject;
}

-(RACCommand *)verificationCodeCommand{
    if (!_verificationCodeCommand) {
        _verificationCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error ;
                    id data = [QHRequest postDataWithApi:@"sms" withParam:input error:&error];
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
    return _verificationCodeCommand;
}
-(RACCommand *)sumbitDataCommand{
    if (!_sumbitDataCommand) {
        _sumbitDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error ;
                    id data = [QHRequest postDataWithApi:@"password" withParam:input error:&error];
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
    return _sumbitDataCommand;
}
@end

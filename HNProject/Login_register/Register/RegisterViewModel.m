//
//  RegisterViewModel.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "RegisterViewModel.h"

@implementation RegisterViewModel

-(void)initialize{
    @weakify(self)
    [self.getVerificationCodeCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.getVerificationCodeSubject sendNext:nil];
    }];
    [self.registerSuccessfulClickCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.registerSuccessfulClickSubject sendNext:nil];
    }];
}

-(RACCommand *)getVerificationCodeCommand{
    if (!_getVerificationCodeCommand) {
        _getVerificationCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
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
    return _getVerificationCodeCommand;
}

-(RACCommand *)registerSuccessfulClickCommand{
    if (!_registerSuccessfulClickCommand) {
        _registerSuccessfulClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input){
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error ;
                    id data = [QHRequest postDataWithApi:@"users" withParam:input error:&error];
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
    return _registerSuccessfulClickCommand;
}

-(RACSubject *)userAgreementClickSubject {
    if (!_userAgreementClickSubject) {
        _userAgreementClickSubject = [RACSubject subject];
    }
    return _userAgreementClickSubject;
}

-(RACSubject *)registerSuccessfulClickSubject{
    if (!_registerSuccessfulClickSubject) {
        _registerSuccessfulClickSubject = [RACSubject subject];
    }
    return _registerSuccessfulClickSubject;
}

-(RACSubject *)getVerificationCodeSubject{
    if (!_getVerificationCodeSubject) {
        _getVerificationCodeSubject = [RACSubject subject];
    }
    return _getVerificationCodeSubject;
}

- (NSDictionary*)cityData {
    if (_cityData == nil) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"cityData" ofType:@"plist"];
        _cityData = [NSDictionary dictionaryWithContentsOfFile:path];
    }
    
    return _cityData;
}
- (NSArray*)provinces
{
    if (_provinces == nil) {
        
        //将省份保存到数组中  但是字典保存的是无序的 所以读出来的省份也是无序的
        _provinces = [self.cityData allKeys];
    }
    
    return _provinces;
}
@end

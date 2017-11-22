//
//  LoginViewModel.m
//  HNProject
//
//  Created by user on 2017/7/15.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "LoginViewModel.h"
#import "JPUSHService.h"

@implementation LoginViewModel

-(void)initialize{
    @weakify(self)
    [self.loginRequestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSDictionary *data = (NSDictionary *)x;
        if (data==nil) return;
        NSString * token = [NSString stringWithFormat:@"%@",data[@"token"]];
        [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
        NSString *phone = [NSString stringWithFormat:@"%@",self.phone];
        [[NSUserDefaults standardUserDefaults] setObject:phone forKey:@"phone"];
        dispatch_time_t time = dispatch_time(DISPATCH_TIME_NOW, 4*NSEC_PER_SEC);
        dispatch_after(time, dispatch_get_main_queue(), ^{
            if (phone.length==11) {
                [JPUSHService setTags:nil alias:phone fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias){
                    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
                }];
            }
        });
        
        NSString *userInfo = [self dictionaryToJson:[data objectForKey:@"user"]];
        [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"token"] forKey:@"token"];
        [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"expire"] forKey:@"expire"];
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"user"];
        
        HNUserModel *model = [HNUserModel mj_objectWithKeyValues:[data objectForKey:@"user"]];
        [HNUesrInformation getInformation].model = model;
        [[HNUesrInformation getInformation] login];
        [self.loginSuccessfulSubject sendNext:nil];
    }];
}

-(RACSubject *)forgetClickSubject {
    if (!_forgetClickSubject) {
        _forgetClickSubject = [RACSubject subject];
    }
    return _forgetClickSubject;
}

-(RACCommand *)loginRequestCommand{
    if (!_loginRequestCommand) {
        _loginRequestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error ;
                    id data = [QHRequest postDataWithApi:@"login" withParam:input error:&error];
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
    return _loginRequestCommand;
}

-(RACSubject *)loginSuccessfulSubject{
    if (!_loginSuccessfulSubject) {
        _loginSuccessfulSubject = [RACSubject subject];
    }
    return _loginSuccessfulSubject;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
//    showMassage(@"success")
}
@end

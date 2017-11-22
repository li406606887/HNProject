//
//  PersonalInfoViewModel.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PersonalInfoViewModel.h"

@implementation PersonalInfoViewModel
-(void)initialize{
    @weakify(self)
    [self.getUserInfoCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self updateUserInformation:x];
        HNUserModel *model = [HNUserModel mj_objectWithKeyValues:x];
        [HNUesrInformation getInformation].model = model;
        [self.refreshUISubject sendNext:x];
        
    }];
    [self.updateUserInfoCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        [self updateUserInformation:x];
        HNUserModel *model = [HNUserModel mj_objectWithKeyValues:x];
        [HNUesrInformation getInformation].model = model;
        [self.refreshUISubject sendNext:x];
    }];
}
-(RACCommand *)updateUserInfoCommand{
    if (!_updateUserInfoCommand) {
        _updateUserInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error ;
                    NSString *api = [NSString stringWithFormat:@"users/%@",[HNUesrInformation getInformation].model.ID];
                    id data = [QHRequest putDataWithApi:api withParam:input error:&error];
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
    return _updateUserInfoCommand;
}
-(RACCommand *)getUserInfoCommand{
    if (!_getUserInfoCommand) {
        _getUserInfoCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSError *error ;
                   NSString *api = [NSString stringWithFormat:@"users/%@",[HNUesrInformation getInformation].model.ID];
                   id data = [QHRequest getDataWithApi:api withParam:nil error:&error];
                   dispatch_async(dispatch_get_main_queue(), ^{
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
    return _getUserInfoCommand;
}
-(RACSubject *)cellClickSubject{
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}
-(RACSubject *)refreshUISubject{
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
-(void)updateUserInformation:(NSString *)data{
    NSString *userInfo = [self dictionaryToJson:data];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:@"user"];

}
@end

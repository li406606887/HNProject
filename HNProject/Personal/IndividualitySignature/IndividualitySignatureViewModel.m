//
//  IndividualitySignatureViewModel.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "IndividualitySignatureViewModel.h"

@implementation IndividualitySignatureViewModel

-(void)initialize{
    @weakify(self)
    [self.saveSignatureCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        HNUserModel *model = [HNUserModel mj_objectWithKeyValues:x];
        [HNUesrInformation getInformation].model = model;
        [self.refreshUISubject sendNext:nil];
    }];
}

-(RACSubject *)refreshUISubject{
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}
-(RACSubject *)sumbitClickSubject{
    if (!_sumbitClickSubject) {
        _sumbitClickSubject = [RACSubject subject];
    }
    return _sumbitClickSubject;
}
-(RACCommand *)saveSignatureCommand{
    if (!_saveSignatureCommand) {
        _saveSignatureCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *api = [NSString stringWithFormat:@"users/%@",[HNUesrInformation getInformation].model.ID];
                    NSError *error ;
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
    return _saveSignatureCommand;
}
@end

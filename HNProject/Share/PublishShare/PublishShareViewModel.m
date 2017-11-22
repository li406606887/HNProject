//
//  PublishShareViewModel.m
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "PublishShareViewModel.h"

@implementation PublishShareViewModel

-(void)initialize {
    @weakify(self)
    [self.publishShareCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.shareCompleteSubject sendNext:nil];
    }];
}

-(RACCommand *)publishShareCommand{
    if (!_publishShareCommand) {
        _publishShareCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error;
                    id data = [QHRequest postDataWithApi:@"shares" withParam:input error:&error];
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
    return _publishShareCommand;
}
-(RACSubject *)shareCompleteSubject{
    if (!_shareCompleteSubject) {
        _shareCompleteSubject = [RACSubject subject];
    }
    return _shareCompleteSubject;
}

-(RACSubject *)publishShareSubject{
    if (!_publishShareSubject) {
        _publishShareSubject = [RACSubject subject];
    }
    return _publishShareSubject;
}
-(RACSubject *)readPromptSubject{
    if (!_readPromptSubject) {
        _readPromptSubject = [RACSubject subject];
    }
    return _readPromptSubject;
}
@end

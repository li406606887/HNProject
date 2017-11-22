
//
//  MessageViewModel.m
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "MessageViewModel.h"
#import "MessageModel.h"

@implementation MessageViewModel
-(void)initialize{
    @weakify(self)
    [self.getMessageCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        @strongify(self)
        for (NSDictionary *data in [x objectForKey:@"data"]) {
            MessageModel* message= [MessageModel mj_objectWithKeyValues:data];
            [self.dataArray addObject:message];
        }
        [self.successfulSubject sendNext:@(RefreshError)];
    }];
}
-(RACCommand *)getMessageCommand{
    if (!_getMessageCommand) {
        _getMessageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.page ++;
                    self.page = input==nil ? self.page : 0;
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
                    NSString *api = [NSString stringWithFormat:@"users/%@/messages",[HNUesrInformation getInformation].model.ID];
                    NSError *error;
                    id data = [QHRequest getDataWithApi:api withParam:param error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else {
                            NSString *message = [NSString stringWithFormat:@"%@",[data objectForKey:@"message"]];
                            showMassage(message)
                            [self.successfulSubject sendNext:@(RefreshError)];
                            self.page --;
                        }
                        [subscriber sendCompleted];
                    });
                });
                return nil;
            }];
        }];
    }
    return _getMessageCommand;
}

-(RACSubject *)cellClickSubject {
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}

-(RACSubject *)successfulSubject {
    if (!_successfulSubject) {
        _successfulSubject = [RACSubject subject];
    }
    return _successfulSubject;
}
-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
-(int)page {
    if (!_page) {
        _page = 0;
    }
    return _page;
}
@end

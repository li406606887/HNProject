//
//  InviteFriendsViewModel.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "InviteFriendsViewModel.h"
#import "InviteFriendsModel.h"

@implementation InviteFriendsViewModel
-(void)initialize{
    @weakify(self)
    [self.getInvitePeopleCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            self.peopleModel = [InvitePeopleModel mj_objectWithKeyValues:x];
        }
        [self.refreshUISuject sendNext:@"1"];
    }];
    [self.getInviteFrendsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        if (x) {
            for (NSDictionary *dic in x) {
                InviteFriendsModel *model = [InviteFriendsModel mj_objectWithKeyValues:dic];
                [self.dataArray addObject:model];
            }
            [self.refreshUISuject sendNext:@"2"];
        }
    }];
}

-(RACCommand *)getInviteFrendsCommand {
    if (!_getInviteFrendsCommand) {
        _getInviteFrendsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSString *api = [NSString stringWithFormat:@"users/%@/inviters",[HNUesrInformation getInformation].model.ID];
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
    return _getInviteFrendsCommand;
}
-(RACCommand *)getInvitePeopleCommand{
    if (!_getInvitePeopleCommand) {
        _getInvitePeopleCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *api = [NSString stringWithFormat:@"users/%@/inviter",[HNUesrInformation getInformation].model.ID];
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
    return _getInvitePeopleCommand;
}

-(RACSubject *)refreshUISuject{
    if (!_refreshUISuject) {
        _refreshUISuject = [RACSubject subject];
    }
    return _refreshUISuject;
}

-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}
@end

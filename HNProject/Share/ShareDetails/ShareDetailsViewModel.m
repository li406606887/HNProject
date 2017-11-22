//
//  ShareDetailsViewModel.m
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareDetailsViewModel.h"
#import "ShareDetailsModel.h"

@implementation ShareDetailsViewModel

-(void)initialize{
    @weakify(self)
    [self.shareDetailsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (x) {
            ShareDetailsModel *model = [ShareDetailsModel mj_objectWithKeyValues:x];
            [self.refreshHeadUISubject sendNext:model];
        }
    }];
    [self.getShareCommentsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        if (self.page ==0) {
            [self.shareDetailsCellArray removeAllObjects];
        }
        for (NSDictionary *dic in [x objectForKey:@"data"]) {
            ShareCellDetailsModel *model = [ShareCellDetailsModel mj_objectWithKeyValues:dic];
            [self.shareDetailsCellArray addObject:model];
        }
        [self.refreshCellUISubject sendNext:@(RefreshError)];

    }];
    
    [self.rewardClickCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSString *count = [HNUesrInformation getInformation].model.golds ;
        int result = [count intValue] - [self.rewardsCount intValue];
        [HNUesrInformation getInformation].model.golds = [NSString stringWithFormat:@"%d",result];
        [self.rewardSuccessfulSubject sendNext:[x objectForKey:@"rewards"]];
    }];
    
    [self.sendCommentsCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        [self.getShareCommentsCommand execute:@"0"];
    }];
    [self.praiseCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        self.praiseCount = [x objectForKey:@"zan"];
        [self.praiseRefreshUISubject sendNext:@"1"];
    }];
    [self.cancelpraiseCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [self.praiseRefreshUISubject sendNext:@"0"];
    }];
    [self.isPraiseCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        if ([[x objectForKey:@"status"] intValue]==1) {
            [self.praiseRefreshUISubject sendNext:@"2"];//选中
        }else{
            [self.praiseRefreshUISubject sendNext:@"3"];//未选中
        }
        
    }];
    
    [self.commentsCancelPraiseCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        ShareCellDetailsModel *model= self.shareDetailsCellArray[self.oldIndex];
        NSString *commentID = [NSString stringWithFormat:@"%@",model.ID];
        NSString *commentsState = [[HNUesrInformation getInformation].praiseDic objectForKey:commentID];
        model.zan =[NSString stringWithFormat:@"%d",[model.zan intValue] -1]; 
        if (commentsState!=nil) {
            [[HNUesrInformation getInformation].praiseDic removeObjectForKey:model.ID];
        }
        [self.refreshCellSubject sendNext:model];
    }];
    [self.commentsPraiseCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
       @strongify(self)
        ShareCellDetailsModel *model = [ShareCellDetailsModel mj_objectWithKeyValues:x];
        NSString *commentID = [NSString stringWithFormat:@"%@",model.ID];
        [[HNUesrInformation getInformation].praiseDic setObject:@"1" forKey:commentID];
        [self.refreshCellSubject sendNext:model];
    }];
    [self.getCommentsListCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        if ([HNUesrInformation getInformation].praiseDic != nil ) {
            [[HNUesrInformation getInformation].praiseDic removeAllObjects];
        }
        for (NSString *string in x) {
            NSString *comments = [NSString stringWithFormat:@"%@",string];
            [[HNUesrInformation getInformation].praiseDic setObject:@"1" forKey:comments];
        }
        
    }];
}

//获取评论
-(RACCommand *)getShareCommentsCommand{
    if (!_getShareCommentsCommand) {
        _getShareCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSubject createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   self.page = input==nil ? self.page : 0;
                   self.page ++;
                   NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                   [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
                   NSString *api = [NSString stringWithFormat:@"shares/%@/comments/",self.detailsID];
                   NSError *error;
                   id data = [QHRequest getDataWithApi:api withParam:param error:&error];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       hiddenHUD;
                       if (error == nil) {
                           [subscriber sendNext:data];
                       }else{
                           [self.refreshCellUISubject sendNext:@(RefreshError)];
                           self.page --;
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
    return _getShareCommentsCommand;
}
//评论
-(RACCommand *)sendCommentsCommand{
    if (!_sendCommentsCommand) {
        _sendCommentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *api = [NSString stringWithFormat:@"shares/%@/comments",self.detailsID];
                    NSError *error;
                    id data = [QHRequest postDataWithApi:api withParam:input error:&error];
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
    return _sendCommentsCommand;
}
//打赏
-(RACCommand *)rewardClickCommand{
    if (!_rewardClickCommand) {
        _rewardClickCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"")
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *api = [NSString stringWithFormat:@"shares/%@/rewards",self.detailsID];
                    NSError *error;
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
    return _rewardClickCommand;
}
-(RACCommand *)praiseCommand {
    if (!_praiseCommand) {
        _praiseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                   [param setObject:self.detailsID forKey:@"share_id"];
                   [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
                   NSError *error;
                   id data = [QHRequest postDataWithApi:@"shares/zan" withParam:param error:&error];
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
    return _praiseCommand;
}
-(RACCommand *)cancelpraiseCommand {
    if (!_cancelpraiseCommand) {
        _cancelpraiseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:self.detailsID forKey:@"share_id"];
                    [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
                    NSError *error;
                    id data = [QHRequest postDataWithApi:@"shares/cancel_zan" withParam:param error:&error];
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
    return _cancelpraiseCommand;
}
//获取头部详情信息
-(RACCommand *)shareDetailsCommand{
    if (!_shareDetailsCommand) {
        _shareDetailsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSString *api = [NSString stringWithFormat:@"shares/%@",self.detailsID];
                    NSError *error;
                    id data = [QHRequest getDataWithApi:api withParam:nil error:&error];
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
    return _shareDetailsCommand;
}
-(RACCommand *)isPraiseCommand {
    if (!_isPraiseCommand) {
        _isPraiseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:self.detailsID forKey:@"share_id"];
                    [param setObject:[HNUesrInformation getInformation].model.ID forKey:@"user_id"];
                    NSError *error;
                    id data = [QHRequest postDataWithApi:@"shares/is_zan" withParam:param error:&error];
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
    return _isPraiseCommand;
}

-(RACCommand *)commentsPraiseCommand {
    if (!_commentsPraiseCommand) {
        _commentsPraiseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error;
                    id data = [QHRequest postDataWithApi:@"comments/zan" withParam:input error:&error];
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
    return _commentsPraiseCommand;
}

-(RACCommand *)commentsCancelPraiseCommand {
    if (!_commentsCancelPraiseCommand) {
        _commentsCancelPraiseCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error;
                    id data = [QHRequest postDataWithApi:@"comments/cancel_zan" withParam:input error:&error];
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
    return _commentsCancelPraiseCommand;
}

-(RACCommand *)getCommentsListCommand {
    if (!_getCommentsListCommand) {
        _getCommentsListCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error;
                    NSString *api = [NSString stringWithFormat:@"users/%@/comments/zan",[HNUesrInformation getInformation].model.ID];
                    id data = [QHRequest getDataWithApi:api withParam:nil error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }
                        [subscriber sendCompleted];
                    });
                });
                return nil;
            }];
        }];
    }
    return _getCommentsListCommand;
}

-(RACSubject *)refreshCellUISubject{
    if (!_refreshCellUISubject) {
        _refreshCellUISubject = [RACSubject subject];
    }
    return _refreshCellUISubject;
}
-(RACSubject *)refreshHeadUISubject{
    if (!_refreshHeadUISubject) {
        _refreshHeadUISubject = [RACSubject subject];
    }
    return _refreshHeadUISubject;
}
-(void)setDetailsID:(NSString *)detailsID{
    _detailsID = detailsID;
}

-(RACSubject *)editorialCommentsSubject{
    if (!_editorialCommentsSubject) {
        _editorialCommentsSubject = [RACSubject subject];
    }
    return _editorialCommentsSubject;
}
-(RACSubject *)rewardClickSubject{
    if (!_rewardClickSubject) {
        _rewardClickSubject = [RACSubject subject];
    }
    return _rewardClickSubject;
}
-(RACSubject *)praiseRefreshUISubject {
    if (!_praiseRefreshUISubject) {
        _praiseRefreshUISubject = [RACSubject subject];
    }
    return _praiseRefreshUISubject;
}
-(RACSubject *)rewardSuccessfulSubject{
    if (!_rewardSuccessfulSubject) {
        _rewardSuccessfulSubject = [RACSubject subject];
    }
    return _rewardSuccessfulSubject;
}
-(RACSubject *)lookBigPhotoSubject {
    if (!_lookBigPhotoSubject) {
        _lookBigPhotoSubject = [RACSubject subject];
    }
    return _lookBigPhotoSubject;
}

-(RACSubject *)refreshCellSubject {
    if (!_refreshCellSubject) {
        _refreshCellSubject = [RACSubject subject];
    }
    return _refreshCellSubject;
}
-(NSMutableArray *)shareDetailsCellArray {
    if (!_shareDetailsCellArray) {
        _shareDetailsCellArray = [[NSMutableArray alloc] init];
    }
    return _shareDetailsCellArray;
}
-(int)page {
    if (!_page) {
        _page = 0;
    }
    return _page;
}

@end

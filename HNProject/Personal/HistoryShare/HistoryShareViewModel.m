//
//  HistoryShareViewModel.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HistoryShareViewModel.h"
#import "HistoryShareModel.h"

@implementation HistoryShareViewModel
-(void)initialize{
    @weakify(self)
    [self.getHistoryCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.page == 1) {
            [self.dataArray removeAllObjects];
        }
        NSArray *array = [x objectForKey:@"data"];
        if (array) {
            for (NSDictionary *data in array) {
                HistoryShareModel *model = [HistoryShareModel mj_objectWithKeyValues:data];
                [self.dataArray addObject:model];
            }
        }
        [self.refreshUISubject sendNext:@(RefreshError)];
    }];
    
    
}
-(RACCommand *)getHistoryCommand {
    if (!_getHistoryCommand) {
        _getHistoryCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
           return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
               dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                   self.page = input==nil ? self.page : 0;
                   self.page++;
                   NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                   [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
                   NSString *api = [NSString stringWithFormat:@"users/%@/shares",[HNUesrInformation getInformation].model.ID];
                   NSError *error;
                   id data = [QHRequest getDataWithApi:api withParam:param error:&error];
                   dispatch_async(dispatch_get_main_queue(), ^{
                       if (error == nil) {
                           [subscriber sendNext:data];
                       }else {
                           [self.refreshUISubject sendNext:@(RefreshError)];
                           self.page--;
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
    return _getHistoryCommand;
}
-(RACSubject *)refreshUISubject {
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}
-(RACSubject *)cellClickSubject{
    if (!_cellClickSubject) {
        _cellClickSubject = [RACSubject subject];
    }
    return _cellClickSubject;
}
-(NSMutableArray *)dataArray {
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

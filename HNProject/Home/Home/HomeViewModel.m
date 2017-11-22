//
//  HomeViewModel.m
//  HNProject
//
//  Created by user on 2017/7/13.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HomeViewModel.h"
#import "HomeCollectionModel.h"

@implementation HomeViewModel

-(void)initialize{
    @weakify(self)
    [self.getBannerDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
     @strongify(self)
        NSArray *array = x;
        [self.refreshBannerDataSubject sendNext:array];
        [self.refreshCollectionSubject sendNext:@(RefreshError)];
    }];
    [self.getCollectionDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        for (NSDictionary *dic in [x objectForKey:@"data"]) {
            HomeCollectionModel *model = [HomeCollectionModel mj_objectWithKeyValues:dic];
            [self.collectionArray addObject:model];
        }
        [self.refreshCollectionSubject sendNext:@(RefreshError)];
    }];
   
}

-(RACCommand *)getBannerDataCommand{
    if (!_getBannerDataCommand) {
        _getBannerDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error;
                    id data = [QHRequest getDataWithApi:@"banner/1" withParam:input error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
                            NSString *message = [NSString stringWithFormat:@"%@",[data objectForKey:@"message"]];
                            showMassage(message)
                            [self.refreshCollectionSubject sendNext:@(RefreshError)];
                        }
                        [subscriber sendCompleted];
                    });
                });
                return nil;
            }];
        }];
    }
    return _getBannerDataCommand;
}

-(RACCommand *)getCollectionDataCommand{
    if (!_getCollectionDataCommand) {
        _getCollectionDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.page++;
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
                    NSString *api_param = [NSString stringWithFormat:@"section/1"];
                    NSError *error;
                    id data = [QHRequest getDataWithApi:api_param withParam:param error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
                            NSString *message = [NSString stringWithFormat:@"%@",[data objectForKey:@"message"]];
                            showMassage(message)
                            [self.refreshCollectionSubject sendNext:@(RefreshError)];
                            self.page--;
                        }
                        [subscriber sendCompleted];
                    });
                });
                return nil;
            }];
        }];
    }
    return _getCollectionDataCommand;
}


-(NSMutableArray *)collectionArray {
    if (!_collectionArray) {
        _collectionArray = [[NSMutableArray alloc] init];
    }
    return _collectionArray;
}
-(NSMutableArray *)scrollArray {
    if (!_scrollArray) {
        _scrollArray = [[NSMutableArray alloc] init];
    }
    return _scrollArray;
}
-(RACSubject *)homeCellClickSubject{
    if (!_homeCellClickSubject) {
        _homeCellClickSubject = [RACSubject subject];
    }
    return _homeCellClickSubject;
}

-(RACSubject *)refreshBannerDataSubject{
    if (!_refreshBannerDataSubject) {
        _refreshBannerDataSubject = [RACSubject subject];
    }
    return _refreshBannerDataSubject;
}
-(RACSubject *)refreshCollectionSubject{
    if (!_refreshCollectionSubject) {
        _refreshCollectionSubject = [RACSubject subject];
    }
    return _refreshCollectionSubject;
}
-(int)page {
    if (!_page) {
        _page = 0;
    }
    return _page;
}
@end

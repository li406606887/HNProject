//
//  GrabCouponViewModel.m
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "GrabCouponViewModel.h"
#import "HomeCollectionModel.h"

@implementation GrabCouponViewModel

-(void)initialize{
    @weakify(self)
    [self.getCollectionDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        for (NSDictionary *dic in [x objectForKey:@"data"]) {
            HomeCollectionModel *model = [HomeCollectionModel mj_objectWithKeyValues:dic];
            [self.collectionArray addObject:model];
        }
        [self.refreshUISubject sendNext:@(RefreshError)];
    }];
    [self.getBannerDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        NSArray *array = x;
        [self.refreshBannerDataSubject sendNext:array];
        [self.refreshUISubject sendNext:@(RefreshError)];
    }];

}

-(RACCommand *)getCollectionDataCommand{
    if (!_getCollectionDataCommand) {
        _getCollectionDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    self.page++;
                    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                    [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
                    NSString *api_param = [NSString stringWithFormat:@"section/2"];
                    NSError *error;
                    id data = [QHRequest getDataWithApi:api_param withParam:param error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        hiddenHUD;
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
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
    return _getCollectionDataCommand;
}
-(RACCommand *)getBannerDataCommand{
    if (!_getBannerDataCommand) {
        _getBannerDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    
                    NSError *error;
                    id data = [QHRequest getDataWithApi:@"banner/2" withParam:input error:&error];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error == nil) {
                            [subscriber sendNext:data];
                        }else{
                            [self.refreshUISubject sendNext:@(RefreshError)];
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
    return _getBannerDataCommand;
}

-(RACSubject *)refreshBannerDataSubject{
    if (!_refreshBannerDataSubject) {
        _refreshBannerDataSubject = [RACSubject subject];
    }
    return _refreshBannerDataSubject;
}
-(RACSubject *)detailsCellClickSubject{
    if (!_detailsCellClickSubject) {
        _detailsCellClickSubject = [RACSubject subject];
    }
    return _detailsCellClickSubject;
}
-(RACSubject *)refreshUISubject{
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}
-(NSMutableArray *)collectionArray{
    if (!_collectionArray) {
        _collectionArray = [[NSMutableArray alloc] init];
    }
    return _collectionArray;
}
-(int)page {
    if (!_page) {
        _page = 0;
    }
    return _page;
}
@end

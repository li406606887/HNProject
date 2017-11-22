//
//  ShareViewModel.m
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareViewModel.h"
#import "ShareModel.h"

@implementation ShareViewModel

-(void)initialize{
    @weakify(self)
    [self.shareDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        if (self.page ==1) {
            [self.shareDataArray removeAllObjects];
        }
        NSDictionary *data = x;
        NSArray *array = [data objectForKey:@"data"];
        for (NSDictionary *dic in array) {
            ShareModel *model = [ShareModel mj_objectWithKeyValues:dic];
            NSDictionary *dictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
            CGRect rect = [model.title boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-20, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                          attributes:dictionary
                                             context:nil];
            [self.textHeightArray addObject:[NSString stringWithFormat:@"%f",rect.size.height]];
            [self.shareDataArray addObject:model];
        }
        [self.refreshUISubject sendNext:@(RefreshError)];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(RACCommand *)shareDataCommand{
    if (!_shareDataCommand) {
        _shareDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSError *error;
                self.page = input==nil ? self.page : 0;
                NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
                [param setObject:[NSString stringWithFormat:@"%d",self.page] forKey:@"page"];
                self.page++;
                id data = [QHRequest getDataWithApi:@"shares" withParam:param error:&error];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error == nil) {
                        [subscriber sendNext:data];
                    }else{
                        NSString *message = [NSString stringWithFormat:@"%@",[data objectForKey:@"message"]];
                        showMassage(message)
                        [self.refreshUISubject sendNext:@(RefreshError)];
                        self.page--;

                    }
                    [subscriber sendCompleted];
                });
            });
            return nil;
        }];
        }];
    }
    return _shareDataCommand;
}

-(NSMutableArray *)textHeightArray{
    if (!_textHeightArray) {
        _textHeightArray = [[NSMutableArray alloc] init];
    }
    return _textHeightArray;
}

-(NSMutableArray *)shareDataArray{
    if (!_shareDataArray) {
        _shareDataArray = [[NSMutableArray alloc] init];
    }
    return _shareDataArray;
}
-(RACSubject *)refreshUISubject{
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
-(int)page {
    if (!_page) {
        _page = 0;
    }
    return _page;
}
@end

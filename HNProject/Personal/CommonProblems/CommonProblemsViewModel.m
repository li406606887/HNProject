//
//  CommonProblemsViewModel.m
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "CommonProblemsViewModel.h"
#import "CommonProblemsModel.h"

@implementation CommonProblemsViewModel
-(void)initialize {
    @weakify(self)
    [self.getQuestionDataCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        for (NSDictionary *dic in x) {
            CommonProblemsModel *model = [CommonProblemsModel mj_objectWithKeyValues:dic];
            NSDictionary *dictionary = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
            CGRect rect = [model.answer boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-67, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:dictionary context:nil];
            [self.textHeightArray addObject:[NSString stringWithFormat:@"%f",rect.size.height]];
            [self.dataArray addObject:model];
        }
        [self.refreshUISubject sendNext:nil];
    }];
}

-(RACCommand *)getQuestionDataCommand {
    if (!_getQuestionDataCommand) {
        _getQuestionDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                loading(@"");
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    NSError *error ;
                    id data = [QHRequest getDataWithApi:@"questions" withParam:input error:&error];
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
    return _getQuestionDataCommand;
}

-(RACSubject *)refreshUISubject{
    if (!_refreshUISubject) {
        _refreshUISubject = [RACSubject subject];
    }
    return _refreshUISubject;
}

-(RACSubject *)callPhoneSubject {
    if (!_callPhoneSubject) {
        _callPhoneSubject = [RACSubject subject];
    }
    return _callPhoneSubject;
}

-(NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [[NSMutableArray alloc] init];
    }
    return _dataArray;
}

-(NSMutableArray *)textHeightArray{
    if (!_textHeightArray) {
        _textHeightArray = [[NSMutableArray alloc] init];
    }
    return _textHeightArray;
}
@end

//
//  ShareViewModel.h
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface ShareViewModel : BaseViewModel
@property(nonatomic,strong) NSMutableArray *textHeightArray;
@property(nonatomic,strong) NSMutableArray *shareDataArray;
@property(nonatomic,strong) RACSubject *cellClickSubject;
@property(nonatomic,strong) RACSubject *refreshUISubject;
@property(nonatomic,strong) RACCommand *shareDataCommand;
@property(nonatomic,assign) int page;
@end

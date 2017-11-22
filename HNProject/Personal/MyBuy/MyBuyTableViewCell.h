//
//  MyBuyTableViewCell.h
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyBuyModel.h"
#import "MyBuyViewModel.h"

@interface MyBuyTableViewCell : BaseTableViewCell
@property(nonatomic,strong) UIButton *operationButton;//操作按钮
@property(nonatomic,strong) MyBuyModel *model;
@property(nonatomic,strong) MyBuyViewModel *viewModel;
@property(nonatomic,copy) NSString* stateString;//状态
@end

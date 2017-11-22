//
//  MyBankTableViewCell.h
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MyBankModel.h"
#import "MyBankViewModel.h"

@interface MyBankTableViewCell : BaseTableViewCell
@property(nonatomic,strong) MyBankModel *model;
@property(nonatomic,strong) MyBankViewModel *viewModel;
@end

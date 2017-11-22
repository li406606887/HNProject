//
//  ShareDetailsTableCell.h
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ShareDetailsModel.h"
#import "ShareDetailsViewModel.h"

@interface ShareDetailsTableCell : BaseTableViewCell
@property(nonatomic,strong) ShareCellDetailsModel *model;
@property(nonatomic,strong) ShareDetailsViewModel *viewModel;
//@property(nonatomic,strong) void(^PraiseBlock)();
@end

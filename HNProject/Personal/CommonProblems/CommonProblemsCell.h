//
//  CommonProblemsCell.h
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "CommonProblemsModel.h"

@interface CommonProblemsCell : BaseTableViewCell
@property(nonatomic,strong) CommonProblemsModel *model;
@property(nonatomic,assign) CGFloat height;
@end

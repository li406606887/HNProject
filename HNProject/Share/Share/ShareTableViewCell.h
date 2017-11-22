//
//  ShareTableViewCell.h
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ShareModel.h"

@interface ShareTableViewCell : BaseTableViewCell
@property(nonatomic,strong) ShareModel *model;
@property(nonatomic,assign) CGFloat height;
@end

//
//  MessageTableViewCell.h
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MessageModel.h"

@interface MessageTableViewCell : BaseTableViewCell
@property(nonatomic,strong) MessageModel *model;
@end

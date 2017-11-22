//
//  PersonalInfoTableViewCell.h
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface PersonalInfoTableViewCell : BaseTableViewCell

@end

@interface PersonalInfoIconTableViewCell : BaseTableViewCell
@property(nonatomic,copy) NSString* iconUrl;
@end

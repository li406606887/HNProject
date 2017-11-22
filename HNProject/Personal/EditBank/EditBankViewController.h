//
//  EditBankViewController.h
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ViewBaseController.h"
#import "MyBankModel.h"

typedef NS_ENUM (NSInteger, LoadingType)   {
    EditBankViewType,
    AddBankViewType,
};
@interface EditBankViewController : ViewBaseController
@property(nonatomic,assign) LoadingType type;
@property(nonatomic,strong) MyBankModel *model;
@end

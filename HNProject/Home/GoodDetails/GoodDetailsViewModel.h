//
//  GoodDetailsViewModel.h
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"
#import "GoodDetailsModel.h"
#import "MyBuyModel.h"

@interface GoodDetailsViewModel : BaseViewModel
@property(nonatomic,strong) RACSubject *scrollContentSizeSubject;
@property(nonatomic,strong) RACSubject *refreshUISubject;
@property(nonatomic,strong) RACSubject *refreshStateUISubject;
@property(nonatomic,strong) RACSubject *sumbitUISubject;
@property(nonatomic,strong) RACCommand *getGoodDetailsCommand;
@property(nonatomic,strong) RACSubject *sumbitPhotoSubject;
@property(nonatomic,strong) RACCommand *getApplysCommand;
@property(nonatomic,strong) RACCommand *applyProjectCommand;
@property(nonatomic,strong) RACCommand *isApplyProjectCommand;
@property(nonatomic,strong) RACSubject *applySuccessfulSubject;
@property(nonatomic,strong) RACSubject *tableContentSizeSubject;
@property(nonatomic,strong) NSMutableArray *taoPwdArray;
@property(nonatomic,strong) GoodDetailsModel *model;
@property(nonatomic,strong) MyBuyModel *myBuyModel;

@property(nonatomic,strong) RACCommand *reportClickCommand;

@property(nonatomic,assign) int type;
@property(nonatomic,copy  ) NSString* reason;
@end

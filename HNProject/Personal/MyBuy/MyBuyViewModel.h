//
//  MyBuyViewModel.h
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"
#import "MyBuyModel.h"

@interface MyBuyViewModel : BaseViewModel
//cell点击
@property(nonatomic,strong) RACSubject *segmentClickSubject;
@property(nonatomic,strong) RACSubject *auditCellClickSubJect;
@property(nonatomic,strong) RACSubject *modifyCellClickSubJect;
@property(nonatomic,strong) RACSubject *sumbitCellClickSubJect;
@property(nonatomic,strong) RACSubject *confirmCellClickSubJect;
@property(nonatomic,strong) RACSubject *completedCellClickSubJect;
@property(nonatomic,strong) RACSubject *sumbitEditClickSubJect;

//刷新UI
@property(nonatomic,strong) RACSubject *auditRefreshUISubject;
@property(nonatomic,strong) RACSubject *modifyRefreshUISubject;
@property(nonatomic,strong) RACSubject *sumbitRefreshUISubject;
@property(nonatomic,strong) RACSubject *confirmRefreshUISubject;
@property(nonatomic,strong) RACSubject *completedRefreshUISubject;
//获取数据
@property(nonatomic,strong) RACCommand *auditDataCommand;
@property(nonatomic,strong) RACCommand *modifyDataCommand;
@property(nonatomic,strong) RACCommand *sumbitDataCommand;
@property(nonatomic,strong) RACCommand *confirmDataCommand;
@property(nonatomic,strong) RACCommand *completedCommand;
//页码
@property(nonatomic,assign) int auditPage;
@property(nonatomic,assign) int modifyPage;
@property(nonatomic,assign) int sumbitPage;
@property(nonatomic,assign) int confirmPage;
@property(nonatomic,assign) int completedPage;
//数组
@property(nonatomic,strong) NSMutableArray *auditArray;
@property(nonatomic,strong) NSMutableArray *sumbitArray;
@property(nonatomic,strong) NSMutableArray *modifyArray;
@property(nonatomic,strong) NSMutableArray *confirmArray;
@property(nonatomic,strong) NSMutableArray *completedArray;
//
//
@property(nonatomic,assign) int type;
@end

//
//  GrabCouponViewModel.h
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface GrabCouponViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *getBannerDataCommand;
@property(nonatomic,strong) RACSubject *refreshBannerDataSubject;

@property(nonatomic,strong) RACSubject  *detailsCellClickSubject;
@property(nonatomic,strong) RACCommand *getCollectionDataCommand;

@property(nonatomic,strong) RACSubject *refreshUISubject;
@property(nonatomic,strong) NSMutableArray *collectionArray;

@property(nonatomic,assign) int page;
@end

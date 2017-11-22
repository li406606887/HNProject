//
//  HomeViewModel.h
//  HNProject
//
//  Created by user on 2017/7/13.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface HomeViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *getBannerDataCommand;
@property(nonatomic,strong) RACSubject *refreshBannerDataSubject;
@property(nonatomic,strong) RACCommand *getCollectionDataCommand;
@property(nonatomic,strong) RACSubject *refreshCollectionSubject;
@property(nonatomic,strong) RACSubject *homeCellClickSubject;
@property(nonatomic,strong) NSMutableArray *scrollArray;
@property(nonatomic,strong) NSMutableArray *collectionArray;
@property(nonatomic,assign) int page;
@end

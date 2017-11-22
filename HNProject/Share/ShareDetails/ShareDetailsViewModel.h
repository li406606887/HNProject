//
//  ShareDetailsViewModel.h
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"

@interface ShareDetailsViewModel : BaseViewModel
@property(nonatomic,copy) NSString* detailsID;

@property(nonatomic,strong) RACSubject *editorialCommentsSubject;
@property(nonatomic,strong) RACSubject *rewardClickSubject;

@property(nonatomic,strong) RACCommand *shareDetailsCommand;
@property(nonatomic,strong) RACCommand *getShareCommentsCommand;
@property(nonatomic,strong) RACCommand *sendCommentsCommand;

@property(nonatomic,strong) RACSubject *refreshCellUISubject;
@property(nonatomic,strong) RACSubject *refreshHeadUISubject;
@property(nonatomic,strong) NSMutableArray *shareDetailsCellArray;


@property(nonatomic,strong) RACCommand *isPraiseCommand;
@property(nonatomic,strong) RACCommand *praiseCommand;
@property(nonatomic,strong) RACCommand *cancelpraiseCommand;
@property(nonatomic,strong) RACSubject *praiseRefreshUISubject;


@property(nonatomic,strong) RACCommand *commentsCancelPraiseCommand;
@property(nonatomic,strong) RACCommand *commentsPraiseCommand;
@property(nonatomic,strong) RACSubject *refreshCellSubject;


@property(nonatomic,strong) RACCommand *rewardClickCommand;
@property(nonatomic,strong) RACSubject *rewardSuccessfulSubject;

@property(nonatomic,strong) RACSubject *lookBigPhotoSubject;

@property(nonatomic,copy) NSString* praiseCount;
@property(nonatomic,copy) NSString* rewardsCount;

@property(nonatomic,assign) int type;

@property(nonatomic,assign) int oldIndex;

@property(nonatomic,assign) int page;

@property(nonatomic,strong) RACCommand *getCommentsListCommand;

@end

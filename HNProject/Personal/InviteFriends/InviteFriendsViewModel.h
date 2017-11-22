//
//  InviteFriendsViewModel.h
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "BaseViewModel.h"
#import "InvitePeopleModel.h"

@interface InviteFriendsViewModel : BaseViewModel
@property(nonatomic,strong) RACCommand *getInvitePeopleCommand;
@property(nonatomic,strong) RACCommand *getInviteFrendsCommand;
@property(nonatomic,strong) RACSubject *refreshUISuject;
@property(nonatomic,strong) InvitePeopleModel *peopleModel;
@property(nonatomic,strong) NSMutableArray *dataArray;
@end

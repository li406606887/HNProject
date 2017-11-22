//
//  GoodDetailsViewController.h
//  HNProject
//
//  Created by user on 2017/7/21.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ViewBaseController.h"

typedef NS_ENUM(int, LoadingAway) {
    LoadingAwayStateBuy,//-----0
    LoadingAwayStateAudit,//-----1
    LoadingAwayStateSumbit,//-----2
    LoadingAwayStateModify,//-----3
    LoadingAwayStateConfirm,//-----4
    LoadingAwayStateComplete//-----5
};

@interface GoodDetailsViewController : ViewBaseController
@property(nonatomic,assign) LoadingAway type;
@property(nonatomic,copy) NSString* detailsID;
@property(nonatomic,copy) NSString* applysID;
@end

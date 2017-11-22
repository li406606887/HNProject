//
//  ShareDetailsViewController.h
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ViewBaseController.h"

@interface ShareDetailsViewController : ViewBaseController
@property(nonatomic,copy) NSString* detailsId;//详情
@property(nonatomic,assign) int type;//1，查看别人分享 2.查看自己分享历史详情
@end

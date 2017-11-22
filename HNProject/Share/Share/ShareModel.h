//
//  ShareModel.h
//  HNProject
//
//  Created by user on 2017/7/19.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject
@property(nonatomic,copy) NSString* content;
@property(nonatomic,copy) NSString* comments;
@property(nonatomic,copy) NSString* created_at;
@property(nonatomic,copy) NSString* ID;
@property(nonatomic,copy) NSString* is_top;
@property(nonatomic,copy) NSString* reason;
@property(nonatomic,copy) NSString* rewards;
@property(nonatomic,copy) NSString* status;
@property(nonatomic,strong) NSArray *thumb;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* updated_at;
@property(nonatomic,strong) HNUserModel *user;
@property(nonatomic,copy) NSString* user_id;
@property(nonatomic,copy) NSString* zan;
@end
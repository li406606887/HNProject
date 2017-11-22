//
//  RegisterModel.h
//  HNProject
//
//  Created by user on 2017/7/22.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RegisterModel : NSObject
@property(nonatomic,copy) NSString *phone;
@property(nonatomic,copy) NSString *password;
@property(nonatomic,copy) NSString *taobao_id;
@property(nonatomic,copy) NSString *qq;
@property(nonatomic,copy) NSString *real_name;
@property(nonatomic,copy) NSString *province;
@property(nonatomic,copy) NSString *city;
@property(nonatomic,copy) NSString *inviter_id;
@property(nonatomic,copy) NSString *invite_relationship;
@property(nonatomic,copy) NSString *code;
@property(nonatomic,copy) NSString *wechat;
@end

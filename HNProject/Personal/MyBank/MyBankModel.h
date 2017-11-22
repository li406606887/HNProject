//
//  MyBankModel.h
//  HNProject
//
//  Created by user on 2017/7/18.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyBankModel : NSObject
@property(nonatomic,copy) NSString* ID;
@property(nonatomic,copy) NSString* user_id;
@property(nonatomic,copy) NSString* card_no;
@property(nonatomic,copy) NSString* bank;
@property(nonatomic,copy) NSString* cardholder;
@property(nonatomic,copy) NSString* created_at;
@property(nonatomic,copy) NSString* updated_at;
@end

//
//  MyGoldModel.h
//  HNProject
//
//  Created by user on 2017/7/28.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyGoldModel : NSObject
@property(nonatomic,copy) NSString* ID;
@property(nonatomic,copy) NSString* bill_number;
@property(nonatomic,copy) NSString* accountable_type;
@property(nonatomic,copy) NSString* accountable_id;
@property(nonatomic,copy) NSString* type;
@property(nonatomic,copy) NSString* amount;
@property(nonatomic,copy) NSString* remarks;
@property(nonatomic,copy) NSString* balance;
@property(nonatomic,copy) NSString* created_at;
@property(nonatomic,copy) NSString* updated_at;
@end

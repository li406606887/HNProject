//
//  HomeCollectionModel.h
//  HNProject
//
//  Created by user on 2017/7/25.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeCollectionModel : NSObject
@property(nonatomic,copy) NSString* content;
@property(nonatomic,copy) NSString* created_at;
@property(nonatomic,copy) NSString* golds;
@property(nonatomic,copy) NSString* ID;
@property(nonatomic,copy) NSString* merchant_id;
@property(nonatomic,copy) NSString* number_of;
@property(nonatomic,copy) NSString* section_id;
@property(nonatomic,copy) NSString* taobao_id;
@property(nonatomic,strong) NSArray* thumb;
@property(nonatomic,copy) NSString* title;
@property(nonatomic,copy) NSString* updated_at;
@property(nonatomic,copy) NSString* remain_of;
@end

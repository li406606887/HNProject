//
//  MessageModel.h
//  HNProject
//
//  Created by user on 2017/7/16.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject
@property(nonatomic,copy) NSString *ID;
@property(nonatomic,copy) NSString *messageable_type;
@property(nonatomic,copy) NSString *messageable_id;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *content;
@property(nonatomic,copy) NSString *is_read;
@property(nonatomic,copy) NSString *created_at;
@property(nonatomic,copy) NSString *updated_at;
@property(nonatomic,copy) NSString* type;
@property(nonatomic,copy) NSString* type_id;
@end

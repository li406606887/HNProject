//
//  MyBuyModel.h
//  HNProject
//
//  Created by user on 2017/7/17.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectModel.h"

@interface MyBuyModel : NSObject
@property(nonatomic,copy) NSString* ID;
@property(nonatomic,copy) NSString* user_id;
@property(nonatomic,copy) NSString* project_id;
@property(nonatomic,copy) NSString* apply_number;
@property(nonatomic,strong) NSArray* thumb;
@property(nonatomic,copy) NSString* status;
@property(nonatomic,copy) NSString* applied_at;
@property(nonatomic,copy) NSString* checked_at;
@property(nonatomic,copy) NSString* submitted_at;
@property(nonatomic,copy) NSString* turned_at;
@property(nonatomic,copy) NSString* turned_reason;
@property(nonatomic,copy) NSString* modified_at;
@property(nonatomic,copy) NSString* succeed_at;
@property(nonatomic,copy) NSString* updated_at;
@property(nonatomic,strong) ProjectModel* project;
@end

//
//  NotifyModel.h
//  HNProject
//
//  Created by user on 2017/8/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotifyModel : NSObject
@property(nonatomic,copy) NSString* type;
@property(nonatomic,copy) NSString* type_id;
@property(nonatomic,strong) NSMutableDictionary *aps;
@end

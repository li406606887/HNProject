//
//  HNUserModel.m
//  HNProject
//
//  Created by user on 2017/7/24.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HNUserModel.h"

@implementation HNUserModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             };
}
@end

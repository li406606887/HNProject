//
//  ShareDetailsModel.m
//  HNProject
//
//  Created by user on 2017/7/20.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ShareDetailsModel.h"

@implementation ShareDetailsModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             
             };
}
@end

@implementation ShareCellDetailsModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             
             };
}
@end

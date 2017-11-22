//
//  ProjectModel.m
//  HNProject
//
//  Created by user on 2017/7/27.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "ProjectModel.h"

@implementation ProjectModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"ID" : @"id",
             };
}
@end

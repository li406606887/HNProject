//
//  HNUesrInformation.h
//  HNProject
//
//  Created by user on 2017/7/23.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HNUesrInformation : NSObject
@property(nonatomic,strong) HNUserModel *model;
@property(nonatomic,strong) NSMutableDictionary *praiseDic;

@property(nonatomic,copy) NSString* token;
@property(nonatomic,copy) NSString* expire;
+(HNUesrInformation*)getInformation;
-(BOOL)login;
-(void)getQNToken;
+ (BOOL)valiMobile:(NSString *)mobile;
-(BOOL)hiddenStyle;
@end



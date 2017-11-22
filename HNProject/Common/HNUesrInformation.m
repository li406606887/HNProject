//
//  HNUesrInformation.m
//  HNProject
//
//  Created by user on 2017/7/23.
//  Copyright © 2017年 OnePiece. All rights reserved.
//

#import "HNUesrInformation.h"

@implementation HNUesrInformation

+(HNUesrInformation*)getInformation{
    static HNUesrInformation *userInfor;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userInfor = [[HNUesrInformation alloc] init];
    });
    
    return userInfor;
}

-(void)setModel:(HNUserModel *)model{
    _model = model;
}

-(BOOL)login{
   self.token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
   self.expire = [[NSUserDefaults standardUserDefaults] objectForKey:@"expire"];
   NSString *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"user"];
    if (data==nil) {
        return NO;
    }
   NSDictionary *dic = [self dictionaryWithJsonString:data];
    HNUserModel *model = [HNUserModel mj_objectWithKeyValues:dic];
    [HNUesrInformation getInformation].model = model;
    if (self.model!=nil) {
        return YES;
    }else{
        return NO;
    }
}

-(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                         
                                                        options:NSJSONReadingMutableContainers
                         
                                                          error:&err];
    
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
    
}

-(void)getQNToken{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSError *error;
        NSString *api = [NSString stringWithFormat:@"qiniu_token"];
       id data = [QHRequest getDataWithApi:api
                                               withParam:nil
                                                   error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error==nil) {
                    [[NSUserDefaults standardUserDefaults] setObject:[data objectForKey:@"token"] forKey:@"QNToken"];
            }
       });
        
    });
}

//判断手机号码格式是否正确
+ (BOOL)valiMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        /**
         * 移动号段正则表达式
         */
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        /**
         * 联通号段正则表达式
         */
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        /**
         * 电信号段正则表达式
         */
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}

-(BOOL)hiddenStyle {
    return [NSDate givenPeriodIsLate:@"2017-11-25 00:00:00"];
}
-(NSMutableDictionary *)praiseDic {
    if (!_praiseDic) {
        _praiseDic = [[NSMutableDictionary alloc] init];
    }
    return _praiseDic;
}
@end

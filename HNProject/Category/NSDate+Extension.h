//
//  NSDate+Extension.h
//  
//
//  Created by mac on 16/1/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Extension)

/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;
/**
 *  获取发布日期
 */
+(NSString *)getReleaseDate:(NSString *)seconds format:(NSString *)format;
/**
 *  获取发布日期
 */
+(NSString *)changeTheNoticeTime:(NSString *)time;
/**
 *  判断日期
 */
+(BOOL)givenPeriodIsLate:(NSString *)date;
@end

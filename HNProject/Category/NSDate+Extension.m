//
//  NSDate+Extension.m
//  
//
//  Created by mac on 16/1/10.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "NSDate+Extension.h"

@implementation NSDate (Extension)

/**
 *  是否为今天
 */
- (BOOL)isToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)isYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}

/**
 *  是否为今年
 */
- (BOOL)isThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}
+(NSString *)getReleaseDate:(NSString *)seconds format:(NSString *)format{

    NSString * astr = [seconds stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/Date()/"]];
    NSString * bstr = [astr substringWithRange:NSMakeRange(0,10)];
    
    NSTimeInterval time  = [bstr doubleValue];//因为时差问题要加8小时 == 28800 sec
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time];
    
    //实例化一个NSDateFormatter对象
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc]init];
    
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:format];
    NSString * currentDateStr = [dateFormatter stringFromDate:date];
    

    return currentDateStr;
}



+(NSString *)changeTheNoticeTime:(NSString *)time{
    NSDateFormatter * dateFormatter_one = [[NSDateFormatter alloc]init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter_one setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter_one dateFromString:time];
    
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFomatter = [[NSDateFormatter alloc] init];
    dateFomatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSString *releasetime; //发布时间
    // 当前时间字符串格式
    NSString *nowDateStr = [dateFomatter stringFromDate:nowDate];
    // 截止时间data格式
    NSDate *expireDate = [dateFomatter dateFromString:time];
    // 当前时间data格式
    nowDate = [dateFomatter dateFromString:nowDateStr];
    // 当前日历
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 需要对比的时间数据
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth
    | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    // 对比时间差
    NSDateComponents *dateCom = [calendar components:unit fromDate:nowDate toDate:expireDate options:0];
    int month = (int)dateCom.month*-1;
    int day = (int)dateCom.day*-1;
    int hour = (int)dateCom.hour*-1;
    int minute = (int)dateCom.minute*-1;
    if (month >0||day >0) {
        NSDateFormatter * dateFormatter_two = [[NSDateFormatter alloc]init];
        [dateFormatter_two setDateFormat:@"MM-dd HH:mm"];
        releasetime = [dateFormatter_two stringFromDate:date];
        return releasetime;
    }else if(hour>0){
        releasetime = [NSString stringWithFormat:@"%d小时前",hour];
        return releasetime;
    }else if(minute>5){
        releasetime = [NSString stringWithFormat:@"%d分钟前",hour];
        return releasetime;
    }else{
        releasetime = @"刚刚";
        return releasetime;
    }
    
}

+(BOOL)givenPeriodIsLate:(NSString *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //指定时间显示样式: HH表示24小时制 hh表示12小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate *lastDate = [formatter dateFromString:date];
    //以 1970/01/01 GMT为基准，得到lastDate的时间戳
    long firstStamp = [lastDate timeIntervalSince1970];
    
    long secondTimeZone = [[NSDate date] timeIntervalSince1970];
    
    if (firstStamp < secondTimeZone) {
        return YES;
    }
    return NO;
}
@end

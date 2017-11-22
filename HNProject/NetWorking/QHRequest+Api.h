//
//  QHRequest+Api.h
//  QHTrade
//
//  Created by user on 2017/6/1.
//  Copyright © 2017年 qihuo.RDTrade.com. All rights reserved.
//

#import "QHRequest.h"
#import "QHRequestModel.h"

@interface QHRequest (Api)
//post 提交数据
+(id )postDataWithApi:(NSString *)api withParam:(NSDictionary*)data_dic
                             error:(NSError* __autoreleasing*)error;
//put 
+(id )putDataWithApi:(NSString *)api withParam:(NSDictionary*)data_dic
               error:(NSError* __autoreleasing*)error;
//get 获取数据
+(id )getDataWithApi:(NSString *)api withParam:(NSDictionary*)data_dic
                            error:(NSError* __autoreleasing*)error;
+(id )deleteDataWithApi:(NSString *)api withParam:(NSDictionary *)data_dic
                  error:(NSError *__autoreleasing *)error;
@end

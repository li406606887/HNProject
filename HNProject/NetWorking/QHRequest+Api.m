//
//  QHRequest+Api.m
//  QHTrade
//
//  Created by user on 2017/6/1.
//  Copyright © 2017年 qihuo.RDTrade.com. All rights reserved.
//

#import "QHRequest+Api.h"

@implementation QHRequest (Api)

+(id )postDataWithApi:(NSString *)api withParam:(NSDictionary *)data_dic error:(NSError *__autoreleasing *)error{
    
    NSString *request_Url = [NSString stringWithFormat:@"%@%@",HostUrlBak,api];
    __block id model=nil;
    __block NSError *blockError = nil;
    [[QHRequest request] POST:request_Url
                   parameters:data_dic
                      success:^(QHRequest *request, id response) {
                          NSDictionary *data = (NSDictionary *)response;
                          NSString *message;
                          if ([data isKindOfClass:[NSDictionary class]]) {
                              message = [data objectForKey:@"message"];
                          }
                          if (message!=nil) {
                              blockError = (NSError *)message;
                          }
                          model = data;
                      }
                      failure:^(QHRequest *request, NSError *error) {
                          blockError = error;
                      }];
    if (blockError) {
        *error = blockError;
    }
    return model;
}

+(id )putDataWithApi:(NSString *)api withParam:(NSDictionary*)data_dic
                              error:(NSError* __autoreleasing*)error{
    NSString *request_Url = [NSString stringWithFormat:@"%@%@",HostUrlBak,api];
    __block id model=nil;
    __block NSError *blockError = nil;
    
    [[QHRequest request] PUTWithURLStr:request_Url
                              paramDic:data_dic
                               success:^(QHRequest *request, id response) {
                                   NSDictionary *data = (NSDictionary *)response;
                                   NSString *message;
                                   
                                   if ([data isKindOfClass:[NSDictionary class]]) {
                                       message = [data objectForKey:@"message"];
                                   }
                                   if (message!=nil) {
                                       blockError = (NSError *)message;
                                   }
                                   model = data;
                               }
                               failure:^(QHRequest *request, NSError *error) {
                                   blockError = error;
                               }];
    if (blockError) {
        *error = blockError;
    }
    return model;
}

+(id )getDataWithApi:(NSString *)api withParam:(NSDictionary *)data_dic error:(NSError *__autoreleasing *)error{
    NSString *request_Url = [NSString stringWithFormat:@"%@%@",HostUrlBak,api];
    __block id model=nil;
    __block NSError *blockError = nil;
    [[QHRequest request] GET:request_Url parameters:data_dic success:^(QHRequest *request, id response) {
        NSDictionary *data = (NSDictionary *)response;
        NSString *message;
        
        if ([data isKindOfClass:[NSDictionary class]]) {
            message = [data objectForKey:@"message"];
        }
        if (message!= nil) {
            blockError = (NSError *)message;
        }
        model = data;
    } failure:^(QHRequest *request, NSError *error) {
        blockError = error;
    }];
    if (blockError) {
        *error = blockError;
    }
    return model;
}

+(id )deleteDataWithApi:(NSString *)api withParam:(NSDictionary *)data_dic error:(NSError *__autoreleasing *)error{
    NSString *request_Url = [NSString stringWithFormat:@"%@%@",HostUrlBak,api];
    __block id model=nil;
    __block NSError *blockError = nil;
    [[QHRequest request] DELETEWithURLStr:request_Url
                                 paramDic:data_dic
                                  success:^(QHRequest *request, id response) {
                                      NSDictionary *data = (NSDictionary *)response;
                                      NSString *message;
                                      
                                      if ([data isKindOfClass:[NSDictionary class]]) {
                                          message = [data objectForKey:@"message"];
                                      }
                                      if (message!=nil) {
                                          blockError = (NSError *)message;
                                      }
                                      model = data;
                                  }
                                  failure:^(QHRequest *request, NSError *error) {
                                      blockError = error;

                                  }];
    if (blockError) {
        *error = blockError;
    }
    return model;
}

@end

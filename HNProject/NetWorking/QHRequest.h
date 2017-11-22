//
//  QHRequest.h
//  QHTrade
//
//  Created by user on 2017/6/1.
//  Copyright © 2017年 qihuo.RDTrade.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPSessionManager.h"

@class QHRequest;
@protocol QHRequestDelegate <NSObject>

- (void)QHRequest:(QHRequest *)request finished:(id )response;
- (void)QHRequest:(QHRequest *)request Error:(NSString *)error;

@end



@interface QHRequest : NSObject

@property (assign) id <QHRequestDelegate> delegate;

/**
 *[AFNetWorking]的operationManager对象
 */
@property (nonatomic, strong) AFHTTPSessionManager* operationManager;

/**
 *当前的请求operation队列
 */
@property (nonatomic, strong) NSOperationQueue* operationQueue;
/**
 *当前的请求operation队列
 */
//@property (nonatomic, strong) NSOperationQueue* operationQueue;

/**
 *功能: 创建CMRequest的对象方法
 */
+ (instancetype)request;

/**
 *功能：POST请求 上传图片用 timeout = 10.0f
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
- (void)PUTWithURLStr:(NSString *)urlStr
             paramDic:(NSDictionary *)paramDic
              success:(void (^)(QHRequest * request, id response))success
              failure:(void (^)(QHRequest * request, NSError *error))failure;
/**
 *功能：GET请求
 *参数：(1)请求的url: urlString
 *     (2)请求成功调用的Block: success
 *     (3)请求失败调用的Block: failure
 */
- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(QHRequest *request, id response))success
    failure:(void (^)(QHRequest *request, NSError *error))failure;

/**
 *功能：POST请求
 *参数：(1)请求的url: urlString
 *     (2)POST请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */
- (void)POST:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(QHRequest *request, id response))success
     failure:(void (^)(QHRequest *request, NSError *error))failure;


/**
 *功能：DELETE请求
 *参数：(1)请求的url: urlString
 *     (2)请求体参数:parameters
 *     (3)请求成功调用的Block: success
 *     (4)请求失败调用的Block: failure
 */

- (void)DELETEWithURLStr:(NSString *)urlStr
                paramDic:(NSDictionary *)paramDic
                 success:(void (^)(QHRequest * request, id response))success
                 failure:(void (^)(QHRequest * request, NSError *error))failure;
/**
 *  post请求
 *
 *  @param URLString  请求网址
 *  @param parameters 请求参数
 */
- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters;

/**
 *  get 请求
 *
 *  @param URLString 请求网址
 */
- (void)getWithURL:(NSString *)URLString;

/**
 *取消当前请求队列的所有请求
 */
- (void)cancelAllOperations;




@end

//
//  QHRequest.m
//  QHTrade
//
//  Created by user on 2017/6/1.
//  Copyright © 2017年 qihuo.RDTrade.com. All rights reserved.
//


#import "QHRequest.h"


@implementation QHRequest


+ (instancetype)request {
    return [[self alloc] init];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.operationManager = [AFHTTPSessionManager manager];
    }
    return self;
}

- (void)PUTWithURLStr:(NSString *)urlStr
             paramDic:(NSDictionary *)paramDic
              success:(void (^)(QHRequest * request, id response))success
              failure:(void (^)(QHRequest * request, NSError *error))failure{
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.operationManager.requestSerializer.timeoutInterval = 10.f;
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript",@"text/html", nil];
    NSString*token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token!=nil) {
        [self.operationManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    }
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.operationManager PUT:urlStr parameters:paramDic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
        success(self,object);
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(self,error);
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}
- (void)DELETEWithURLStr:(NSString *)urlStr
                paramDic:(NSDictionary *)paramDic
                 success:(void (^)(QHRequest * request, id response))success
                 failure:(void (^)(QHRequest * request, NSError *error))failure{
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.operationManager.requestSerializer.timeoutInterval = 10.f;
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript",@"text/html", nil];
    NSString*token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token!=nil) {
        [self.operationManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    }
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.operationManager DELETE:urlStr
                       parameters:paramDic
                          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                              id object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                              
                              success(self,object);
                              dispatch_semaphore_signal(semaphore);
                          } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                              failure(self,error);
                              dispatch_semaphore_signal(semaphore);
                          }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}

- (void)GET:(NSString *)URLString
 parameters:(NSDictionary*)parameters
    success:(void (^)(QHRequest * request, id response))success
    failure:(void (^)(QHRequest * request, NSError *error))failure {
    
    self.operationQueue=self.operationManager.operationQueue;
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.operationManager.requestSerializer.timeoutInterval = 10.f;
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript",@"text/html", nil];
    NSString*token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token!=nil) {
        [self.operationManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    }
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.operationManager GET:URLString
                    parameters:parameters
                      progress:^(NSProgress * _Nonnull downloadProgress) {
                          
                      }
                       success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           id object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                           
                           success(self,object);
                           dispatch_semaphore_signal(semaphore);
                           
                       }
                       failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           failure(self,error);
                           dispatch_semaphore_signal(semaphore);
                           
                       }
     ];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    
}

- (void)POST:(NSString *)URLString
  parameters:(NSDictionary*)parameters
     success:(void (^)(QHRequest *request, id response))success
     failure:(void (^)(QHRequest *request, NSError *error))failure{
    
    self.operationQueue = self.operationManager.operationQueue;
    self.operationManager.requestSerializer.timeoutInterval = 10.f;
    self.operationManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.operationManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain", @"text/json", @"text/javascript",@"text/html", nil];
    NSString*token = [[NSUserDefaults standardUserDefaults] objectForKey:@"token"];
    if (token!=nil) {
        [self.operationManager.requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",token] forHTTPHeaderField:@"Authorization"];
    }
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [self.operationManager POST:URLString
                     parameters:parameters
                       progress:^(NSProgress * _Nonnull uploadProgress) {

                       }
                        success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                            id object;
                            if ([responseObject isKindOfClass:[NSData class]]) {
                                object = [NSJSONSerialization JSONObjectWithData:responseObject options:kNilOptions error:nil];
                            }else{
                                object =responseObject;
                            }
                            
                            success(self,object);
                            
                            dispatch_semaphore_signal(semaphore);
                            
                        }
                        failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            failure(self,error);
                            dispatch_semaphore_signal(semaphore);
                            
                        }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
}
- (BOOL)isValidateString:(NSString*)str
{
    if (str == nil)
    {
        return NO;
    }
    
    if ([str isKindOfClass:[NSNull class]])
    {
        return NO;
    }
    
    if ([str isEqualToString:@""])
    {
        return NO;
    }
    
    if ([str length] == 0)
    {
        return NO;
    }
    
    return YES;
}

- (void)postWithURL:(NSString *)URLString parameters:(NSDictionary *)parameters {
    
    [self POST:URLString
    parameters:parameters
       success:^(QHRequest *request, id  response) {
           if ([self.delegate respondsToSelector:@selector(QHRequest:finished:)]) {
               [self.delegate QHRequest:request finished:response];
               
           }
       }
       failure:^(QHRequest *request, NSError *error) {
           if ([self.delegate respondsToSelector:@selector(QHRequest:Error:)]) {
               [self.delegate QHRequest:request Error:error.description];
           }
       }];
}

- (void)getWithURL:(NSString *)URLString {
    
    [self GET:URLString parameters:nil success:^(QHRequest *request, id response) {
        if ([self.delegate respondsToSelector:@selector(QHRequest:finished:)]) {
            [self.delegate QHRequest:request finished:response];
        }
    } failure:^(QHRequest *request, NSError *error) {
        if ([self.delegate respondsToSelector:@selector(QHRequest:Error:)]) {
            [self.delegate QHRequest:request Error:error.description];
        }
    }];
}

- (void)cancelAllOperations{
    [self.operationQueue cancelAllOperations];
}

@end

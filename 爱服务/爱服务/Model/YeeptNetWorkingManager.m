//
//  YeeptNetWorkingManager.m
//  爱服务
//
//  Created by 张冬冬 on 16/8/1.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "YeeptNetWorkingManager.h"
#import "AFNetworking.h"
@implementation YeeptNetWorkingManager

+ (void)GETMethodBaseURL:(NSString *)baseURL path:(NSString *)subURL parameters:(NSDictionary *)parameters isJSONSerialization:(BOOL)isJSONSerialization progress:(void (^) (NSProgress *progress))progress success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseURL, subURL];
    
    if (!isJSONSerialization) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
    
    
}

+ (void)POSTMethodBaseURL:(NSString *)baseURL path:(NSString *)subURL parameters:(NSDictionary *)parameters isJSONSerialization:(BOOL)isJSONSerialization progress:(void (^) (NSProgress *progress))progress success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure {
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"%@%@",baseURL, subURL];
    if (!isJSONSerialization) {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    
    [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}



@end

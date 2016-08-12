//
//  YeeptNetWorkingManager.h
//  爱服务
//
//  Created by 张冬冬 on 16/8/1.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface YeeptNetWorkingManager : NSObject

+ (void)GETMethodBaseURL:(NSString *)baseURL path:(NSString *)subURL parameters:(NSDictionary *)parameters isJSONSerialization:(BOOL)isJSONSerialization progress:(void (^) (NSProgress *progress))progress success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure;

+ (void)POSTMethodBaseURL:(NSString *)baseURL path:(NSString *)subURL parameters:(NSDictionary *)parameters isJSONSerialization:(BOOL)isJSONSerialization progress:(void (^) (NSProgress *progress))progress success:(void (^) (id responseObject))success failure:(void (^) (NSError *error))failure;


@end

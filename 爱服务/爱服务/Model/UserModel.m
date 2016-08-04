//
//  UserModel.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    [aCoder encodeObject:[NSNumber numberWithInteger:self.uid] forKey:@"uid"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.comid] forKey:@"comid"];
    [aCoder encodeObject:[NSNumber numberWithFloat:self.money] forKey:@"money"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.provinceid] forKey:@"provinceid"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.cityid] forKey:@"cityid"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.districtid] forKey:@"districtid"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.companyName forKey:@"companyName"];
    [aCoder encodeObject:self.masterName forKey:@"masterName"];
    [aCoder encodeObject:self.userType forKey:@"userType"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.uid = [[aDecoder decodeObjectForKey:@"uid"] integerValue];
        self.comid = [[aDecoder decodeObjectForKey:@"comid"] integerValue];
        self.money = [[aDecoder decodeObjectForKey:@"money"] floatValue];
        self.provinceid = [[aDecoder decodeObjectForKey:@"provinceid"] integerValue];
        self.cityid = [[aDecoder decodeObjectForKey:@"cityid"] integerValue];
        self.districtid = [[aDecoder decodeObjectForKey:@"districtid"] integerValue];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.companyName = [aDecoder decodeObjectForKey:@"companyName"];
        self.masterName = [aDecoder decodeObjectForKey:@"masterName"];
        self.userType = [aDecoder decodeObjectForKey:@"userType"];
    }
    return self;
}

+ (void)writeUserModel:(UserModel *)userModel {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userModel];
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userModel.data"];
    [data writeToFile:filePath atomically:YES];
}

+ (instancetype)readUserModel {
    NSString *filePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userModel.data"];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    UserModel *userModel = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return userModel;
}

@end

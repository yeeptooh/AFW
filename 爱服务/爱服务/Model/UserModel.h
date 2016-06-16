//
//  UserModel.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/9.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
<
NSCoding
>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) NSInteger comid;
@property (nonatomic, assign) CGFloat money;
//@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) NSInteger provinceid;
@property (nonatomic, assign) NSInteger cityid;
@property (nonatomic, assign) NSInteger districtid;

+ (void)writeUserModel:(UserModel *)userModel;
+ (UserModel *)readUserModel;

@end

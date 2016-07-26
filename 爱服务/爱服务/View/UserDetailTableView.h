//
//  UserDetailTableView.h
//  爱服务
//
//  Created by 张冬冬 on 16/6/22.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserDetailTableView : UITableView
@property (nonatomic, strong) NSString *FprovinceID;
@property (nonatomic, strong) NSString *FcityID;
@property (nonatomic, strong) NSString *FregionID;
@property (nonatomic, strong) NSString *FstreetID;

@property (nonatomic, strong) NSString *YprovinceID;
@property (nonatomic, strong) NSString *YcityID;
@property (nonatomic, strong) NSString *YregionID;
@property (nonatomic, strong) NSString *YstreetID;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *district;
@property (nonatomic, strong) NSString *town;
@property (nonatomic, strong) NSString *address;

@end

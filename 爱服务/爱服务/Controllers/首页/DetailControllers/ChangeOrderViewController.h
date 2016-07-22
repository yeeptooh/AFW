//
//  ChangeOrderViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/7/19.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DetailPageBaseViewController.h"
#import "UserDetailTableView.h"
#import "ProductDetailTableView.h"
#import "BusinessDetailTableView.h"
@interface ChangeOrderViewController : DetailPageBaseViewController
@property (nonatomic, strong) UserDetailTableView *userTableView;
@property (nonatomic, strong) ProductDetailTableView *productTableView;
@property (nonatomic, strong) BusinessDetailTableView *businessTableView;

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *fromUserName;
@property (nonatomic, assign) NSInteger baoxiuIndex;
@property (nonatomic, strong) NSString *service_classify_id;
@property (nonatomic, strong) NSString *product_big_classify_id;
@property (nonatomic, strong) NSString *product_small_classify_id;
@property (nonatomic, strong) NSString *product_breed_id;
@property (nonatomic, strong) NSString *product_type;
@property (nonatomic, strong) NSString *buy_time;
@property (nonatomic, strong) NSString *buyer_name;
@property (nonatomic, strong) NSString *buyerPhone;
@property (nonatomic, strong) NSString *buyer_province_id;
@property (nonatomic, strong) NSString *buyer_province;
@property (nonatomic, strong) NSString *buyer_city_id;
@property (nonatomic, strong) NSString *buyer_city;
@property (nonatomic, strong) NSString *buyer_district_id;
@property (nonatomic, strong) NSString *buyer_district;
@property (nonatomic, strong) NSString *buyer_town_id;
@property (nonatomic, strong) NSString *buyer_town;
@property (nonatomic, strong) NSString *buyer_address;
@property (nonatomic, strong) NSString *expectant_time;
@property (nonatomic, strong) NSString *postscript;
@property (nonatomic, strong) NSString *handler_name;
@property (nonatomic, strong) NSString *order_number;
@property (nonatomic, strong) NSString *from_user_id;
@property (nonatomic, strong) NSString *from_user_type;
@property (nonatomic, strong) NSString *handler_id;
@property (nonatomic, strong) NSString *inOut;

@property (nonatomic, strong) NSString *product_big_classify;
@property (nonatomic, strong) NSString *product_small_classify;
@property (nonatomic, strong) NSString *service_type;
@end

//
//  DetailViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/14.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DetailPageBaseViewController.h"
#import "DetailTaskPlanTableViewCell.h"
#import "CSDetailTaskTableViewCell.h"
#import "ProductTableViewCell.h"
#import "ServiceTypeTableViewCell.h"
#import "ChargebackTableViewCell.h"
#import "OverTableViewCell.h"
#import "AssessTableViewCell.h"
#import "PayMoneyTableViewCell.h"
#import "RefuseTableViewCell.h"

@interface DetailViewController : DetailPageBaseViewController

@property (nonatomic, assign) NSInteger fromFuck;

@property (nonatomic, assign) NSInteger flag;

@property (nonatomic, assign) NSInteger state;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *from;
@property (nonatomic, strong) NSString *fromPhone;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *location;

@property (nonatomic, strong) NSString *productType;
@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *buyDate;
@property (nonatomic, strong) NSString *productCode;
@property (nonatomic, strong) NSString *orderCode;
@property (nonatomic, strong) NSString *inOut;

@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSString *appointment;
@property (nonatomic, strong) NSString *servicePs;

@property (nonatomic, strong) NSString *chargeBackContent;
@property (nonatomic, strong) NSString *refuseContent;

@property (nonatomic, strong) NSString *overDate;
@property (nonatomic, strong) NSString *overPs;

@property (nonatomic, strong) NSString *serviceAssess;

@property (nonatomic, strong) NSString *waiterName;



@property (nonatomic, strong) NSString *fromUserID;
@property (nonatomic, strong) NSString *fromUserName;
@property (nonatomic, strong) NSString *toUserID;
@property (nonatomic, strong) NSString *toUserName;

@property (nonatomic, strong) NSString *FinishTime;
@property (nonatomic, strong) NSString *BuyerFullAddress_Incept;

@property (nonatomic, strong) NSString *payMoneyStr;
@property (nonatomic, strong) NSString *priceStr;


@property (nonatomic, strong) NSString *productBreed;
@property (nonatomic, strong) NSString *productClassify;
@property (nonatomic, strong) NSString *HandlerID;
@property (nonatomic, strong) NSString *HandlerName;
@property (nonatomic, strong) NSString *ProductBreedID;
@property (nonatomic, strong) NSString *ProductClassify1ID;
@property (nonatomic, strong) NSString *ProductClassify2ID;
@property (nonatomic, strong) NSString *ProductClassify2Name;

@property (nonatomic, strong) NSString *product;
@property (nonatomic, strong) NSString *productPrice;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *addMoney;

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
@property (nonatomic, strong) NSString *product_big_classify;
@property (nonatomic, strong) NSString *service_type;
@end

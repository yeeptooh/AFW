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
#import "SettleAccountsTableViewCell.h"

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




@property (nonatomic, strong) NSString *HandlerID;
@property (nonatomic, strong) NSString *HandlerName;


@property (nonatomic, strong) NSString *ProductClassify2Name;

@property (nonatomic, strong) NSString *product;
@property (nonatomic, strong) NSString *productPrice;
@property (nonatomic, strong) NSString *payMoney;
@property (nonatomic, strong) NSString *addMoney;


@property (nonatomic, strong) NSString *buyerProvince;
@property (nonatomic, strong) NSString *buyerCity;
@property (nonatomic, strong) NSString *buyerTown;
@property (nonatomic, strong) NSString *buyerDistrict;
@property (nonatomic, strong) NSString *buyerAddress;

@property (nonatomic, strong) NSString *buyerProvinceID;
@property (nonatomic, strong) NSString *buyerCityID;
@property (nonatomic, strong) NSString *buyerTownID;
@property (nonatomic, strong) NSString *buyerDistrictID;

@property (nonatomic, strong) NSString *productBreed;
@property (nonatomic, strong) NSString *ProductBreedID;

@property (nonatomic, strong) NSString *productClassify;
@property (nonatomic, strong) NSString *ProductClassify1ID;
@property (nonatomic, strong) NSString *ProductClassify2ID;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *inOut;
@property (nonatomic, strong) NSString *serviceClassify;
@property (nonatomic, strong) NSString *postScript;
@property (nonatomic, strong) NSString *isFree;
@property (nonatomic, strong) NSString *serviceClassifyID;


@property (nonatomic, strong) NSString *settleAccount;

@end

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
@property (nonatomic, strong) NSString *BuyerFullAddress_Incept;
@property (nonatomic, strong) NSString *payMoneyStr;
@property (nonatomic, strong) NSString *priceStr;

@end

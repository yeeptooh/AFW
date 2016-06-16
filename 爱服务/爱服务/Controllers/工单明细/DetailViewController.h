//
//  DetailViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/14.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DetailPageBaseViewController.h"
#import "DetailTaskPlanTableViewCell.h"
#import "ProductTableViewCell.h"
#import "ServiceTypeTableViewCell.h"
#import "ChargebackTableViewCell.h"
#import "OverTableViewCell.h"
#import "AssessTableViewCell.h"

@interface DetailViewController : DetailPageBaseViewController
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

@end

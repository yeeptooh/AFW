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
@property (nonatomic, strong) NSString *buyDate;
@property (nonatomic, strong) NSString *serviceClassify;
@property (nonatomic, strong) NSString *appointment;
@property (nonatomic, strong) NSString *postScript;

@property (nonatomic, strong) NSString *isFree;

@end

//
//  OrderModel.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/13.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderModel : NSObject

@property (nonatomic, strong) NSString *state;

@property (nonatomic, strong) NSString *BuyerFullAddress;
@property (nonatomic, strong) NSString *BuyerProvince;
@property (nonatomic, strong) NSString *BuyerCity;
@property (nonatomic, strong) NSString *BuyerAddress;
@property (nonatomic, strong) NSString *BuyerTown;
@property (nonatomic, strong) NSString *BuyerFullAddress_Incept;

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *serviceType;
@property (nonatomic, strong) NSString *productType;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *assess;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *area;

@property (nonatomic, strong) NSString *PayMoney;
@property (nonatomic, strong) NSString *AddMoney;

@property (nonatomic, strong) NSString *fromUserName;
@property (nonatomic, strong) NSString *fromUserPhone;


@property (nonatomic, strong) NSString *model;
@property (nonatomic, strong) NSString *buyDate;
@property (nonatomic, strong) NSString *productCode;
@property (nonatomic, strong) NSString *orderCode;
@property (nonatomic, strong) NSString *inOut;

@property (nonatomic, strong) NSString *appointment;
@property (nonatomic, strong) NSString *postScript;

@property (nonatomic, strong) NSString *chargeBackContent;
@property (nonatomic, strong) NSString *refuseContent;



@property (nonatomic, strong) NSString *productBreed;
@property (nonatomic, strong) NSString *productClassify;


@property (nonatomic, strong) NSString *FromUserID;
@property (nonatomic, strong) NSString *ToUserID;
@property (nonatomic, strong) NSString *ToUserName;
@property (nonatomic, strong) NSString *HandlerID;
@property (nonatomic, strong) NSString *HandlerName;
@property (nonatomic, strong) NSString *ProductBreedID;

@property (nonatomic, strong) NSString *ProductClassify1ID;
@property (nonatomic, strong) NSString *ProductClassify2ID;

@property (nonatomic, strong) NSString *ProductClassify2Name;
@property (nonatomic, strong) NSString *WaiterName;

+ (instancetype)orderFromDictionary:(NSDictionary *)dictionary;

@end

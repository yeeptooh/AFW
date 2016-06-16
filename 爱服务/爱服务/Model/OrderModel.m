//
//  OrderModel.m
//  爱服务
//
//  Created by 张冬冬 on 16/4/13.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "OrderModel.h"

@implementation OrderModel

+ (instancetype)orderFromDictionary:(NSDictionary *)dictionary {
    return [[self alloc]initWithDictionary:dictionary];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if (self) {
        self.state = dictionary[@"State"];
        self.BuyerFullAddress = dictionary[@"BuyerFullAddress"];
        self.BuyerProvince = dictionary[@"BuyerProvince"];        
        self.BuyerFullAddress_Incept = dictionary[@"BuyerFullAddress_Incept"];
        self.BuyerAddress = dictionary[@"BuyerAddress"];
        
        self.BuyerCity = dictionary[@"BuyerCity"];
        
        self.ID = [dictionary[@"ID"] integerValue];
        self.date = dictionary[@"ExpectantTimeStr"];
        self.serviceType = [NSString stringWithFormat:@"[%@]",dictionary[@"ServiceClassify"]];
        self.productBreed = dictionary[@"ProductBreed"];
        self.productClassify = dictionary[@"ProductClassify"];
        self.productType = [NSString stringWithFormat:@"%@%@",dictionary[@"ProductBreed"],dictionary[@"ProductClassify"]];
        self.name = dictionary[@"BuyerName"];
        self.phone = dictionary[@"BuyerPhone"];
        self.location = dictionary[@"BuyerAddress"];
        self.assess = dictionary[@"StateStr"];
        self.area = dictionary[@"BuyerDistrict"];
        if ([dictionary[@"IsFree"] integerValue] || [dictionary[@"PayMoney"] integerValue] > 0) {
            self.price = [NSString stringWithFormat:@"%@元",dictionary[@"PayMoneyIncept"]];

        }else{
            self.price = [NSString stringWithFormat:@"%@元",dictionary[@"PriceAdvice"]];
        }
        self.PayMoney = dictionary[@"PayMoney"];
        self.AddMoney = dictionary[@"AddMoney"];
        
        self.fromUserName = dictionary[@"FromUserName"];
        self.fromUserPhone = dictionary[@"FromUserPhone"];
        
        
        self.model = dictionary[@"ProductType"];
        self.buyDate = dictionary[@"BuyTimeStr"];
        self.productCode = dictionary[@"BarCode"];
        self.orderCode = dictionary[@"OrderNumber"];
        NSString *inOutStr = dictionary[@"PriceStr"];
        self.inOut = [inOutStr substringToIndex:2];
        
        
        
        self.appointment = dictionary[@"ExpectantTimeStr"];
        self.postScript = dictionary[@"Postscript"];
        
        
        
        self.chargeBackContent = dictionary[@"BacktrackRemark"];
        self.refuseContent = dictionary[@"RefuseRemark"];
        
        self.FromUserID = dictionary[@"FromUserID"];
        self.ToUserID = dictionary[@"ToUserID"];
        self.ToUserName = dictionary[@"ToUserName"];
        self.HandlerID = dictionary[@"HandlerID"];
        self.HandlerName = dictionary[@"HandlerName"];
        self.ProductBreedID = dictionary[@"ProductBreedID"];
        
        self.ProductClassify1ID = dictionary[@"ProductClassify1ID"];
        self.ProductClassify2ID = dictionary[@"ProductClassify2ID"];
        
        self.ProductClassify2Name = dictionary[@"ProductClassify"];
        self.WaiterName = dictionary[@"WaiterName"];
        //TODO
        //完工信息和服务评价的字段后台未设置
   
 
    }
    return self;
}

@end

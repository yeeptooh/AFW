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
        
#if Environment_Mode == 1
        NSString *timeString = dictionary[@"AddTime"];
        
        NSRange range = [timeString rangeOfString:@"("];
        NSRange range1 = [timeString rangeOfString:@")"];
        NSInteger loc = range.location;
        NSInteger len = range1.location - range.location;
        NSString *newtimeString = [timeString substringWithRange:NSMakeRange(loc + 1, len - 1)];
        // 时间戳转时间
        double lastactivityInterval = [newtimeString doubleValue];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        
        [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
        [formatter setDateFormat:@"yyyy年MM月dd日"];
        NSDate *publishDate = [NSDate dateWithTimeIntervalSince1970:lastactivityInterval/1000];
        
        NSDate *date = [NSDate date];
        NSTimeZone *zone = [NSTimeZone systemTimeZone];
        NSInteger interval = [zone secondsFromGMTForDate:date];
        publishDate = [publishDate  dateByAddingTimeInterval: interval];
        NSString *appointmentTime = [formatter stringFromDate:publishDate];
        NSString *yearStr = [appointmentTime substringToIndex:4];
        NSString *monthStr = [appointmentTime substringWithRange:NSMakeRange(5, 2)];
        NSString *dayStr = [appointmentTime substringWithRange:NSMakeRange(8, 2)];
        NSInteger month = [monthStr integerValue];
        NSInteger day = [dayStr integerValue];
        NSString *AddTime = [NSString stringWithFormat:@"%@-%02ld-%02ld",yearStr,(long)month,(long)day];
        self.acceptDate = AddTime;
        
#elif Environment_Mode == 2
#endif
        
        self.date = dictionary[@"ExpectantTimeStr"];
        self.serviceType = [NSString stringWithFormat:@"[%@]",dictionary[@"ServiceClassify"]];
        self.productBreed = dictionary[@"ProductBreed"];
        self.productClassify = dictionary[@"ProductClassify"];
        self.productType = [NSString stringWithFormat:@"%@%@",dictionary[@"ProductBreed"],dictionary[@"ProductClassify"]];
        self.name = dictionary[@"BuyerName"];
        self.phone = dictionary[@"BuyerPhone"];
        
        if ([dictionary[@"BuyerPhone"] isEqualToString:@""] || !dictionary[@"BuyerPhone"]) {
            self.phone = dictionary[@"BuyerTel"];
        }
        
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

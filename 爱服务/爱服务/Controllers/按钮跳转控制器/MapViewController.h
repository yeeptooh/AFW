//
//  MapViewController.h
//  爱服务
//
//  Created by 张冬冬 on 16/5/27.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DetailPageBaseViewController.h"
/*
 self.BuyerProvince = dictionary[@"BuyerProvince"];
 self.BuyerFullAddress_Incept = dictionary[@"BuyerFullAddress_Incept"];
 self.BuyerAddress = dictionary[@"BuyerAddress"];
 
 */
@interface MapViewController : DetailPageBaseViewController

@property (nonatomic, strong) NSString *BuyerFullAddress;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *BuyerProvince;
@property (nonatomic, strong) NSString *BuyerCity;
@property (nonatomic, strong) NSString *BuyerAddress;
@property (nonatomic, strong) NSString *BuyerFullAddress_Incept;
@end

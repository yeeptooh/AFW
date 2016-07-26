//
//  ProductDetailTableView.h
//  爱服务
//
//  Created by 张冬冬 on 16/6/23.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductDetailTableView : UITableView
@property (nonatomic, assign) NSInteger baoxiuIndex;

@property (nonatomic, strong) NSString *FtypeID;
@property (nonatomic, strong) NSString *FbigID;
@property (nonatomic, strong) NSString *FsmallID;

@property (nonatomic, strong) NSString *YtypeID;
@property (nonatomic, strong) NSString *YbigID;
@property (nonatomic, strong) NSString *YsmallID;

@property (nonatomic, strong) NSString *productBreed;
@property (nonatomic, strong) NSString *ProductBreedID;
@property (nonatomic, strong) NSString *productClassify;

@property (nonatomic, strong) NSString *ProductClassify1ID;
@property (nonatomic, strong) NSString *ProductClassify2ID;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *inOut;
@property (nonatomic, strong) NSString *buyDate;

@end

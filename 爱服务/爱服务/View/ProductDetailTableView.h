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
@end

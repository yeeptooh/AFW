//
//  BusinessDetailTableView.h
//  爱服务
//
//  Created by 张冬冬 on 16/6/23.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessDetailTableView : UITableView
@property (nonatomic, assign) NSInteger serviceID;
@property (nonatomic, assign) NSInteger YserviceID;
@property (nonatomic, strong) NSString *serviceClassify;
@property (nonatomic, strong) NSString *appointment;
@property (nonatomic, strong) NSString *postScript;

@property (nonatomic, strong) NSString *isFree;
@end

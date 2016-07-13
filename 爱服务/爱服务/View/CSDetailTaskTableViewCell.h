//
//  CSDetailTaskTableViewCell.h
//  爱服务
//
//  Created by 张冬冬 on 16/7/13.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CSDetailTaskTableViewCell : UITableViewCell
@property (nonatomic, strong) NSString *taskId;
@property (nonatomic, strong) NSString *phone;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromPhoneLabel;
@property (weak, nonatomic) IBOutlet UIButton *mapButton;
@property (weak, nonatomic) IBOutlet UIButton *locationButton;
@end

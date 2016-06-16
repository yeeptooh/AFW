//
//  MainTableViewCell.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/13.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *serviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *productTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *assessLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;

@property (nonatomic, assign) NSInteger flag;
@property (weak, nonatomic) IBOutlet UIButton *robButton;

@end

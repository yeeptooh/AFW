//
//  ProductTableViewCell.h
//  爱服务
//
//  Created by 张冬冬 on 16/4/15.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductTableViewCell : UITableViewCell
<
UIViewControllerTransitioningDelegate
>
@property (weak, nonatomic) IBOutlet UIButton *typeButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;
@property (weak, nonatomic) IBOutlet UILabel *productCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *inOutLabel;

@end

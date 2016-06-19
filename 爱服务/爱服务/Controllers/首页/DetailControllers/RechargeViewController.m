//
//  RechargeViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/15.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "RechargeViewController.h"
#import "MoneyTableViewCell.h"
#import "PayTableViewCell.h"
@interface RechargeViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextFieldDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign, getter=isHaveDot) BOOL haveDot;
@property (nonatomic, strong) UIButton *rechargeButton;
@end

static NSInteger i = 0;
@implementation RechargeViewController

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, Width, 44*3+60) style:UITableViewStyleGrouped];
        
        _tableView.bounces = NO;
        _tableView.scrollEnabled = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
//        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableFooterView = [[UIView alloc] init];
        
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = color(239, 239, 244, 1);
    [self.view addSubview:self.tableView];
    [self setRechargeButton];
    [self setNaviTitle];
}


- (void)setRechargeButton {
    self.rechargeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
    self.rechargeButton.layer.cornerRadius = 5;
    self.rechargeButton.layer.masksToBounds = YES;
    [self.rechargeButton setTitleColor:color(240, 240, 240, 1) forState:UIControlStateNormal];
    [self.rechargeButton addTarget:self action:@selector(rechargeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rechargeButton.userInteractionEnabled = NO;
    self.rechargeButton.backgroundColor = color(231, 76, 60, 1);
    CGFloat height;
    if (iPhone4_4s || iPhone5_5s) {
        height = 44;
    }else {
        height = 49;
    }
    self.rechargeButton.frame = CGRectMake(40, 44*3+60 + 20, Width - 80, height);
    [self.view addSubview:self.rechargeButton];

}


- (void)editingChanged:(UITextField *)sender {
    
    
    if ([sender.text rangeOfString:@"."].location==NSNotFound) {
        
        self.haveDot=NO;
    }
    
    if (sender.text.length > 0) {
        unichar single=[sender.text characterAtIndex:sender.text.length - 1];
        
        if (sender.text.length == 1 && (single == '.' || single == '0')) {
            sender.text = @"";
            self.haveDot=NO;
            return;
        }
        
        if (single == '.') {
            if (self.isHaveDot) {
                NSString *str = [sender.text substringToIndex:sender.text.length - 1];
                sender.text = str;
                return;
            }else {
                self.haveDot = YES;
            }
        }
        
        if (self.isHaveDot) {
            NSRange range = [sender.text rangeOfString:@"."];
            
            NSUInteger length = sender.text.length - range.location;
            if (length > 3) {
                NSString *str = [sender.text substringToIndex:sender.text.length - 1];
                sender.text = str;
                return;
            }
        }
        
    }
  
}

- (void)rechargeButtonClicked:(UIButton *)sender {
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else {
        return 2;
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        MoneyTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MoneyTableViewCell" owner:self options:nil] lastObject];
        cell.moneyTextField.delegate = self;
        cell.moneyTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [cell.moneyTextField addTarget:self action:@selector(editingChanged:) forControlEvents:UIControlEventEditingChanged];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else {
        PayTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"PayTableViewCell" owner:self options:nil]lastObject];
        
        if (indexPath.row == 0) {
            cell.payLabel.text = @"支付宝钱包支付";
            cell.payImageView.image = [UIImage imageNamed:@"alipay"];
            cell.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_normal"];
        }else {
            cell.payLabel.text = @"微信客户端支付";
            cell.payImageView.image = [UIImage imageNamed:@"weixin"];
            cell.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_normal"];
        }
        
        return cell;
    }

}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        MoneyTableViewCell *cell = (MoneyTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell.moneyTextField becomeFirstResponder];
    }else {
        [self.view endEditing:YES];
        if (indexPath.row == 0) {
            
            i = 1;
            
            PayTableViewCell *cell1 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell1.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_selected"];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:1 inSection:1];
            PayTableViewCell *cell2 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
            cell2.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_normal"];
 
            
        }else {
            
            i = 2;
            
            PayTableViewCell *cell1 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
            cell1.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_selected"];
            
            NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:1];
            PayTableViewCell *cell2 = (PayTableViewCell *)[tableView cellForRowAtIndexPath:indexpath];
            cell2.chooseImageView.image = [UIImage imageNamed:@"rate_annoy_button_normal"];
        }
    }

}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGFloat height;
    if (section == 0) {
        height = 20;
    }else {
        height = 40;
    }
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = color(239, 239, 244, 1);
    button.frame = CGRectMake(0, 0, Width, height);
    if (section == 1) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, Width, 40)];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"选择支付方式";
        label.font = font(14);
        [button addSubview:label];
        
    }
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return button;
    
}

- (void)buttonClicked:(UIButton *)sender {
    [self.view endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    return YES;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 20;
    }else {
        return 40;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


- (void)setNaviTitle {
    self.navigationItem.title = @"我要充值";
}


@end

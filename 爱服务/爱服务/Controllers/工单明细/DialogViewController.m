//
//  DialogViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/29.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DialogViewController.h"
#import "DialogTableViewCell.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
@interface DialogViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITapGestureRecognizer *tap;
@property (nonatomic, strong) UIView *whiteView;

@end

@implementation DialogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.layer.cornerRadius = 5;
    self.view.layer.masksToBounds = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self configView];
}

- (void)configView {
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.frame = CGRectMake(0, Height - 200 - 50, self.view.bounds.size.width - 40, 50);
    closeButton.backgroundColor = BlueColor;
    [closeButton addTarget:self action:@selector(closeButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeButton];
    
    
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, Width - 150, 50)];
    self.textView.font = font(14);
    self.textView.returnKeyType = UIReturnKeyDone;
    self.textView.delegate = self;
    
    [self.view addSubview:self.textView];
    
    UILabel *line = [[UILabel alloc] init];
    line.opaque = YES;
    line.backgroundColor = beautifulGray;
    line.layer.borderColor = [UIColor lightGrayColor].CGColor;
    line.layer.borderWidth = 0.5;
    line.frame = CGRectMake(10, 60, Width - 150, 1);
    [self.view addSubview:line];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 70, Width - 40, Height - 200 - 120) style:UITableViewStylePlain];
    
//    self.tableView.backgroundColor = [UIColor blueColor];
    self.tableView.bounces = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    
    [self.tableView addGestureRecognizer:self.tap];
    
    UIButton *sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setTitle:@"发送" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendButton.frame = CGRectMake(Width - 140 + 10, 15, Width - 40 - (Width - 140) - 20, 40);
    sendButton.layer.cornerRadius = 5;
    sendButton.layer.masksToBounds = YES;
    sendButton.backgroundColor = BlueColor;
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sendButton];
    
    

}

- (void)tapAction:(UITapGestureRecognizer *)tap {
    [self.view endEditing:YES];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dialogList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%@",self.dialogList);
    DialogTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"DialogTableViewCell" owner:self options:nil] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dialogLabel.text = self.dialogList[indexPath.row][@"Content"];
    NSString *dateStr = self.dialogList[indexPath.row][@"AddTime"];
    NSString *yearStr = [dateStr substringToIndex:10];
    NSString *timeStr = [dateStr substringWithRange:NSMakeRange(11, 5)];
    cell.dateLabel.text = [NSString stringWithFormat:@"%@ %@",yearStr,timeStr];
    cell.companyLabel.text = self.dialogList[indexPath.row][@"FromUserName"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)sendButtonClicked:(UIButton *)sender {
    
    sender.userInteractionEnabled = NO;
    sender.backgroundColor = color(144, 144, 144, 1);
    
    
    [self.view endEditing:YES];
    self.textView.text = [self.textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ([self.textView.text isEqualToString:@""]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.font = font(14);
        HUD.label.text = @"请填写发送内容";
        [self.view addSubview:HUD];
        
        [HUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
            sender.userInteractionEnabled = YES;
            sender.backgroundColor = BlueColor;
            
        });
        return ;
    }
    
    
    DialogTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0 ]];
    
    if ([cell.dialogLabel.text isEqualToString:self.textView.text]) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.font = font(14);
        HUD.label.text = @"请勿发送重复内容";
        [self.view addSubview:HUD];
        
        [HUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
            sender.userInteractionEnabled = YES;
            sender.backgroundColor = BlueColor;
            
        });
        return ;
    }

    
    NSString *toName = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self.toUserName, NULL, (CFStringRef)@"!*’();:@&=+,/?%#[]", kCFStringEncodingUTF8);
//    NSString *toName = [self.toUserName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *fromName = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self.fromUserName, NULL, (CFStringRef)@"!*’();:@&=+,/?%#[]", kCFStringEncodingUTF8);
//    NSString *fromName = [self.fromUserName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *content = (__bridge NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (__bridge CFStringRef)self.textView.text, NULL, (CFStringRef)@"!*’();:@&=+,/?%#[]", kCFStringEncodingUTF8);
//    NSString *content = [self.textView.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"%@Task.ashx?action=feedbackadd&taskid=%@&touserid=%@&tousername=%@&fromuserid=%@&fromusername=%@&content=%@",HomeURL,self.taskID,self.toUserID,toName,self.fromUserID,fromName,content];
//    NSString *encodeUrl = [url stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSString *dataStr = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([dataStr isEqualToString:@"1"]) {
            
            MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
            HUD.mode = MBProgressHUDModeText;
            HUD.label.font = font(14);
            HUD.label.text = @"发送成功";
            [self.view addSubview:HUD];
            
            [HUD showAnimated:YES];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [HUD hideAnimated:YES];
                [HUD removeFromSuperViewOnHide];
            });
            
            
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            NSString *url = [NSString stringWithFormat:@"%@Task.ashx?action=getfeedbacklist&taskid=%@",HomeURL,self.taskID];
            [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (self.dialogList.count != 0) {
                    [self.dialogList removeAllObjects];
                }
                
                for (NSDictionary *dic in responseObject) {
                    [self.dialogList addObject:dic];
                }
                sender.userInteractionEnabled = YES;
                sender.backgroundColor = BlueColor;
                [self.tableView reloadData];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
                HUD.mode = MBProgressHUDModeText;
                HUD.label.font = font(14);
                HUD.label.text = @"刷新列表失败,请检查网络";
                [self.view addSubview:HUD];
                
                [HUD showAnimated:YES];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [HUD hideAnimated:YES];
                    [HUD removeFromSuperViewOnHide];
                    sender.userInteractionEnabled = YES;
                    sender.backgroundColor = BlueColor;
                });
            }];
            
        }else {
            sender.userInteractionEnabled = YES;
            sender.backgroundColor = BlueColor;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        MBProgressHUD *HUD = [[MBProgressHUD alloc]initWithView:self.view];
        HUD.mode = MBProgressHUDModeText;
        HUD.label.font = font(14);
        HUD.label.text = @"请检查网络";
        [self.view addSubview:HUD];
        
        [HUD showAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HUD hideAnimated:YES];
            [HUD removeFromSuperViewOnHide];
            sender.userInteractionEnabled = YES;
            sender.backgroundColor = BlueColor;
        });
        
    }];
 
}

- (void)closeButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)dealloc {
    [self.tableView removeGestureRecognizer:self.tap];
    
}



@end

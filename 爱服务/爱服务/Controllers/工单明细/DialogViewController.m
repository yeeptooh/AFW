//
//  DialogViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/6/29.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "DialogViewController.h"
#import "DialogTableViewCell.h"
@interface DialogViewController ()
<
UITableViewDelegate,
UITableViewDataSource,
UITextViewDelegate
>
@property (nonatomic, strong) UITableView *tableView;
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
    
    return [[UITableViewCell alloc] init];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)sendButtonClicked:(UIButton *)sender {
    
}

- (void)closeButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end

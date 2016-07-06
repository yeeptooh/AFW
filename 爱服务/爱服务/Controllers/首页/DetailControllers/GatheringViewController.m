//
//  GatheringViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/6.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "GatheringViewController.h"

@interface GatheringViewController ()
<UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIVisualEffectView *effectView;
@end

@implementation GatheringViewController

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(Width * 2, Height - StatusBarAndNavigationBarHeight);
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
        
        
        _scrollView.backgroundColor = [UIColor whiteColor];
        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, (Height - StatusBarAndNavigationBarHeight)*8/9, Width, 1)];
        
        self.pageControl.numberOfPages = 2;
        self.pageControl.currentPage = 0;
        self.pageControl.selected = NO;
        self.pageControl.pageIndicatorTintColor = [UIColor grayColor];
        self.pageControl.currentPageIndicatorTintColor = [UIColor blackColor];
        
        UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Width, 50)];
        label1.textAlignment = NSTextAlignmentCenter;
        label1.text = @"微信支付";
        label1.font = [UIFont fontWithName:@"HYQiHei-55S" size:16];
        
        UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(Width, 0, Width, 50)];
        label2.textAlignment = NSTextAlignmentCenter;
        label2.text = @"支付宝支付";
        label2.font = [UIFont fontWithName:@"HYQiHei-55S" size:16];
        
        [_scrollView addSubview:label1];
        [_scrollView addSubview:label2];
        
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNaviTitle];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
   
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageControl setCurrentPage:roundf(scrollView.contentOffset.x/self.view.bounds.size.width)];
}

- (void)setNaviTitle {
    self.navigationItem.title = @"我要收款";
}

@end

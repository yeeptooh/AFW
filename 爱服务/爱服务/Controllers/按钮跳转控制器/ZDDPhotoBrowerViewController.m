//
//  ZDDPhotoBrowerViewController.m
//  爱服务
//
//  Created by 张冬冬 on 16/7/29.
//  Copyright © 2016年 张冬冬. All rights reserved.
//

#import "ZDDPhotoBrowerViewController.h"
#import "UIImageView+WebCache.h"
@interface ZDDPhotoBrowerViewController ()
<
UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout
>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSIndexPath *indexPath;
@property (nonatomic, strong) UIImageView *cellSnap;
@property (nonatomic, strong) UIView *sceneSnap;
@property (nonatomic, assign) CGPoint center;
@end

@implementation ZDDPhotoBrowerViewController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, Width, Height - StatusBarAndNavigationBarHeight) collectionViewLayout:flowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        //注册Cell，必须要有
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
        [self.view addSubview:self.collectionView];
    }
    return _collectionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.view addSubview:self.collectionView];
    [self setNaviTitle];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoList.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"UICollectionViewCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];

    cell.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:cell.bounds];
    
    [imageView sd_setImageWithURL:self.photoList[indexPath.row]];
    
    [cell.contentView addSubview:imageView];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return CGSizeMake(Width/4-10, Width/4-10);
}

//定义每个UICollectionView 的 margin
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    self.cellSnap = [[UIImageView alloc] initWithFrame:cell.bounds];
    [cell addSubview:self.cellSnap];
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.photoList[indexPath.row]]];

    self.cellSnap.image = [UIImage imageWithData:data];
    self.sceneSnap = [self.view snapshotViewAfterScreenUpdates:YES];
    UIView *bgView = [[UIView alloc] initWithFrame:self.sceneSnap.bounds];
    bgView.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6];
    
    [self.sceneSnap addSubview:bgView];
    [self.view addSubview:self.sceneSnap];
    self.cellSnap.userInteractionEnabled = YES;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = self.sceneSnap.bounds;
    [self.sceneSnap addSubview:button];
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:self.cellSnap];
    
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    basicAnimation.duration = 0.25;
    basicAnimation.toValue = @((Width - 20)/(Width/4-10));
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    self.center = cell.center;
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.25;
    positionAnimation.fromValue = [NSValue valueWithCGPoint:cell.center];
    positionAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(self.view.center.x, self.view.center.y - 100)];
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode = kCAFillModeForwards;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[basicAnimation, positionAnimation];
    group.duration = 0.25;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [group setValue:@"big" forKey:@"anim"];
    [self.cellSnap.layer addAnimation:group forKey:@"group"];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
    if ([[anim valueForKey:@"anim"] isEqualToString:@"big"]) {
        self.cellSnap.userInteractionEnabled = YES;
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, Width - 20, Width - 20);
        [self.cellSnap addSubview:button];
        [button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    }else if ([[anim valueForKey:@"anim"] isEqualToString:@"small"]) {
        [self.cellSnap removeFromSuperview];
        [self.sceneSnap removeFromSuperview];
    }
}

- (void)buttonClicked {
    [UIView animateWithDuration:0.25 animations:^{
        self.sceneSnap.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    
    basicAnimation.duration = 0.25;
    basicAnimation.toValue = @((Width/4-10)*1.0/(Width - 20));
    basicAnimation.removedOnCompletion = NO;
    basicAnimation.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *positionAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = 0.25;
    
    positionAnimation.toValue = [NSValue valueWithCGPoint:self.center];
    positionAnimation.removedOnCompletion = NO;
    positionAnimation.fillMode = kCAFillModeForwards;
    
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[basicAnimation, positionAnimation];
    group.duration = 0.25;
    group.removedOnCompletion = NO;
    group.fillMode = kCAFillModeForwards;
    group.delegate = self;
    [group setValue:@"small" forKey:@"anim"];
    [self.cellSnap.layer addAnimation:group forKey:@"backGroup"];
    
}



- (void)setNaviTitle {
    self.navigationItem.title = @"已上传图片";
}

- (void)dealloc {
    NSLog(@"zddPhoto dealloc");
}


@end

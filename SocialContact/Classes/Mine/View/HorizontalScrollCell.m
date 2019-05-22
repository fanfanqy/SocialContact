//
//  HorizontalScrollCell.m
//  ShiQi
//
//  Created by fqy on 2017/12/4.
//  Copyright © 2017年 Hangzhou Jiyuan Jingshe Trade Co,. Ltd. All rights reserved.
//

#import "HorizontalScrollCell.h"
#import "HorzonItemCell.h"

@implementation HorizontalScrollCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setUpView];
        
    }
    return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUpView];
    }
    return self;
    
}

- (void)setUpView
{
    UICollectionViewFlowLayout *horizontalCellLayout = [UICollectionViewFlowLayout new];
    horizontalCellLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    horizontalCellLayout.minimumLineSpacing = 2;
    horizontalCellLayout.sectionInset = UIEdgeInsetsMake(30, 15, 5, 15);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:horizontalCellLayout];
    [_collectionView registerClass:[HorzonItemCell class] forCellWithReuseIdentifier:@"HorzonItemCell"];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    [_collectionView registerClass:[HorzonItemCell class] forCellWithReuseIdentifier:@"HorzonItemCell"];
    [self.contentView addSubview:_collectionView];
    
    UIView *superView = self.contentView;
    
    // 添加相对布局
    _collectionView.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSArray *constrainArray = @[@(NSLayoutAttributeTop),@(NSLayoutAttributeBottom),@(NSLayoutAttributeLeading),@(NSLayoutAttributeTrailing),@(NSLayoutAttributeWidth)];
    WEAKSELF;
    [constrainArray enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        [superView addConstraint:[NSLayoutConstraint constraintWithItem:weakSelf.collectionView
                                                              attribute:obj.intValue
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:superView
                                                              attribute:obj.intValue
                                                             multiplier:1.0
                                                               constant:0]];
    }];
    
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(15, 10, 140, 20);
    label.text = @"我的相册";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = Font_color333;
    _labelT = label;
    [self.contentView addSubview:_labelT];
    
}

- (void)reloadData
{
    //_tableViewIndexPath.item*([UIScreen mainScreen].bounds.size.width-20-15.0)/4.0
    [_collectionView scrollRectToVisible:CGRectMake(0, 0, 140, 70) animated:NO];
    [_collectionView reloadData];
}

- (void)setDataSource:(NSMutableArray *)dataSource{
    _dataSource = dataSource;
    [self reloadData];
}

#pragma mark - UICollectionView data source

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width-30-6.0)/4.0, ([UIScreen mainScreen].bounds.size.width-30-6.0)/4.0);
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    HorzonItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HorzonItemCell" forIndexPath:indexPath];
    cell.url = self.dataSource[indexPath.item];
    return cell;
    
}

#pragma mark - UICollectionView delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate horizontalCellContentsView:collectionView didSelectItemAtContentIndexPath:indexPath inTableViewIndexPath:self.tableViewIndexPath];
}


@end
